WITH winners AS (
  SELECT s."memberId"::text AS member_id
  FROM reviews.submission s
  JOIN challenges."Challenge" c
    ON c.id = s."challengeId"
  JOIN challenges."ChallengeTrack" tr
    ON tr.id = c."trackId"
  WHERE s.placement = 1
    AND tr.abbreviation = 'DS'
),
winners_country AS (
  SELECT
    COALESCE(
      NULLIF(TRIM(m."homeCountryCode"), ''),
      NULLIF(TRIM(m."competitionCountryCode"), '')
    ) AS country_code
  FROM winners w
  JOIN members.member m
    ON m."userId"::text = w.member_id
)
SELECT
  country_code,
  COUNT(*)::bigint AS first_place_count
FROM winners_country
WHERE country_code IS NOT NULL
GROUP BY country_code
ORDER BY first_place_count DESC, country_code ASC;

