-- $1/$2 inclusive/exclusive UTC bounds. Executed on ENGAGEMENTS_DB_URL.
-- $3 allowed customer project IDs from the reporting DB; null keeps Reports unscoped.
-- An empty array deliberately counts no assignments; filtering precedes all distinct counts.
-- acceptedAt records actual assignment; startDate is the legacy fallback.
-- Completion/termination writes endDate in the engagement service. updatedAt is not an event date.
-- Ongoing means still assigned at the month-end snapshot (now for the current month).
WITH bounds AS (
  SELECT $1::timestamptz AT TIME ZONE 'UTC' AS start_at,
         $2::timestamptz AT TIME ZONE 'UTC' AS end_at
), months AS (
  SELECT GENERATE_SERIES(DATE_TRUNC('month', start_at),
    DATE_TRUNC('month', end_at - INTERVAL '1 microsecond'), INTERVAL '1 month') AS month_start
  FROM bounds
), assignments AS (
  SELECT BTRIM(a."memberId") AS member_id, a.status::text AS status,
         COALESCE((TO_JSONB(a)->>'acceptedAt')::timestamp, a."startDate") AS assigned_at,
         a."endDate" AS ended_at
  FROM engagements."EngagementAssignment" a
  WHERE a.status::text IN ('ASSIGNED', 'COMPLETED', 'TERMINATED')
    AND NULLIF(BTRIM(a."memberId"), '') IS NOT NULL
    AND ($3::text[] IS NULL OR EXISTS (
      SELECT 1 FROM engagements."Engagement" e
      WHERE e.id = a."engagementId"
        AND BTRIM(e."projectId") = ANY($3::text[])
    ))
)
SELECT TO_CHAR(m.month_start, 'YYYY-MM-01') AS month,
       COUNT(DISTINCT a.member_id) FILTER (
         WHERE a.assigned_at >= GREATEST(m.month_start, b.start_at)
           AND a.assigned_at < LEAST(m.month_start + INTERVAL '1 month', b.end_at)
       ) AS newly_assigned,
       COUNT(DISTINCT a.member_id) FILTER (
         WHERE a.status = 'COMPLETED'
           AND a.ended_at >= GREATEST(m.month_start, b.start_at)
           AND a.ended_at < LEAST(m.month_start + INTERVAL '1 month', b.end_at)
       ) AS completed,
       COUNT(DISTINCT a.member_id) FILTER (
         WHERE a.assigned_at < LEAST(m.month_start + INTERVAL '1 month', b.end_at, NOW() AT TIME ZONE 'UTC')
           AND (a.ended_at IS NULL OR a.ended_at >= LEAST(m.month_start + INTERVAL '1 month', b.end_at, NOW() AT TIME ZONE 'UTC'))
           AND (a.status = 'ASSIGNED' OR a.ended_at IS NOT NULL)
           AND m.month_start <= NOW() AT TIME ZONE 'UTC'
       ) AS ongoing
FROM months m CROSS JOIN bounds b
LEFT JOIN assignments a ON a.assigned_at < LEAST(m.month_start + INTERVAL '1 month', b.end_at)
  OR (a.status = 'COMPLETED' AND a.ended_at >= m.month_start AND a.ended_at < m.month_start + INTERVAL '1 month')
GROUP BY m.month_start
ORDER BY m.month_start;
