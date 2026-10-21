-- $1/$2 inclusive/exclusive UTC bounds. Markup is stored as a fraction.
-- Average each latest payment's markup equally, including every status/category.
-- Unknown markup stays unknown; it is never silently treated as zero.
WITH latest AS (
  SELECT winnings_id, MAX(version) AS version FROM finance.payment GROUP BY winnings_id
)
SELECT TO_CHAR(DATE_TRUNC('month', p.created_at), 'YYYY-MM-01') AS month,
       AVG(p.challenge_markup) * 100 AS markup,
       COUNT(*) FILTER (WHERE p.challenge_markup IS NULL) AS missing
FROM finance.payment p
JOIN latest l ON l.winnings_id = p.winnings_id AND l.version = p.version
JOIN finance.winnings w ON w.winning_id = p.winnings_id
WHERE w.type = 'PAYMENT'
  AND p.created_at >= ($1::timestamptz AT TIME ZONE 'UTC')
  AND p.created_at < ($2::timestamptz AT TIME ZONE 'UTC')
GROUP BY DATE_TRUNC('month', p.created_at)
ORDER BY month;
