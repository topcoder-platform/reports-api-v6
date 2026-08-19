WITH winners AS (
  SELECT DISTINCT
    s."memberId"::text AS member_id,
    s."challengeId" AS challenge_id
  FROM reviews.submission s
  JOIN challenges."Challenge" c
    ON c.id = s."challengeId"
  LEFT JOIN challenges."ChallengeType" ct
    ON ct.id = c."typeId"
  WHERE s.placement = 1
    AND (ct.name IS NULL OR NOT ct.name = ANY($1))
),
member_wins AS (
  SELECT
    member_id,
    COUNT(*)::bigint AS wins
  FROM winners
  GROUP BY member_id
),
winner_profiles AS (
  SELECT
    COALESCE(
      NULLIF(TRIM(m."homeCountryCode"), ''),
      NULLIF(TRIM(m."competitionCountryCode"), '')
    ) AS country_code,
    m."userId" AS user_id,
    m.handle,
    m."photoURL" AS photo_url,
    mmr.rating AS max_rating,
    w.wins
  FROM member_wins w
  JOIN members.member m
    ON m."userId"::text = w.member_id
  LEFT JOIN members."memberMaxRating" mmr
    ON mmr."userId" = m."userId"
  WHERE COALESCE(
    NULLIF(TRIM(m."homeCountryCode"), ''),
    NULLIF(TRIM(m."competitionCountryCode"), '')
  ) IS NOT NULL
    AND w.wins > 0
),
country_totals AS (
  SELECT
    country_code,
    SUM(wins)::bigint AS first_place_count
  FROM winner_profiles
  GROUP BY country_code
),
ranked_winners AS (
  SELECT
    winner_profiles.*,
    ROW_NUMBER() OVER (
      PARTITION BY country_code
      ORDER BY wins DESC, handle ASC, user_id ASC
    ) AS winner_rank
  FROM winner_profiles
  WHERE NULLIF(TRIM(handle), '') IS NOT NULL
),
country_winners AS (
  SELECT
    country_code,
    JSONB_AGG(
      JSONB_BUILD_OBJECT(
        'handle', handle,
        'wins', wins,
        'photoURL', photo_url,
        'maxRating', max_rating
      )
      ORDER BY winner_rank
    ) FILTER (WHERE winner_rank <= 3) AS top_winners
  FROM ranked_winners
  GROUP BY country_code
)
SELECT
  totals.country_code,
  totals.first_place_count AS "challenge_stats.count",
  DENSE_RANK() OVER (
    ORDER BY totals.first_place_count DESC, totals.country_code ASC
  )::int AS rank,
  COALESCE(winners.top_winners, '[]'::jsonb) AS top_winners
FROM country_totals totals
LEFT JOIN country_winners winners
  ON winners.country_code = totals.country_code
ORDER BY "challenge_stats.count" DESC, country_code ASC;
