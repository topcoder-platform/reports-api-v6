SELECT
    COALESCE(SUM(p.gross_amount), 0)::numeric(12,2) AS "user_payment.gross_amount"
FROM finance.payment AS p
LEFT JOIN finance.winnings AS w
  ON w.winning_id = p.winnings_id
LEFT JOIN challenges."Challenge" AS c
  ON c.id = w.external_id
WHERE (p.payment_status IS NULL OR p.payment_status != 'CANCELLED')
  AND p.created_at >= (CURRENT_DATE - INTERVAL '89 days')
  AND p.created_at < (CURRENT_DATE + INTERVAL '1 day')
  AND NOT EXISTS (
    SELECT 1
    FROM unnest(COALESCE(c.groups, ARRAY[]::text[])) AS group_ref(group_id)
    JOIN groups."Group" g ON g.id = group_ref.group_id
    WHERE g.name ILIKE 'Wipro%'
  )
LIMIT 500;
