SELECT
  p.payment_id,
  p.gross_amount,
  p.net_amount,
  p.total_amount,
  p.payment_status,
  p.billing_account,
  p.created_at
FROM finance.payment p
WHERE p.created_at >= $1::timestamptz
  AND p.created_at <= $2::timestamptz
ORDER BY p.created_at DESC;