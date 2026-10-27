-- $1/$2 inclusive/exclusive UTC bounds; $3 restricts to customer work for Sales.
-- $4 selects TaaS only; false selects non-TaaS Topcoder payments.
-- Exclude TaaS, internal Topcoder and unlinked payments BEFORE any sums or rankings.
-- Uses the established dashboard payment version, category and customer-label rules.
WITH bounds AS (
  SELECT
    $1::timestamptz AT TIME ZONE 'UTC' AS start_at,
    $2::timestamptz AT TIME ZONE 'UTC' AS end_at
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
    BTRIM(w.winner_id) AS member_id,
    CASE
      WHEN w.category::text = 'TAAS_PAYMENT' THEN 'taas'
      WHEN w.category::text = 'ENGAGEMENT_PAYMENT' THEN 'engagement'
      WHEN w.category::text IN ('TASK_PAYMENT', 'TASK_REVIEW_PAYMENT', 'TASK_COPILOT_PAYMENT',
        'DEPLOYMENT_TASK_PAYMENT', 'PROJECT_DEPLOYMENT_TASK_PAYMENT') THEN 'task'
      ELSE 'challenge'
    END AS payment_type,
    NULLIF(BTRIM(cl.name), '') AS client_name,
    COALESCE(p.gross_amount, p.total_amount, 0) AS amount,
    NULLIF(TRIM(cl.id), '') AS customer_id,
    NULLIF(TRIM(CASE
      WHEN w.category::text = 'TAAS_PAYMENT'
        AND TRIM(cl.name) = 'Wipro Limited (NA subcontracting)' THEN 'TaaS'
      WHEN w.category::text IS DISTINCT FROM 'TAAS_PAYMENT'
        AND TRIM(cl.name) = 'Topcoder' THEN 'Topcoder'
      WHEN payment_ba.id IS NOT NULL THEN COALESCE(
        NULLIF(BTRIM(payment_ba."subcontractingEndCustomer"), ''), NULLIF(BTRIM(cl.name), '')
      )
      ELSE COALESCE(NULLIF(BTRIM(challenge_ba."subcontractingEndCustomer"), ''), NULLIF(BTRIM(cl.name), ''))
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
    AND (pe.payment_type = 'taas') = $4::boolean
    AND (NOT $3::boolean OR (
      pe.payment_type <> 'taas'
      AND pe.customer_id IS NOT NULL
      AND pe.client_name IS NOT NULL
      AND LOWER(pe.client_name) <> 'topcoder'
      AND LOWER(COALESCE(pe.customer_label, '')) NOT IN ('topcoder', 'taas')
    ))
)
SELECT TO_CHAR(DATE_TRUNC('month', activity_at), 'YYYY-MM-01') AS month,
       CASE WHEN GROUPING(payment_type) = 0 THEN 'type' ELSE 'customer' END AS kind,
       payment_type, customer_id, customer_label,
       SUM(amount) AS amount, COUNT(DISTINCT member_id) AS members
FROM selected_events
GROUP BY GROUPING SETS (
  (DATE_TRUNC('month', activity_at), payment_type),
  (DATE_TRUNC('month', activity_at), customer_id, customer_label)
)
ORDER BY month, kind, payment_type, customer_id, customer_label;
