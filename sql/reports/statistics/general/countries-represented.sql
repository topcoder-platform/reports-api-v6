WITH member_country AS (
  SELECT
    COALESCE(NULLIF(TRIM(m."homeCountryCode"), ''), NULLIF(TRIM(m."competitionCountryCode"), '')) AS country_code
  FROM members.member m
)
SELECT
  country_code,
  members_count AS "user.count",
  DENSE_RANK() OVER (ORDER BY members_count DESC, country_code ASC)::int AS rank
FROM (
  SELECT
    country_code,
    COUNT(*)::bigint AS members_count
  FROM member_country
  WHERE country_code IS NOT NULL
  GROUP BY country_code
) aggregated
ORDER BY "user.count" DESC, country_code ASC;
