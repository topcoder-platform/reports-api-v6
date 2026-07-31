-- Monthly challenge registration/submission activity and all-time summary.
--
-- Parameters:
--   $1 timestamptz - inclusive reporting range start
--   $2 timestamptz - exclusive reporting range end
--
-- The month is the challenge cohort's latest actual phase completion month,
-- matching the Challenge Registrants report. This avoids treating legacy
-- resource import timestamps as registration dates. A member is counted once
-- in each category per month, regardless of challenge count.
WITH bounds AS (
  SELECT
    $1::timestamptz AT TIME ZONE 'UTC' AS start_at,
    $2::timestamptz AT TIME ZONE 'UTC' AS end_at
),
months AS (
  SELECT GENERATE_SERIES(
    DATE_TRUNC('month', b.start_at),
    DATE_TRUNC('month', b.end_at - INTERVAL '1 microsecond'),
    INTERVAL '1 month'
  ) AS month_start
  FROM bounds b
),
eligible_challenges AS MATERIALIZED (
  SELECT
    c.id AS challenge_id,
    lp."actualEndDate" AS activity_at
  FROM challenges."Challenge" c
  JOIN challenges."ChallengeType" ct
    ON ct.id = c."typeId"
  JOIN LATERAL (
    SELECT cp."actualEndDate"
    FROM challenges."ChallengePhase" cp
    WHERE cp."challengeId" = c.id
    ORDER BY cp."scheduledEndDate" DESC
    LIMIT 1
  ) lp
    ON lp."actualEndDate" IS NOT NULL
  WHERE ct.name IN ('Challenge', 'Marathon Match', 'First2Finish')
),
registration_events AS MATERIALIZED (
  SELECT DISTINCT
    ec.challenge_id,
    NULLIF(TRIM(r."memberId"), '') AS member_id,
    ec.activity_at
  FROM eligible_challenges ec
  JOIN resources."Resource" r
    ON r."challengeId" = ec.challenge_id
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId"
  WHERE COALESCE(NULLIF(TRIM(rr."nameLower"), ''), LOWER(rr.name)) = 'submitter'
    AND NULLIF(TRIM(r."memberId"), '') IS NOT NULL
),
submission_events AS MATERIALIZED (
  SELECT
    re.member_id,
    re.activity_at
  FROM registration_events re
  WHERE EXISTS (
    SELECT 1
    FROM reviews.submission s
    WHERE s."challengeId" = re.challenge_id
      AND s."memberId" = re.member_id
      AND s.status <> 'DELETED'
  )
),
selected_registrations AS (
  SELECT
    DATE_TRUNC('month', re.activity_at) AS month_start,
    COUNT(DISTINCT re.member_id) AS registrants
  FROM registration_events re
  CROSS JOIN bounds b
  WHERE re.activity_at >= b.start_at
    AND re.activity_at < b.end_at
  GROUP BY DATE_TRUNC('month', re.activity_at)
),
selected_submissions AS (
  SELECT
    DATE_TRUNC('month', se.activity_at) AS month_start,
    COUNT(DISTINCT se.member_id) AS submitters
  FROM submission_events se
  CROSS JOIN bounds b
  WHERE se.activity_at >= b.start_at
    AND se.activity_at < b.end_at
  GROUP BY DATE_TRUNC('month', se.activity_at)
),
all_time_registration_months AS (
  SELECT
    DATE_TRUNC('month', re.activity_at) AS month_start,
    COUNT(DISTINCT re.member_id) AS registrants
  FROM registration_events re
  GROUP BY DATE_TRUNC('month', re.activity_at)
),
peak_month AS (
  SELECT
    atrm.month_start,
    atrm.registrants
  FROM all_time_registration_months atrm
  ORDER BY atrm.registrants DESC, atrm.month_start DESC
  LIMIT 1
),
all_time_summary AS (
  SELECT
    (SELECT COUNT(DISTINCT re.member_id) FROM registration_events re)
      AS total_unique_registrants,
    (SELECT COUNT(DISTINCT se.member_id) FROM submission_events se)
      AS total_unique_submitters
)
SELECT
  TO_CHAR(m.month_start, 'YYYY-MM-01') AS month,
  COALESCE(sr.registrants, 0) AS registrants,
  COALESCE(ss.submitters, 0) AS submitters,
  ats.total_unique_registrants,
  ats.total_unique_submitters,
  COALESCE(
    ROUND(
      LEAST(
        100,
        ats.total_unique_submitters * 100.0
          / NULLIF(ats.total_unique_registrants, 0)
      ),
      1
    ),
    0
  ) AS submission_rate,
  TO_CHAR(pm.month_start, 'YYYY-MM-01') AS peak_month,
  COALESCE(pm.registrants, 0) AS peak_month_registrants
FROM months m
LEFT JOIN selected_registrations sr
  ON sr.month_start = m.month_start
LEFT JOIN selected_submissions ss
  ON ss.month_start = m.month_start
CROSS JOIN all_time_summary ats
LEFT JOIN peak_month pm
  ON TRUE
ORDER BY m.month_start;
