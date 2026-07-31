-- Monthly paid-member values split by canonical payment bucket.
--
-- Parameters:
--   $1 timestamptz - inclusive reporting range start
--   $2 timestamptz - exclusive reporting range end
--
-- Only the latest version of each payment is considered. Gross amount is the
-- preferred member-payment value, with total amount used as a fallback.
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
paid_events AS MATERIALIZED (
  SELECT
    COALESCE(p.date_paid, p.created_at) AS paid_at,
    COALESCE(p.gross_amount, p.total_amount, 0) AS amount,
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
  WHERE p.payment_status = 'PAID'
    AND w.type = 'PAYMENT'
    AND COALESCE(p.date_paid, p.created_at) IS NOT NULL
    AND NULLIF(TRIM(w.winner_id), '') IS NOT NULL
    AND w.category::text IS DISTINCT FROM 'TOPGEAR_PAYMENT'
),
selected_months AS (
  SELECT
    DATE_TRUNC('month', pe.paid_at) AS month_start,
    COALESCE(SUM(pe.amount) FILTER (
      WHERE pe.payment_type = 'taas'
    ), 0) AS taas,
    COALESCE(SUM(pe.amount) FILTER (
      WHERE pe.payment_type = 'task'
    ), 0) AS task,
    COALESCE(SUM(pe.amount) FILTER (
      WHERE pe.payment_type = 'challenge'
    ), 0) AS challenge,
    COALESCE(SUM(pe.amount) FILTER (
      WHERE pe.payment_type = 'engagement'
    ), 0) AS engagement
  FROM paid_events pe
  CROSS JOIN bounds b
  WHERE pe.paid_at >= b.start_at
    AND pe.paid_at < b.end_at
  GROUP BY DATE_TRUNC('month', pe.paid_at)
)
SELECT
  TO_CHAR(m.month_start, 'YYYY-MM-01') AS month,
  COALESCE(sm.taas, 0) AS taas,
  COALESCE(sm.task, 0) AS task,
  COALESCE(sm.challenge, 0) AS challenge,
  COALESCE(sm.engagement, 0) AS engagement
FROM months m
LEFT JOIN selected_months sm
  ON sm.month_start = m.month_start
ORDER BY m.month_start;
