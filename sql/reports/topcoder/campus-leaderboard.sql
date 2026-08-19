-- Campus program leaderboard: every member of the requested group (including
-- members with no challenge activity at all) with one row per challenge they
-- registered for, submitted to, or won. Members without activity come back as a
-- single row with a NULL "challengeId".
-- $1 = group name (case insensitive, also accepts the group id / legacy id)
WITH RECURSIVE params AS (
  SELECT LOWER(BTRIM($1)) AS group_key
),
root_group AS (
  SELECT
    g.id,
    g.name,
    g."oldId"
  FROM groups."Group" AS g
  CROSS JOIN params AS p
  WHERE LOWER(g.name) = p.group_key
     OR LOWER(g.id) = p.group_key
     OR LOWER(COALESCE(g."oldId", '')) = p.group_key
  ORDER BY (LOWER(g.name) = p.group_key) DESC, g."createdAt" ASC
  LIMIT 1
),
group_tree AS (
  SELECT rg.id
  FROM root_group AS rg
  UNION
  SELECT gm."memberId"
  FROM groups."GroupMember" AS gm
  JOIN group_tree AS gt
    ON gt.id = gm."groupId"
  WHERE LOWER(gm."membershipType") = 'group'
),
group_identifiers AS (
  SELECT ARRAY(
    SELECT DISTINCT identifier
    FROM (
      SELECT rg.id AS identifier FROM root_group AS rg
      UNION ALL
      SELECT rg."oldId" FROM root_group AS rg WHERE NULLIF(BTRIM(rg."oldId"), '') IS NOT NULL
    ) AS identifiers
  ) AS identifiers
),
group_members AS (
  SELECT
    gm."memberId" AS member_id,
    MIN(gm."createdAt") AS joined_at
  FROM groups."GroupMember" AS gm
  JOIN group_tree AS gt
    ON gt.id = gm."groupId"
  WHERE LOWER(gm."membershipType") = 'user'
    AND gm."memberId" ~ '^[0-9]+$'
  GROUP BY gm."memberId"
),
registrant_roles AS (
  SELECT rr.id
  FROM resources."ResourceRole" AS rr
  WHERE rr."nameLower" IN ('submitter', 'registrant')
),
member_registrations AS (
  SELECT
    r."memberId" AS member_id,
    r."challengeId" AS challenge_id,
    MIN(r."createdAt") AS registered_at
  FROM resources."Resource" AS r
  JOIN group_members AS gm
    ON gm.member_id = r."memberId"
  WHERE r."roleId" IN (SELECT id FROM registrant_roles)
  GROUP BY r."memberId", r."challengeId"
),
scored_submissions AS (
  SELECT
    s."memberId" AS member_id,
    s."challengeId" AS challenge_id,
    COALESCE(s."submittedDate", s."createdAt") AS submitted_date,
    COALESCE(
      CASE
        WHEN challenge_reviewers.is_ai_only_challenge
          THEN ai_decision."totalScore"
        ELSE final_review."aggregateScore"
      END,
      s."finalScore"::double precision,
      s."initialScore"::double precision
    ) AS score,
    CASE
      WHEN challenge_reviewers.is_ai_only_challenge
        THEN UPPER(COALESCE(ai_decision.status::text, '')) = 'PASSED'
      ELSE COALESCE(
        final_review."isPassing",
        CASE
          WHEN COALESCE(
                 final_review."aggregateScore",
                 s."finalScore"::double precision,
                 s."initialScore"::double precision
               ) IS NULL
            THEN FALSE
          ELSE COALESCE(
                 final_review."aggregateScore",
                 s."finalScore"::double precision,
                 s."initialScore"::double precision
               ) >= COALESCE(sc."minimumPassingScore", sc."minScore", 0)
        END
      )
    END AS is_passing
  FROM reviews.submission AS s
  JOIN group_members AS gm
    ON gm.member_id = s."memberId"
  LEFT JOIN LATERAL (
    SELECT rs."aggregateScore", rs."scorecardId", rs."isPassing"
    FROM reviews."reviewSummation" AS rs
    WHERE rs."submissionId" = s.id
      AND COALESCE(rs."isFinal", TRUE) = TRUE
      AND rs."isProvisional" IS DISTINCT FROM TRUE
    ORDER BY COALESCE(rs."reviewedDate", rs."createdAt") DESC NULLS LAST, rs.id DESC
    LIMIT 1
  ) AS final_review ON TRUE
  LEFT JOIN LATERAL (
    SELECT
      BOOL_AND(cr."aiWorkflowId" IS NOT NULL AND cr."isMemberReview" = FALSE)
        AND COUNT(*) > 0 AS is_ai_only_challenge
    FROM challenges."ChallengeReviewer" AS cr
    WHERE cr."challengeId" = s."challengeId"
  ) AS challenge_reviewers ON TRUE
  LEFT JOIN LATERAL (
    SELECT d."totalScore", d.status
    FROM reviews."aiReviewDecision" AS d
    WHERE d."submissionId" = s.id
      AND UPPER(d.status::text) != 'PENDING'
    ORDER BY d."updatedAt" DESC NULLS LAST
    LIMIT 1
  ) AS ai_decision ON TRUE
  LEFT JOIN reviews.scorecard AS sc
    ON sc.id = final_review."scorecardId"
  WHERE s."challengeId" IS NOT NULL
    AND s.type = 'CONTEST_SUBMISSION'
    AND s.status <> 'DELETED'
),
-- At most one submission (and one passing submission) is counted per member per challenge.
member_submissions AS (
  SELECT
    ss.member_id,
    ss.challenge_id,
    MIN(ss.submitted_date) AS first_submitted_date,
    BOOL_OR(COALESCE(ss.is_passing, FALSE)) AS has_passing_submission,
    MAX(ss.score) FILTER (WHERE ss.score IS NOT NULL) AS best_score
  FROM scored_submissions AS ss
  GROUP BY ss.member_id, ss.challenge_id
),
member_wins AS (
  SELECT
    cw."userId"::text AS member_id,
    cw."challengeId" AS challenge_id,
    MIN(cw.placement) AS placement
  FROM challenges."ChallengeWinner" AS cw
  JOIN group_members AS gm
    ON gm.member_id = cw."userId"::text
  WHERE cw.placement = 1
    AND cw.type = 'PLACEMENT'
  GROUP BY cw."userId", cw."challengeId"
),
participation AS (
  SELECT member_id, challenge_id FROM member_registrations
  UNION
  SELECT member_id, challenge_id FROM member_submissions
  UNION
  SELECT member_id, challenge_id FROM member_wins
),
member_participation AS (
  SELECT
    p.member_id,
    c.id AS challenge_id,
    c.name AS challenge_name,
    c.status::text AS challenge_status,
    ct.name AS challenge_type,
    ctr.name AS challenge_track,
    COALESCE(c."endDate", c."submissionEndDate", c."startDate") AS challenge_end_date,
    (c.groups && gi.identifiers) AS is_campus_challenge,
    (COALESCE(ARRAY_LENGTH(c.groups, 1), 0) = 0) AS is_public_challenge,
    reg.registered_at,
    (reg.member_id IS NOT NULL) AS registered,
    (sub.member_id IS NOT NULL) AS submitted,
    COALESCE(sub.has_passing_submission, FALSE) AS passed_review,
    sub.first_submitted_date,
    sub.best_score,
    (win.member_id IS NOT NULL) AS won,
    win.placement
  FROM participation AS p
  CROSS JOIN group_identifiers AS gi
  JOIN challenges."Challenge" AS c
    ON c.id = p.challenge_id
  LEFT JOIN challenges."ChallengeType" AS ct
    ON ct.id = c."typeId"
  LEFT JOIN challenges."ChallengeTrack" AS ctr
    ON ctr.id = c."trackId"
  LEFT JOIN member_registrations AS reg
    ON reg.member_id = p.member_id
   AND reg.challenge_id = p.challenge_id
  LEFT JOIN member_submissions AS sub
    ON sub.member_id = p.member_id
   AND sub.challenge_id = p.challenge_id
  LEFT JOIN member_wins AS win
    ON win.member_id = p.member_id
   AND win.challenge_id = p.challenge_id
),
max_rating AS (
  SELECT DISTINCT ON (mmr."userId")
    mmr."userId",
    mmr.rating,
    mmr."ratingColor"
  FROM members."memberMaxRating" AS mmr
  ORDER BY mmr."userId", mmr.rating DESC
)
SELECT
  gm.member_id AS "userId",
  COALESCE(
    NULLIF(BTRIM(u.handle), ''),
    NULLIF(BTRIM(mem.handle), '')
  ) AS handle,
  mem."firstName" AS "firstName",
  mem."lastName" AS "lastName",
  mem."photoURL" AS "photoURL",
  mr.rating AS rating,
  mr."ratingColor" AS "ratingColor",
  gm.joined_at AS "groupJoinedAt",
  u.create_date AS "memberSince",
  mp.challenge_id AS "challengeId",
  mp.challenge_name AS "challengeName",
  mp.challenge_status AS "challengeStatus",
  mp.challenge_type AS "challengeType",
  mp.challenge_track AS "challengeTrack",
  mp.challenge_end_date AS "challengeEndDate",
  mp.is_campus_challenge AS "isCampusChallenge",
  mp.is_public_challenge AS "isPublicChallenge",
  mp.registered_at AS "registeredAt",
  mp.registered AS registered,
  mp.submitted AS submitted,
  mp.passed_review AS "passedReview",
  mp.first_submitted_date AS "submittedDate",
  mp.best_score AS score,
  mp.won AS won,
  mp.placement AS placement
FROM group_members AS gm
LEFT JOIN members."member" AS mem
  ON mem."userId" = gm.member_id::bigint
LEFT JOIN identity."user" AS u
  ON u.user_id = gm.member_id::numeric
LEFT JOIN max_rating AS mr
  ON mr."userId" = gm.member_id::bigint
LEFT JOIN member_participation AS mp
  ON mp.member_id = gm.member_id
ORDER BY gm.member_id, mp.challenge_end_date DESC NULLS LAST, mp.challenge_id;
