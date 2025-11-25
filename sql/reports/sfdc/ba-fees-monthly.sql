WITH filtered_payments AS (
  SELECT
    p.id,
    p.billing_account,
    p.challenge_fee,
    p.total_amount,
    p.created_at,
    CASE p.payment_status
      WHEN 'PROCESSING' THEN 'Entered into payment system'
      WHEN 'ON_HOLD' THEN 'On hold'
      WHEN 'ON_HOLD_ADMIN' THEN 'On hold - admin'
      WHEN 'OWED' THEN 'Owed'
      WHEN 'PAID' THEN 'Paid'
      WHEN 'CANCELLED' THEN 'Cancelled'
      WHEN 'FAILED' THEN 'Failed'
      WHEN 'RETURNED' THEN 'Returned'
      ELSE p.payment_status::text
    END AS payment_status_desc
  FROM finance.payment p
  LEFT JOIN finance.winnings w
    ON w.winning_id = p.winnings_id
  WHERE
    ($1::timestamptz IS NULL OR p.created_at >= $1::timestamptz)
    AND ($2::timestamptz IS NULL OR p.created_at <= $2::timestamptz)
    AND ($3::bigint[] IS NULL OR p.billing_account = ANY($3::bigint[]))
    AND ($4::bigint[] IS NULL OR p.billing_account != ALL($4::bigint[]))
),
latest_status AS (
  SELECT DISTINCT ON (billing_account)
    billing_account,
    payment_status_desc
  FROM filtered_payments
  ORDER BY billing_account, created_at DESC
)
SELECT
  fp.billing_account AS "billingAccountId",
  TO_CHAR(DATE_TRUNC('month', fp.created_at), 'YYYY-MM') AS "month",
  COALESCE(SUM(fp.challenge_fee), 0) AS "totalFees",
  COALESCE(SUM(fp.total_amount), 0) AS "totalMemberPayments",
  COUNT(fp.id) AS "paymentCount",
  MIN(fp.created_at)::date AS "earliestPaymentDate",
  MAX(fp.created_at)::date AS "latestPaymentDate",
  ls.payment_status_desc AS "currentPaymentStatus"
FROM filtered_payments fp
LEFT JOIN latest_status ls ON ls.billing_account = fp.billing_account
GROUP BY
  fp.billing_account,
  DATE_TRUNC('month', fp.created_at),
  ls.payment_status_desc
ORDER BY fp.billing_account, "month" DESC;
