SELECT
  p.payment_id,
  w.external_id as challenge_id,
  p.gross_amount,
  p.net_amount,
  p.total_amount,
  p.payment_status,
  p.billing_account,
  p.created_at,
  pr.user_id                        AS user_id
FROM finance.payment p
INNER JOIN finance.winnings w on p.winnings_id = w.winning_id
LEFT JOIN finance.payment_release_associations pra
        ON pra.payment_id = p.payment_id
LEFT JOIN finance.payment_releases pr
        ON pr.payment_release_id = pra.payment_release_id
WHERE p.created_at >= $1::timestamptz
  AND p.created_at <= $2::timestamptz
  AND p.billing_account = '80000062'
ORDER BY p.created_at DESC;