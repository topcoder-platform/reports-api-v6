-- Monthly member-payment values split by the selected range's top five customers.
--
-- Parameters:
--   $1 timestamptz - inclusive reporting range start
--   $2 timestamptz - exclusive reporting range end
--
-- The same ranked customer series is used for every month. The latest
-- non-cancelled payment record is counted in its creation month so projected
-- payments remain visible. Payments for unranked or unnamed customers are
-- grouped under Other Customers.
-- Customer labels use the billing account's subcontractingEndCustomer, except
-- TaaS payments for Wipro Limited (NA subcontracting) use TaaS and non-TaaS
-- payments for Topcoder use Topcoder. Each client/label pair is a distinct series.
-- Billing-account ids are normalized and compared as text so the historical
-- zero sentinel falls back to challenge billing without unsafe integer casts.
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
    p.created_at AS activity_at,
    COALESCE(p.gross_amount, p.total_amount, 0) AS amount,
    NULLIF(TRIM(cl.id), '') AS customer_id,
    NULLIF(TRIM(CASE
      WHEN w.category::text = 'TAAS_PAYMENT'
        AND TRIM(cl.name) = 'Wipro Limited (NA subcontracting)' THEN 'TaaS'
      WHEN w.category::text IS DISTINCT FROM 'TAAS_PAYMENT'
        AND TRIM(cl.name) = 'Topcoder' THEN 'Topcoder'
      WHEN payment_ba.id IS NOT NULL THEN payment_ba."subcontractingEndCustomer"
      ELSE challenge_ba."subcontractingEndCustomer"
    END), '') AS customer_label
  FROM finance.payment p
  JOIN latest_payment_versions lpv
    ON lpv.winnings_id = p.winnings_id
   AND lpv.max_version = p.version
  JOIN finance.winnings w
    ON w.winning_id = p.winnings_id
  LEFT JOIN challenges."Challenge" c
    ON c.id = w.external_id
  LEFT JOIN challenges."ChallengeBilling" cb
    ON cb."challengeId" = c.id
  LEFT JOIN "billing-accounts"."BillingAccount" payment_ba
    ON payment_ba.id::text = NULLIF(
      TRIM(LEADING '0' FROM TRIM(p.billing_account)),
      ''
    )
  LEFT JOIN "billing-accounts"."BillingAccount" challenge_ba
    ON challenge_ba.id::text = NULLIF(
      TRIM(LEADING '0' FROM TRIM(cb."billingAccountId")),
      ''
    )
  LEFT JOIN "billing-accounts"."Client" cl
    ON cl.id = COALESCE(payment_ba."clientId", challenge_ba."clientId")
  WHERE p.payment_status IS DISTINCT FROM 'CANCELLED'
    AND w.type = 'PAYMENT'
    AND p.created_at IS NOT NULL
    AND NULLIF(TRIM(w.winner_id), '') IS NOT NULL
    AND w.category::text IS DISTINCT FROM 'TOPGEAR_PAYMENT'
),
selected_events AS (
  SELECT pe.*
  FROM payment_events pe
  CROSS JOIN bounds b
  WHERE pe.activity_at >= b.start_at
    AND pe.activity_at < b.end_at
),
customer_totals AS (
  SELECT
    se.customer_id,
    se.customer_label,
    SUM(se.amount) AS total_amount
  FROM selected_events se
  WHERE se.customer_id IS NOT NULL
    AND se.customer_label IS NOT NULL
  GROUP BY se.customer_id, se.customer_label
),
ranked_customers AS (
  SELECT
    ct.customer_id,
    ct.customer_label,
    ROW_NUMBER() OVER (
      ORDER BY
        ct.total_amount DESC,
        LOWER(ct.customer_label),
        ct.customer_label,
        ct.customer_id
    ) AS series_order
  FROM customer_totals ct
),
top_customers AS (
  SELECT
    'customer-' || rc.customer_id || '-' || MD5(rc.customer_label) AS series_key,
    rc.customer_id,
    rc.customer_label,
    rc.series_order
  FROM ranked_customers rc
  WHERE rc.series_order <= 5
),
series AS (
  SELECT
    tc.series_key,
    tc.customer_id,
    tc.customer_label,
    tc.series_order
  FROM top_customers tc

  UNION ALL

  SELECT
    'other-customers' AS series_key,
    NULL::text AS customer_id,
    'Other Customers' AS customer_label,
    6 AS series_order
),
monthly_amounts AS (
  SELECT
    DATE_TRUNC('month', se.activity_at) AS month_start,
    COALESCE(
      tc.series_key,
      'other-customers'
    ) AS series_key,
    SUM(se.amount) AS amount
  FROM selected_events se
  LEFT JOIN top_customers tc
    ON tc.customer_id = se.customer_id
   AND tc.customer_label = se.customer_label
  GROUP BY
    DATE_TRUNC('month', se.activity_at),
    COALESCE(tc.series_key, 'other-customers')
)
SELECT
  TO_CHAR(m.month_start, 'YYYY-MM-01') AS month,
  s.series_key,
  s.customer_id,
  s.customer_label,
  s.series_order,
  COALESCE(ma.amount, 0) AS amount
FROM months m
CROSS JOIN series s
LEFT JOIN monthly_amounts ma
  ON ma.month_start = m.month_start
 AND ma.series_key = s.series_key
ORDER BY m.month_start, s.series_order;
