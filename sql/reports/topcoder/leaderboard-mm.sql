WITH challenge_context AS (
  SELECT
    c.id AS challenge_id,
    c.name AS challenge_name,
    LOWER(ct.name) = 'marathon match' AS is_marathon_match
  FROM challenges."Challenge" AS c
  JOIN challenges."ChallengeType" AS ct
    ON ct.id = c."typeId"
  WHERE c.id = ANY($1::text[])
),
submission_metrics AS (
  SELECT
    cc.challenge_id,
    s.id AS submission_id,
    s."memberId" AS user_id,
    COALESCE(
      NULLIF(TRIM(u.handle), ''),
      NULLIF(TRIM(mem.handle), ''),
      fallback.member_handle
    ) AS handle,
    COALESCE(final_review."aggregateScore", s."finalScore"::double precision) AS standard_score,
    provisional_review.provisional_score,
    COALESCE(final_review."aggregateScore", s."finalScore"::double precision) AS final_score_raw,
    COALESCE(s."submittedDate", s."createdAt") AS submitted_date
  FROM challenge_context AS cc
  JOIN reviews."submission" AS s
    ON s."challengeId" = cc.challenge_id
   AND s."memberId" IS NOT NULL
  LEFT JOIN LATERAL (
    SELECT rs."aggregateScore"
    FROM reviews."reviewSummation" AS rs
    WHERE rs."submissionId" = s.id
      AND COALESCE(rs."isFinal", TRUE) = TRUE
      AND rs."isProvisional" IS DISTINCT FROM TRUE
    ORDER BY COALESCE(rs."reviewedDate", rs."createdAt") DESC NULLS LAST, rs.id DESC
    LIMIT 1
  ) AS final_review ON TRUE
  LEFT JOIN LATERAL (
    SELECT rs."aggregateScore" AS provisional_score
    FROM reviews."reviewSummation" AS rs
    WHERE rs."submissionId" = s.id
      AND rs."isProvisional" IS TRUE
    ORDER BY COALESCE(rs."reviewedDate", rs."createdAt") DESC NULLS LAST, rs.id DESC
    LIMIT 1
  ) AS provisional_review ON TRUE
  LEFT JOIN members."member" AS mem
    ON mem."userId" = s."memberId"::bigint
  LEFT JOIN identity."user" AS u
    ON s."memberId" ~ '^[0-9]+$'
   AND u.user_id = s."memberId"::numeric
  LEFT JOIN LATERAL (
    SELECT MAX(r."memberHandle") AS member_handle
    FROM resources."Resource" AS r
    WHERE r."challengeId" = cc.challenge_id
      AND r."memberId" = s."memberId"
  ) AS fallback ON TRUE
  WHERE COALESCE(final_review."aggregateScore", s."finalScore"::double precision, s."initialScore"::double precision) IS NOT NULL
),
unique_member_submissions AS (
  SELECT DISTINCT ON (challenge_id, user_id)
    sm.*
  FROM submission_metrics AS sm
  ORDER BY
    sm.challenge_id,
    sm.user_id,
    sm.submitted_date DESC NULLS LAST,
    sm.submission_id DESC
),
ranked_submissions AS (
  SELECT
    ums.challenge_id,
    ums.user_id AS "userId",
    ums.submission_id AS "submissionId",
    ums.handle AS handle,
    ROW_NUMBER() OVER (
      PARTITION BY ums.challenge_id
      ORDER BY ums.final_score_raw DESC NULLS LAST, ums.submitted_date ASC NULLS LAST, ums.user_id ASC
    ) AS placement,
    ums.provisional_score AS "provisionalScore",
    ums.final_score_raw AS "finalScore",
    ums.standard_score AS score
  FROM unique_member_submissions AS ums
)
SELECT
  cc.challenge_id AS "challengeId",
  cc.challenge_name AS "challengeName",
  rs."userId",
  rs."submissionId",
  rs.handle,
  rs.placement,
  rs."provisionalScore",
  rs."finalScore",
  rs.score
FROM ranked_submissions AS rs
JOIN challenge_context AS cc
  ON cc.challenge_id = rs.challenge_id
ORDER BY rs.challenge_id, rs.placement;
