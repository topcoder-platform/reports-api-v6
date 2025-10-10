WITH development_submitters AS (
  SELECT DISTINCT
    s."memberId"::text AS member_id
  FROM reviews.submission s
  JOIN challenges."Challenge" c
    ON c.id = s."challengeId"
  JOIN challenges."ChallengeTrack" tr
    ON tr.id = c."trackId"
  WHERE tr.abbreviation = 'Dev'
),
member_country AS (
  SELECT
    ds.member_id,
    COALESCE(
      NULLIF(TRIM(m."homeCountryCode"), ''),
      NULLIF(TRIM(m."competitionCountryCode"), '')
    ) AS country_code
  FROM development_submitters ds
  JOIN members.member m
    ON m."userId"::text = ds.member_id
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
