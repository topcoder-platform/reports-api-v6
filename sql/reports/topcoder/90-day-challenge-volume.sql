WITH launch_dates AS (
  SELECT
    c.id AS challenge_id,
    COALESCE(c."startDate", c."registrationStartDate", c."createdAt") AS launch_date,
    proj.name AS project_name,
    c.groups
  FROM challenges."Challenge" c
  LEFT JOIN projects.projects proj
    ON proj.id = c."projectId"::bigint
  WHERE COALESCE(c."taskIsTask", false) = false
    AND c.status NOT IN ('DRAFT', 'DELETED')
    AND c.status::text NOT ILIKE 'CANCELLED%'
)
SELECT
  COUNT(DISTINCT ld.challenge_id)::bigint AS "challenge.count"
FROM launch_dates ld
WHERE ld.launch_date >= (DATE_TRUNC('day', CURRENT_TIMESTAMP) - INTERVAL '89 days')
  AND ld.launch_date < (DATE_TRUNC('day', CURRENT_TIMESTAMP) + INTERVAL '1 day')
  AND (
    ld.project_name IS NULL
    OR (
      ld.project_name NOT ILIKE 'Fun & Learning Challenges (Jaipur)'
      AND ld.project_name NOT ILIKE 'Fun & Learning - 2016 (Jaipur)'
      AND ld.project_name NOT ILIKE 'TopGear Trial'
    )
  )
  AND NOT EXISTS (
    SELECT 1
    FROM unnest(COALESCE(ld.groups, ARRAY[]::text[])) AS group_ref(group_id)
    JOIN groups."Group" g ON g.id = group_ref.group_id
    WHERE g.name ILIKE 'Wipro%'
  );
