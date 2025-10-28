WITH last_phase AS (
  SELECT
    ph."challengeId" AS challenge_id,
    MAX(COALESCE(ph."actualEndDate", ph."scheduledEndDate")) AS last_phase_end_dt
  FROM challenges."ChallengePhase" ph
  GROUP BY ph."challengeId"
),
completed_challenges AS (
  SELECT
    c.id AS challenge_id,
    COALESCE(c."startDate", c."registrationStartDate", c."createdAt") AS start_dt,
    COALESCE(
      lp.last_phase_end_dt,
      c."updatedAt",
      c."endDate",
      c."createdAt"
    ) AS completion_dt,
    proj.name AS project_name,
    c.groups
  FROM challenges."Challenge" c
  LEFT JOIN last_phase lp
    ON lp.challenge_id = c.id
  LEFT JOIN projects.projects proj
    ON proj.id = c."projectId"::bigint
  WHERE c.status = 'COMPLETED'
    AND COALESCE(c."taskIsTask", false) = false
    AND (
      proj.name IS NULL
      OR (
        proj.name NOT ILIKE 'Fun & Learning Challenges (Jaipur)'
        AND proj.name NOT ILIKE 'Fun & Learning - 2016 (Jaipur)'
        AND proj.name NOT ILIKE 'TopGear Trial'
      )
    )
    AND NOT EXISTS (
      SELECT 1
      FROM unnest(COALESCE(c.groups, ARRAY[]::text[])) AS group_ref(group_id)
      JOIN groups."Group" g ON g.id = group_ref.group_id
      WHERE g.name ILIKE 'Wipro%'
    )
    AND COALESCE(
      lp.last_phase_end_dt,
      c."updatedAt",
      c."endDate",
      c."createdAt"
    ) >= (DATE_TRUNC('day', CURRENT_TIMESTAMP) - INTERVAL '89 days')
    AND COALESCE(
      lp.last_phase_end_dt,
      c."updatedAt",
      c."endDate",
      c."createdAt"
    ) < (DATE_TRUNC('day', CURRENT_TIMESTAMP) + INTERVAL '1 day')
),
durations AS (
  SELECT
    cc.challenge_id,
    GREATEST(
      EXTRACT(EPOCH FROM (cc.completion_dt - cc.start_dt)) / 3600.0,
      0
    ) AS duration_hours
  FROM completed_challenges cc
)
SELECT
  COALESCE(SUM(durations.duration_hours), 0)::numeric(18, 2) AS "challenge.duration",
  COUNT(*)::bigint AS "challenge.count"
FROM durations;
