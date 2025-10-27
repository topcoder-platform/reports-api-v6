WITH challenge_window AS (
  SELECT
    c.id,
    c."projectId" AS project_id,
    COALESCE(
      c."registrationStartDate",
      c."startDate",
      c."createdAt"
    ) AS posting_dt
  FROM challenges."Challenge" c
  WHERE COALESCE(
      c."registrationStartDate",
      c."startDate",
      c."createdAt"
    ) >= (DATE_TRUNC('day', CURRENT_TIMESTAMP) - INTERVAL '89 days')
    AND COALESCE(
      c."registrationStartDate",
      c."startDate",
      c."createdAt"
    ) < (DATE_TRUNC('day', CURRENT_TIMESTAMP) + INTERVAL '1 day')
    AND (
      c.status IS NULL
      OR c.status NOT IN ('DELETED', 'DRAFT', 'NEW')
    )
    AND NOT EXISTS (
      SELECT 1
      FROM unnest(COALESCE(c.groups, ARRAY[]::text[])) AS group_ref(group_id)
      JOIN groups."Group" g
        ON g.id = group_ref.group_id
      WHERE g.name ILIKE 'Wipro%'
    )
)
SELECT
  COUNT(DISTINCT r."memberId")::bigint AS "copilot.count"
FROM challenge_window cw
JOIN resources."Resource" r
  ON r."challengeId" = cw.id
JOIN resources."ResourceRole" rr
  ON rr.id = r."roleId"
LEFT JOIN members.member m
  ON m."userId"::text = r."memberId"
LEFT JOIN projects.projects proj
  ON proj.id = cw.project_id::bigint
WHERE COALESCE(rr."nameLower", LOWER(rr.name)) = 'copilot'
  AND (
    proj.name IS NULL
    OR (
      proj.name NOT ILIKE 'Fun & Learning Challenges (Jaipur)'
      AND proj.name NOT ILIKE 'Fun & Learning - 2016 (Jaipur)'
      AND proj.name NOT ILIKE 'TopGear Trial'
    )
  )
  AND (
    m.email IS NULL
    OR (
      m.email NOT ILIKE '%@topcoder.com'
      AND m.email NOT ILIKE '%@wipro.com'
    )
  )
  AND COALESCE(
    NULLIF(TRIM(m.handle), ''),
    NULLIF(TRIM(r."memberHandle"), '')
  ) IS NOT NULL;
