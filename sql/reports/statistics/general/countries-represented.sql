WITH member_country AS (
  SELECT
    COALESCE(NULLIF(TRIM(m."homeCountryCode"), ''), NULLIF(TRIM(m."competitionCountryCode"), '')) AS country_code
  FROM members.member m
)
SELECT
  country_code,
  COUNT(*)::bigint AS members_count
FROM member_country
WHERE country_code IS NOT NULL
GROUP BY country_code
ORDER BY members_count DESC, country_code ASC;

