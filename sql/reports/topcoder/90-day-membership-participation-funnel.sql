WITH date_bounds AS (
  SELECT
    DATE_TRUNC('day', CURRENT_TIMESTAMP) - INTERVAL '89 days' AS start_date,
    DATE_TRUNC('day', CURRENT_TIMESTAMP) + INTERVAL '1 day' AS end_date
),
new_members AS (
  SELECT
    u.user_id,
    DATE_TRUNC('day', u.create_date)::date AS member_since_date
  FROM identity."user" u
  CROSS JOIN date_bounds db
  WHERE u.status ILIKE 'A'
    AND u.create_date IS NOT NULL
    AND u.create_date >= db.start_date
    AND u.create_date < db.end_date
),
member_activity AS (
  SELECT
    nm.user_id,
    nm.member_since_date,
    EXISTS (
      SELECT 1
      FROM resources."Resource" r
      JOIN resources."ResourceRole" rr
        ON rr.id = r."roleId"
      JOIN challenges."Challenge" c
        ON c.id = r."challengeId"
      JOIN challenges."ChallengeTrack" ct
        ON ct.id = c."trackId"
      WHERE rr.name = 'Submitter'
        AND ct.track = 'DESIGN'
        AND r."memberId" = nm.user_id::text
        AND r."createdAt" >= nm.member_since_date
        AND r."createdAt" < nm.member_since_date + INTERVAL '90 days'
    ) AS design_participant,
    EXISTS (
      SELECT 1
      FROM reviews.submission s
      JOIN challenges."Challenge" c
        ON c.id = s."challengeId"
      JOIN challenges."ChallengeTrack" ct
        ON ct.id = c."trackId"
      WHERE s.status <> 'DELETED'
        AND ct.track = 'DESIGN'
        AND s."memberId" = nm.user_id::text
        AND COALESCE(s."submittedDate", s."createdAt") >= nm.member_since_date
        AND COALESCE(s."submittedDate", s."createdAt") < nm.member_since_date + INTERVAL '90 days'
    ) AS design_submitter,
    EXISTS (
      SELECT 1
      FROM resources."Resource" r
      JOIN resources."ResourceRole" rr
        ON rr.id = r."roleId"
      JOIN challenges."Challenge" c
        ON c.id = r."challengeId"
      JOIN challenges."ChallengeTrack" ct
        ON ct.id = c."trackId"
      WHERE rr.name = 'Submitter'
        AND ct.track IN ('DEVELOPMENT', 'DATA_SCIENCE')
        AND r."memberId" = nm.user_id::text
        AND r."createdAt" >= nm.member_since_date
        AND r."createdAt" < nm.member_since_date + INTERVAL '90 days'
    ) AS dev_participant,
    EXISTS (
      SELECT 1
      FROM reviews.submission s
      JOIN challenges."Challenge" c
        ON c.id = s."challengeId"
      JOIN challenges."ChallengeTrack" ct
        ON ct.id = c."trackId"
      WHERE s.status <> 'DELETED'
        AND ct.track IN ('DEVELOPMENT', 'DATA_SCIENCE')
        AND s."memberId" = nm.user_id::text
        AND COALESCE(s."submittedDate", s."createdAt") >= nm.member_since_date
        AND COALESCE(s."submittedDate", s."createdAt") < nm.member_since_date + INTERVAL '90 days'
    ) AS dev_submitter
  FROM new_members nm
)
SELECT
  COALESCE(
    MAX(EXTRACT(YEAR FROM ma.member_since_date))::integer,
    EXTRACT(YEAR FROM CURRENT_DATE)::integer
  ) AS "participant_funnel_monthly.member_since_date_year",
  COUNT(*) AS "participant_funnel_monthly.new_signups",
  COUNT(*) FILTER (WHERE ma.design_participant) AS "participant_funnel_monthly.new_design_participants",
  COUNT(*) FILTER (WHERE ma.design_submitter) AS "participant_funnel_monthly.new_design_submitters",
  COUNT(*) FILTER (WHERE ma.dev_participant) AS "participant_funnel_monthly.new_dev_participants",
  COUNT(*) FILTER (WHERE ma.dev_submitter) AS "participant_funnel_monthly.new_dev_submitters"
FROM member_activity ma;
