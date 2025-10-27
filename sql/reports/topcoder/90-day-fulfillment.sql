WITH last_phase AS (
  SELECT
    ph."challengeId" AS challenge_id,
    MAX(COALESCE(ph."actualEndDate", ph."scheduledEndDate")) AS last_phase_end_dt
  FROM challenges."ChallengePhase" ph
  GROUP BY ph."challengeId"
),
filtered_challenges AS (
  SELECT
    c.id AS challenge_id,
    c.status,
    COALESCE(lp.last_phase_end_dt, c."updatedAt", c."endDate", c."createdAt") AS activity_dt
  FROM challenges."Challenge" c
  LEFT JOIN last_phase lp
    ON lp.challenge_id = c.id
  LEFT JOIN projects.projects proj
    ON proj.id = c."projectId"::bigint
  WHERE c.status IN (
      'COMPLETED',
      'CANCELLED',
      'CANCELLED_FAILED_REVIEW',
      'CANCELLED_FAILED_SCREENING',
      'CANCELLED_ZERO_SUBMISSIONS',
      'CANCELLED_WINNER_UNRESPONSIVE',
      'CANCELLED_CLIENT_REQUEST',
      'CANCELLED_REQUIREMENTS_INFEASIBLE',
      'CANCELLED_ZERO_REGISTRATIONS',
      'CANCELLED_PAYMENT_FAILED'
    )
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
    AND COALESCE(lp.last_phase_end_dt, c."updatedAt", c."endDate", c."createdAt") >= (DATE_TRUNC('day', CURRENT_TIMESTAMP) - INTERVAL '89 days')
    AND COALESCE(lp.last_phase_end_dt, c."updatedAt", c."endDate", c."createdAt") < (DATE_TRUNC('day', CURRENT_TIMESTAMP) + INTERVAL '1 day')
)
SELECT
  CASE
    WHEN (counts.completed_challenges + counts.cancelled_challenges) = 0 THEN 0::numeric
    ELSE ROUND(
      counts.completed_challenges::numeric
      / (counts.completed_challenges + counts.cancelled_challenges),
      4
    )
  END AS "challenge.fulfillment"
FROM (
  SELECT
    COUNT(*) FILTER (WHERE status = 'COMPLETED') AS completed_challenges,
    COUNT(*) FILTER (
      WHERE status IN (
        'CANCELLED',
        'CANCELLED_FAILED_REVIEW',
        'CANCELLED_FAILED_SCREENING',
        'CANCELLED_ZERO_SUBMISSIONS',
        'CANCELLED_WINNER_UNRESPONSIVE',
        'CANCELLED_CLIENT_REQUEST',
        'CANCELLED_REQUIREMENTS_INFEASIBLE',
        'CANCELLED_ZERO_REGISTRATIONS',
        'CANCELLED_PAYMENT_FAILED'
      )
    ) AS cancelled_challenges
  FROM filtered_challenges
) AS counts;
