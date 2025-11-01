SELECT
    COUNT(*) AS "user.count"
FROM identity."user" AS "user"
WHERE "user".status ILIKE 'A'
  AND "user".last_login IS NOT NULL
  AND "user".last_login >= (DATE_TRUNC('day', CURRENT_TIMESTAMP) - INTERVAL '89 days')
  AND "user".last_login < (DATE_TRUNC('day', CURRENT_TIMESTAMP) + INTERVAL '1 day');
