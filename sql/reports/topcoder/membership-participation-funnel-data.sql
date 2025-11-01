WITH week_bounds AS (
  SELECT
    (DATE_TRUNC('week', CURRENT_DATE + INTERVAL '1 day') - INTERVAL '1 day')::date AS current_week_start
),
new_members AS (
  SELECT
    u.user_id,
    DATE(u.create_date) AS member_since_date
  FROM identity."user" u
  CROSS JOIN week_bounds wb
  WHERE u.create_date IS NOT NULL
    AND u.status ILIKE 'A'
    AND DATE(u.create_date) >= wb.current_week_start - INTERVAL '4 weeks'
    AND DATE(u.create_date) < wb.current_week_start
),
registrant_activity AS (
  SELECT DISTINCT
    r."memberId" AS member_id,
    ct.track
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId"
  JOIN challenges."Challenge" c
    ON c.id = r."challengeId"
  JOIN challenges."ChallengeTrack" ct
    ON ct.id = c."trackId"
  WHERE COALESCE(rr."nameLower", LOWER(rr.name)) = 'submitter'
),
submission_activity AS (
  SELECT DISTINCT
    s."memberId" AS member_id,
    ct.track
  FROM reviews.submission s
  JOIN challenges."Challenge" c
    ON c.id = s."challengeId"
  JOIN challenges."ChallengeTrack" ct
    ON ct.id = c."trackId"
  WHERE s.status <> 'DELETED'
),
member_funnel AS (
  SELECT
    nm.user_id,
    nm.member_since_date,
    EXISTS (
      SELECT 1
      FROM registrant_activity ra
      WHERE ra.member_id = nm.user_id::text
        AND ra.track = 'DESIGN'
    ) AS design_participant,
    EXISTS (
      SELECT 1
      FROM submission_activity sa
      WHERE sa.member_id = nm.user_id::text
        AND sa.track = 'DESIGN'
    ) AS design_submitter,
    EXISTS (
      SELECT 1
      FROM registrant_activity ra
      WHERE ra.member_id = nm.user_id::text
        AND ra.track IN ('DEVELOPMENT', 'DATA_SCIENCE', 'QUALITY_ASSURANCE')
    ) AS dev_participant,
    EXISTS (
      SELECT 1
      FROM submission_activity sa
      WHERE sa.member_id = nm.user_id::text
        AND sa.track IN ('DEVELOPMENT', 'DATA_SCIENCE', 'QUALITY_ASSURANCE')
    ) AS dev_submitter
  FROM new_members nm
)
SELECT
  TO_CHAR(
    DATE_TRUNC('week', mf.member_since_date + INTERVAL '1 day') - INTERVAL '1 day',
    'YYYY-MM-DD'
  ) AS "participant_funnel_monthly.member_since_date_week",
  COUNT(*) AS "participant_funnel_monthly.new_signups",
  COUNT(*) FILTER (WHERE mf.design_participant) AS "participant_funnel_monthly.new_design_participants",
  COUNT(*) FILTER (WHERE mf.design_submitter) AS "participant_funnel_monthly.new_design_submitters",
  COUNT(*) FILTER (WHERE mf.dev_participant) AS "participant_funnel_monthly.new_dev_participants",
  COUNT(*) FILTER (WHERE mf.dev_submitter) AS "participant_funnel_monthly.new_dev_submitters"
FROM member_funnel mf
GROUP BY 1
ORDER BY 1 DESC
LIMIT 500;
