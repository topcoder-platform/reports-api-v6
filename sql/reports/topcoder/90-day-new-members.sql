SELECT
    COUNT(*) AS "user.count"
FROM identity."user" AS "user"
WHERE "user".status ILIKE 'A'
  AND "user".create_date >= (DATE_TRUNC('day', CURRENT_TIMESTAMP) - INTERVAL '89 days')
  AND "user".create_date < (DATE_TRUNC('day', CURRENT_TIMESTAMP) + INTERVAL '1 day')
LIMIT 500;
