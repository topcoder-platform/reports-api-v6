SELECT 
  p.billing_account as billing_account_id,
  COALESCE(SUM(p.challenge_fee), 0) AS total_fees,
  COALESCE(SUM(p.total_amount), 0) AS total_member_payments
FROM finance.payment p
LEFT JOIN finance.winnings w 
  ON w.winning_id = p.winnings_id
WHERE 
  p.created_at >= $1::timestamptz
  AND ($2::timestamptz IS NULL OR p.created_at <= $2::timestamptz)
GROUP BY p.billing_account
ORDER BY p.billing_account;
