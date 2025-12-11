WITH provided_dates AS (
  SELECT
    NULLIF($1, '')::timestamptz AS start_date,
    NULLIF($2, '')::timestamptz AS end_date
),
params AS (
  SELECT
    COALESCE(
      pd.start_date,
      CASE
        WHEN pd.end_date IS NOT NULL THEN pd.end_date - INTERVAL '3 months'
        ELSE CURRENT_DATE - INTERVAL '3 months'
      END
    ) AS start_date,
    COALESCE(pd.end_date, CURRENT_DATE) AS end_date
  FROM provided_dates pd
),
latest_payment AS (
  SELECT
    p.winnings_id,
    MAX(p.version) AS max_version
  FROM finance.payment p
  GROUP BY p.winnings_id
),
recent_payments AS (
  SELECT
    w.winning_id,
    w.winner_id,
    w.type,
    w.description,
    w.category,
    w.external_id AS challenge_id,
    w.created_at AS winning_created_at,
    p.payment_id,
    p.payment_status,
    p.payment_method_id,
    p.installment_number,
    p.billing_account,
    p.total_amount,
    p.gross_amount,
    p.challenge_fee,
    p.challenge_markup,
    p.date_paid,
    p.created_at AS payment_created_at
  FROM finance.winnings w
  JOIN finance.payment p
    ON p.winnings_id = w.winning_id
  JOIN latest_payment lp
    ON lp.winnings_id = p.winnings_id
   AND lp.max_version = p.version
  JOIN params pr ON TRUE
  WHERE w.type = 'PAYMENT'
    AND p.created_at >= pr.start_date
    AND p.created_at <= pr.end_date
)
SELECT
  rp.payment_created_at AS payment_created_at,
  rp.payment_id,
  rp.description AS payment_description,
  rp.challenge_id,
  rp.payment_status,
  rp.type AS payment_type,
  mem.handle AS payee_handle,
  pm.name AS payment_method,
  ba."name" AS billing_account_name,
  cl."name" AS customer_name,
  ba."subcontractingEndCustomer" AS reporting_account_name,
  rp.winner_id AS member_id,
  to_char(c."createdAt", 'YYYY-MM-DD') AS challenge_created_date,
  rp.gross_amount AS user_payment_gross_amount
FROM recent_payments rp
LEFT JOIN challenges."Challenge" c
  ON c."id" = rp.challenge_id
LEFT JOIN challenges."ChallengeBilling" cb
  ON cb."challengeId" = c."id"
LEFT JOIN "billing-accounts"."BillingAccount" ba
  ON ba."id" = COALESCE(
    NULLIF(rp.billing_account, '')::int,
    NULLIF(cb."billingAccountId", '')::int
  )
LEFT JOIN "billing-accounts"."Client" cl
  ON cl."id" = ba."clientId"
LEFT JOIN finance.payment_method pm
  ON pm.payment_method_id = rp.payment_method_id
LEFT JOIN members.member mem
  ON mem."userId"::text = rp.winner_id
ORDER BY payment_created_at DESC;
