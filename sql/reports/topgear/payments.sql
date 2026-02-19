SELECT
  p.payment_id,
  w.external_id as challenge_id,
  p.gross_amount,
  p.net_amount,
  p.total_amount,
  p.payment_status,
  p.billing_account,
  p.created_at,
  w.winner_id as user_id
FROM finance.payment p
INNER JOIN finance.winnings w on p.winnings_id = w.winning_id
WHERE p.created_at >= $1::timestamptz
  AND p.created_at <= $2::timestamptz
  AND p.billing_account = '80000062'
  AND w.type = 'PAYMENT'
ORDER BY p.created_at DESC;
