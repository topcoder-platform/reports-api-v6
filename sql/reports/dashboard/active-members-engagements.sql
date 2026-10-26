-- Engagement events, executed against ENGAGEMENTS_DB_URL.
-- $1/$2: inclusive/exclusive timestamptz bounds; stored timestamps are UTC.
-- $3: text[] of project IDs (test projects) to omit; an empty array keeps all.
-- Applications qualify regardless of their subsequent status or visibility.
-- Acceptance uses its durable timestamp, including subsequently ended assignments.
-- JSON extraction supports rolling deployment before the acceptedAt migration;
-- legacy unknown dates are omitted rather than inferred from mutable updatedAt.
WITH bounds AS (
  SELECT $1::timestamptz AT TIME ZONE 'UTC' AS start_at,
         $2::timestamptz AT TIME ZONE 'UTC' AS end_at
), events AS (
  SELECT 'application:' || app.id AS id, BTRIM(app."userId") AS member_id,
         app.handle, 'engagement-application' AS activity,
         app."createdAt" AS activity_at, e.title AS description,
         e."projectId" AS project_id
  FROM engagements."EngagementApplication" app
  JOIN engagements."Engagement" e ON e.id = app."engagementId"
  UNION ALL
  SELECT 'acceptance:' || a.id, BTRIM(a."memberId"), a."memberHandle",
         'engagement-acceptance', (TO_JSONB(a)->>'acceptedAt')::timestamp, e.title,
         e."projectId"
  FROM engagements."EngagementAssignment" a
  JOIN engagements."Engagement" e ON e.id = a."engagementId"
)
SELECT e.id, e.member_id AS "memberId",
       COALESCE(NULLIF(e.handle, ''), e.member_id) AS handle,
       e.activity, TO_CHAR(e.activity_at, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"') AS date,
       e.description
FROM events e
CROSS JOIN bounds b
WHERE e.activity_at >= b.start_at AND e.activity_at < b.end_at
  AND NULLIF(e.member_id, '') IS NOT NULL
  AND (e.project_id IS NULL OR e.project_id <> ALL($3::text[]))
ORDER BY e.activity_at DESC, e.id;
