WITH date_bounds AS (
  SELECT
    (DATE_TRUNC('week', CURRENT_TIMESTAMP + INTERVAL '1 day') - INTERVAL '1 day')::date AS current_week_start
),
last_phase AS (
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
    COALESCE(
      lp.last_phase_end_dt,
      c."updatedAt",
      c."endDate",
      c."createdAt"
    ) AS activity_dt
  FROM challenges."Challenge" c
  LEFT JOIN last_phase lp
    ON lp.challenge_id = c.id
  LEFT JOIN projects.projects proj
    ON proj.id = c."projectId"::bigint
  CROSS JOIN date_bounds db
  WHERE c.status IN (
      'COMPLETED',
      'CANCELLED',
      'CANCELLED_FAILED_REVIEW',
      'CANCELLED_FAILED_SCREENING',
      'CANCELLED_ZERO_SUBMISSIONS',
      'CANCELLED_WINNER_UNRESPONSIVE',
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
    AND COALESCE(
      lp.last_phase_end_dt,
      c."updatedAt",
      c."endDate",
      c."createdAt"
    ) >= (db.current_week_start - INTERVAL '4 weeks')
),
weekly AS (
  SELECT
    (
      DATE_TRUNC('week', fc.activity_dt + INTERVAL '1 day') - INTERVAL '1 day'
    )::date AS week_start,
    COUNT(DISTINCT fc.challenge_id) FILTER (WHERE fc.status = 'COMPLETED') AS completed_challenges,
    COUNT(DISTINCT fc.challenge_id) FILTER (
      WHERE fc.status IN (
        'CANCELLED',
        'CANCELLED_FAILED_REVIEW',
        'CANCELLED_FAILED_SCREENING',
        'CANCELLED_ZERO_SUBMISSIONS',
        'CANCELLED_WINNER_UNRESPONSIVE',
        'CANCELLED_REQUIREMENTS_INFEASIBLE',
        'CANCELLED_ZERO_REGISTRATIONS',
        'CANCELLED_PAYMENT_FAILED'
      )
    ) AS cancelled_challenges,
    COUNT(DISTINCT fc.challenge_id) AS challenge_count
  FROM filtered_challenges fc
  GROUP BY 1
)
SELECT
  TO_CHAR(w.week_start, 'YYYY-MM-DD') AS "challenge.complete_week",
  CASE
    WHEN (w.completed_challenges + w.cancelled_challenges) = 0 THEN 0::numeric
    ELSE ROUND(
      w.completed_challenges::numeric
      / (w.completed_challenges + w.cancelled_challenges),
      4
    )
  END AS "challenge.fulfillment",
  w.challenge_count AS "challenge.count"
FROM (
  SELECT *
  FROM weekly
  ORDER BY week_start DESC
  LIMIT 4
) AS w
ORDER BY w.week_start;
