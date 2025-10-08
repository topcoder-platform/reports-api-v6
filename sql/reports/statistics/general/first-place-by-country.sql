WITH winners AS (
  SELECT s."memberId"::text AS member_id
  FROM reviews.submission s
  WHERE s.placement = 1
)
SELECT
  COALESCE(NULLIF(TRIM(m."homeCountryCode"), ''), NULLIF(TRIM(m."competitionCountryCode"), '')) AS country_code,
  COUNT(*)::bigint AS first_place_count
FROM winners w
JOIN members.member m ON m."userId"::text = w.member_id
GROUP BY country_code
HAVING country_code IS NOT NULL
ORDER BY first_place_count DESC, country_code ASC;

