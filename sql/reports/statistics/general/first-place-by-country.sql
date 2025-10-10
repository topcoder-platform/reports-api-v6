WITH winners AS (
  SELECT s."memberId"::text AS member_id
  FROM reviews.submission s
  WHERE s.placement = 1
),
winners_country AS (
  SELECT
    COALESCE(
      NULLIF(TRIM(m."homeCountryCode"), ''),
      NULLIF(TRIM(m."competitionCountryCode"), '')
    ) AS country_code
  FROM winners w
  JOIN members.member m ON m."userId"::text = w.member_id
)
SELECT
  country_code,
  first_place_count AS "challenge_stats.count",
  DENSE_RANK() OVER (ORDER BY first_place_count DESC, country_code ASC)::int AS rank
FROM (
  SELECT
    country_code,
    COUNT(*)::bigint AS first_place_count
  FROM winners_country
  WHERE country_code IS NOT NULL
  GROUP BY country_code
) aggregated
ORDER BY "challenge_stats.count" DESC, country_code ASC;
