WITH params AS (
  SELECT COALESCE(NULLIF($1, '')::timestamptz, TIMESTAMPTZ '2024-01-01') AS start_date
),
registrants AS (
  SELECT DISTINCT r."memberId" AS member_id
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId"
  JOIN params p
    ON r."createdAt" >= p.start_date
  WHERE rr."nameLower" IN ('submitter', 'registrant')
),
latest_payment AS (
  SELECT
    p.winnings_id,
    MAX(p.version) AS max_version
  FROM finance.payment p
  GROUP BY p.winnings_id
),
paid_members AS (
  SELECT DISTINCT w.winner_id AS member_id
  FROM finance.payment p
  JOIN latest_payment lp
    ON lp.winnings_id = p.winnings_id
   AND lp.max_version = p.version
  JOIN finance.winnings w
    ON w.winning_id = p.winnings_id
  JOIN params pr
    ON COALESCE(p.date_paid, p.created_at) >= pr.start_date
  WHERE p.payment_status = 'PAID'
    AND w.type = 'PAYMENT'
),
eligible_members AS (
  SELECT DISTINCT r.member_id
  FROM registrants r
  JOIN paid_members p
    ON p.member_id = r.member_id
),
role_counts AS (
  SELECT
    s."memberId" AS member_id,
    c."trackId" AS track_id,
    COUNT(DISTINCT s."challengeId") AS submission_count
  FROM reviews.submission s
  JOIN challenges."Challenge" c
    ON c.id = s."challengeId"
  JOIN eligible_members em
    ON em.member_id = s."memberId"
  GROUP BY s."memberId", c."trackId"
),
ranked_roles AS (
  SELECT
    rc.*,
    ROW_NUMBER() OVER (
      PARTITION BY rc.member_id
      ORDER BY rc.submission_count DESC
    ) AS rn
  FROM role_counts rc
),
member_roles AS (
  SELECT
    rr.member_id,
    CASE ct.track
      WHEN 'DESIGN' THEN 'Design'
      WHEN 'DEVELOPMENT' THEN 'Development'
      WHEN 'QUALITY_ASSURANCE' THEN 'QA'
      WHEN 'DATA_SCIENCE' THEN 'Data Science'
      ELSE ct.name
    END AS role
  FROM ranked_roles rr
  JOIN challenges."ChallengeTrack" ct
    ON ct.id = rr.track_id
  WHERE rr.rn = 1
),
skills_agg AS (
  SELECT
    skill_rows.user_id,
    jsonb_agg(
      jsonb_build_object(
        'name', skill_rows.skill_name,
        'status', skill_rows.status
      )
      ORDER BY skill_rows.skill_name
    ) AS skills
  FROM (
    SELECT
      us.user_id::bigint AS user_id,
      sk.name AS skill_name,
      CASE
        WHEN lower(usl.name) = 'verified' THEN 'verified'
        ELSE 'self-assigned'
      END AS status,
      ROW_NUMBER() OVER (
        PARTITION BY us.user_id, sk.name
        ORDER BY CASE
          WHEN lower(usl.name) = 'verified' THEN 0
          ELSE 1
        END
      ) AS rn
    FROM skills.user_skill us
    JOIN eligible_members em
      ON em.member_id = us.user_id::text
    JOIN skills.skill sk
      ON sk.id = us.skill_id
     AND sk.deleted_at IS NULL
    JOIN skills.user_skill_level usl
      ON usl.id = us.user_skill_level_id
  ) skill_rows
  WHERE skill_rows.rn = 1
  GROUP BY skill_rows.user_id
),
work_history AS (
  SELECT
    mt."userId" AS user_id,
    jsonb_agg(
      jsonb_build_object(
        'industry', mw.industry,
        'companyName', mw."companyName",
        'position', mw."position",
        'startDate', mw."startDate",
        'endDate', mw."endDate",
        'working', mw.working
      )
      ORDER BY mw."startDate" DESC NULLS LAST
    ) AS work_history
  FROM members."memberTraits" mt
  JOIN members."memberTraitWork" mw
    ON mw."memberTraitId" = mt.id
  GROUP BY mt."userId"
),
education_history AS (
  SELECT
    mt."userId" AS user_id,
    jsonb_agg(
      jsonb_build_object(
        'collegeName', me."collegeName",
        'degree', me.degree,
        'endYear', me."endYear"
      )
      ORDER BY me."endYear" DESC NULLS LAST
    ) AS education
  FROM members."memberTraits" mt
  JOIN members."memberTraitEducation" me
    ON me."memberTraitId" = mt.id
  GROUP BY mt."userId"
),
trolley_verified AS (
  SELECT DISTINCT uiva.user_id AS member_id, true AS verified
  FROM finance.user_identity_verification_associations uiva
),
challenge_wins AS (
  SELECT
    cw."userId"::text AS member_id,
    COUNT(DISTINCT cw."challengeId") AS challenge_wins
  FROM challenges."ChallengeWinner" cw
  JOIN challenges."Challenge" c
    ON c.id = cw."challengeId"
  JOIN challenges."ChallengeType" ct
    ON ct.id = c."typeId"
  JOIN eligible_members em
    ON em.member_id = cw."userId"::text
  WHERE cw.placement = 1
    AND COALESCE(ct."isTask", false) = false
  GROUP BY cw."userId"
),
task_wins AS (
  SELECT
    cw."userId"::text AS member_id,
    COUNT(DISTINCT cw."challengeId") AS task_wins
  FROM challenges."ChallengeWinner" cw
  JOIN challenges."Challenge" c
    ON c.id = cw."challengeId"
  JOIN challenges."ChallengeType" ct
    ON ct.id = c."typeId"
  JOIN eligible_members em
    ON em.member_id = cw."userId"::text
  WHERE cw.placement = 1
    AND COALESCE(ct."isTask", false) = true
  GROUP BY cw."userId"
),
registration_counts AS (
  SELECT
    r."memberId" AS member_id,
    COUNT(DISTINCT r."challengeId") AS registration_count
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId"
  JOIN eligible_members em
    ON em.member_id = r."memberId"
  WHERE rr."nameLower" IN ('submitter', 'registrant')
  GROUP BY r."memberId"
),
submissions_over_75 AS (
  SELECT
    s."memberId" AS member_id,
    COUNT(DISTINCT s.id) AS submissions_over_75
  FROM reviews.submission s
  LEFT JOIN reviews.review r
    ON r."submissionId" = s.id
  JOIN eligible_members em
    ON em.member_id = s."memberId"
  WHERE s."memberId" IS NOT NULL
    AND (s."finalScore" > 75 OR r."finalScore" > 75)
  GROUP BY s."memberId"
),
max_rating AS (
  SELECT DISTINCT ON ("userId")
    "userId",
    rating,
    track,
    "subTrack",
    "ratingColor",
    id
  FROM members."memberMaxRating"
  ORDER BY "userId", rating DESC
)
SELECT
  m.handle,
  m.email,
  COALESCE(
    NULLIF(m."homeCountryCode", ''),
    NULLIF(m."competitionCountryCode", '')
  ) AS country_code,
  mr.role,
  COALESCE(sk.skills, '[]'::jsonb) AS skills,
  CASE
    WHEN mmr.id IS NULL THEN NULL
    ELSE jsonb_build_object(
      'rating', mmr.rating,
      'track', mmr.track,
      'subTrack', mmr."subTrack",
      'ratingColor', mmr."ratingColor"
    )
  END AS ratings,
  u.create_date AS member_since,
  m."availableForGigs" AS open_to_work,
  COALESCE(wh.work_history, '[]'::jsonb) AS work_history,
  COALESCE(eh.education, '[]'::jsonb) AS education,
  COALESCE(tv.verified, false) AS trolley_id_verified,
  COALESCE(cw.challenge_wins, 0) AS challenge_wins,
  COALESCE(rc.registration_count, 0) AS registration_count,
  COALESCE(so.submissions_over_75, 0) AS submissions_over_75,
  COALESCE(tw.task_wins, 0) AS task_wins
FROM eligible_members em
JOIN members.member m
  ON m."userId"::text = em.member_id
LEFT JOIN identity."user" u
  ON u.user_id::text = em.member_id
LEFT JOIN member_roles mr
  ON mr.member_id = em.member_id
LEFT JOIN skills_agg sk
  ON sk.user_id = m."userId"
LEFT JOIN max_rating mmr
  ON mmr."userId" = m."userId"
LEFT JOIN work_history wh
  ON wh.user_id = m."userId"
LEFT JOIN education_history eh
  ON eh.user_id = m."userId"
LEFT JOIN trolley_verified tv
  ON tv.member_id = em.member_id
LEFT JOIN challenge_wins cw
  ON cw.member_id = em.member_id
LEFT JOIN task_wins tw
  ON tw.member_id = em.member_id
LEFT JOIN registration_counts rc
  ON rc.member_id = em.member_id
LEFT JOIN submissions_over_75 so
  ON so.member_id = em.member_id
ORDER BY m.handle;
