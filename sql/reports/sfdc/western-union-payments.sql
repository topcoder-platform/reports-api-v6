WITH payment_data AS (
  SELECT
    p.payment_id,
    p.gross_amount,
    COALESCE(w.title, w.description) AS description,
    w.external_id AS reference_id,
    p.created_at,
    u.handle,
    pm.name AS payment_method_name,
    pm.payment_method_type,
    p.payment_status,
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
  LEFT JOIN finance.winnings w ON w.winning_id = p.winnings_id
  LEFT JOIN identity."user" u ON u.user_id::text = w.winner_id
  LEFT JOIN finance.payment_method pm ON pm.payment_method_id = p.payment_method_id
)
SELECT
  payment_id AS "paymentId",
  handle,
  gross_amount AS "grossAmount",
  reference_id AS "referenceId",
  description,
  payment_status_desc AS "paymentStatus",
  created_at AS "paymentDate"
FROM payment_data
WHERE
  ($1::text IS NULL OR payment_status_desc ILIKE $1 OR payment_status::text ILIKE $1)
  AND ($2::text IS NULL OR payment_method_name ILIKE $2 OR payment_method_type ILIKE $2)
  AND ($3::timestamp IS NULL OR created_at >= $3)
  AND ($4::timestamp IS NULL OR created_at <= $4)
  AND ($5::text[] IS NULL OR LOWER(handle) = ANY($5))
ORDER BY handle, created_at DESC
LIMIT 1000;
