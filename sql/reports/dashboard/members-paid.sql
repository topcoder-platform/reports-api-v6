-- Monthly unique paid members by canonical payment bucket and all-time summary.
--
-- Parameters:
--   $1 timestamptz - inclusive reporting range start
--   $2 timestamptz - exclusive reporting range end
--
-- The report is a financial projection, so the latest non-cancelled payment
-- record is counted in its creation month even when payout is still on hold or
-- owed. TOPGEAR_PAYMENT is intentionally excluded because it is a separate
-- canonical accrual bucket and is not one of the four dashboard categories.
WITH bounds AS (
  SELECT
    $1::timestamptz AT TIME ZONE 'UTC' AS start_at,
    $2::timestamptz AT TIME ZONE 'UTC' AS end_at
),
months AS (
  SELECT GENERATE_SERIES(
    DATE_TRUNC('month', b.start_at),
    DATE_TRUNC('month', b.end_at - INTERVAL '1 microsecond'),
    INTERVAL '1 month'
  ) AS month_start
  FROM bounds b
),
latest_payment_versions AS MATERIALIZED (
  SELECT
    p.winnings_id,
    MAX(p.version) AS max_version
  FROM finance.payment p
  GROUP BY p.winnings_id
),
payment_events AS MATERIALIZED (
  SELECT
    NULLIF(TRIM(w.winner_id), '') AS member_id,
    p.created_at AS activity_at,
    CASE
      WHEN w.category::text = 'TAAS_PAYMENT' THEN 'taas'
      WHEN w.category::text = 'ENGAGEMENT_PAYMENT' THEN 'engagement'
      WHEN w.category::text IN (
        'TASK_PAYMENT',
        'TASK_REVIEW_PAYMENT',
        'TASK_COPILOT_PAYMENT',
        'DEPLOYMENT_TASK_PAYMENT',
        'PROJECT_DEPLOYMENT_TASK_PAYMENT'
      ) THEN 'task'
      ELSE 'challenge'
    END AS payment_type
  FROM finance.payment p
  JOIN latest_payment_versions lpv
    ON lpv.winnings_id = p.winnings_id
   AND lpv.max_version = p.version
  JOIN finance.winnings w
    ON w.winning_id = p.winnings_id
  WHERE p.payment_status IS DISTINCT FROM 'CANCELLED'
    AND w.type = 'PAYMENT'
    AND p.created_at IS NOT NULL
    AND NULLIF(TRIM(w.winner_id), '') IS NOT NULL
    AND w.category::text IS DISTINCT FROM 'TOPGEAR_PAYMENT'
),
selected_months AS (
  SELECT
    DATE_TRUNC('month', pe.activity_at) AS month_start,
    COUNT(DISTINCT pe.member_id) FILTER (
      WHERE pe.payment_type = 'taas'
    ) AS taas,
    COUNT(DISTINCT pe.member_id) FILTER (
      WHERE pe.payment_type = 'task'
    ) AS task,
    COUNT(DISTINCT pe.member_id) FILTER (
      WHERE pe.payment_type = 'challenge'
    ) AS challenge,
    COUNT(DISTINCT pe.member_id) FILTER (
      WHERE pe.payment_type = 'engagement'
    ) AS engagement
  FROM payment_events pe
  CROSS JOIN bounds b
  WHERE pe.activity_at >= b.start_at
    AND pe.activity_at < b.end_at
  GROUP BY DATE_TRUNC('month', pe.activity_at)
),
all_time_months AS (
  SELECT
    DATE_TRUNC('month', pe.activity_at) AS month_start,
    COUNT(DISTINCT pe.member_id) AS unique_members
  FROM payment_events pe
  GROUP BY DATE_TRUNC('month', pe.activity_at)
),
peak_month AS (
  SELECT
    atm.month_start,
    atm.unique_members
  FROM all_time_months atm
  ORDER BY atm.unique_members DESC, atm.month_start DESC
  LIMIT 1
),
all_time_summary AS (
  SELECT
    COUNT(DISTINCT pe.member_id) AS total_unique_members,
    COUNT(DISTINCT pe.member_id) FILTER (
      WHERE pe.payment_type = 'taas'
    ) AS taas_unique_members,
    COUNT(DISTINCT pe.member_id) FILTER (
      WHERE pe.payment_type = 'task'
    ) AS task_unique_members,
    COUNT(DISTINCT pe.member_id) FILTER (
      WHERE pe.payment_type = 'challenge'
    ) AS challenge_unique_members,
    COUNT(DISTINCT pe.member_id) FILTER (
      WHERE pe.payment_type = 'engagement'
    ) AS engagement_unique_members
  FROM payment_events pe
)
SELECT
  TO_CHAR(m.month_start, 'YYYY-MM-01') AS month,
  COALESCE(sm.taas, 0) AS taas,
  COALESCE(sm.task, 0) AS task,
  COALESCE(sm.challenge, 0) AS challenge,
  COALESCE(sm.engagement, 0) AS engagement,
  ats.total_unique_members,
  ats.taas_unique_members,
  ats.task_unique_members,
  ats.challenge_unique_members,
  ats.engagement_unique_members,
  TO_CHAR(pm.month_start, 'YYYY-MM-01') AS peak_month,
  COALESCE(pm.unique_members, 0) AS peak_month_unique_members
FROM months m
LEFT JOIN selected_months sm
  ON sm.month_start = m.month_start
CROSS JOIN all_time_summary ats
LEFT JOIN peak_month pm
  ON TRUE
ORDER BY m.month_start;
