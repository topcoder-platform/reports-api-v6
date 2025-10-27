WITH last_phase AS (
  SELECT
    ph."challengeId" AS challenge_id,
    MAX(COALESCE(ph."actualEndDate", ph."scheduledEndDate")) AS last_phase_end_dt
  FROM challenges."ChallengePhase" ph
  GROUP BY ph."challengeId"
),
eligible_challenges AS (
  SELECT
    c.id AS challenge_id,
    COALESCE(lp.last_phase_end_dt, c."updatedAt", c."endDate", c."createdAt") AS completion_dt
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
    AND COALESCE(lp.last_phase_end_dt, c."updatedAt", c."endDate", c."createdAt") >= (DATE_TRUNC('day', CURRENT_TIMESTAMP) - INTERVAL '89 days')
    AND COALESCE(lp.last_phase_end_dt, c."updatedAt", c."endDate", c."createdAt") < (DATE_TRUNC('day', CURRENT_TIMESTAMP) + INTERVAL '1 day')
),
challenge_payments AS (
  SELECT DISTINCT
    p.payment_id,
    w.external_id AS challenge_id,
    p.gross_amount
  FROM finance.payment p
  JOIN finance.winnings w
    ON w.winning_id = p.winnings_id
  JOIN eligible_challenges ec
    ON ec.challenge_id = w.external_id
  WHERE (p.payment_status IS NULL OR p.payment_status != 'CANCELLED')
    AND p.gross_amount IS NOT NULL
),
aggregated AS (
  SELECT
    COALESCE(SUM(cp.gross_amount), 0)::numeric(18, 2) AS total_member_payments,
    COUNT(cp.payment_id) AS payment_count,
    COUNT(DISTINCT cp.challenge_id) AS challenge_count
  FROM challenge_payments cp
)
SELECT
  (
    CASE
      WHEN aggregated.payment_count = 0 THEN 0::numeric
      ELSE ROUND(aggregated.total_member_payments / aggregated.payment_count::numeric, 2)
    END
  )::numeric(18, 2) AS "cost_transaction.average_member_payments",
  COALESCE(aggregated.total_member_payments, 0)::numeric(18, 2) AS "cost_transaction.member_payments",
  COALESCE(aggregated.challenge_count, 0)::bigint AS "cost_transaction.count_challenges"
FROM aggregated;
