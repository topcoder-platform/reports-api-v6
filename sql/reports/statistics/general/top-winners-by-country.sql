WITH history_wins AS (
  SELECT
    history."userId",
    history."trackId",
    history."typeId",
    COUNT(*)::bigint AS wins
  FROM members."memberStatsHistory" history
  WHERE history.placement = 1
  GROUP BY history."userId", history."trackId", history."typeId"
),
stats_wins AS (
  SELECT
    stats."userId",
    SUM(COALESCE(stats.wins, history.wins, 0))::bigint AS wins
  FROM members."memberStats" stats
  LEFT JOIN history_wins history
    ON history."userId" = stats."userId"
   AND history."trackId" = stats."trackId"
   AND history."typeId" = stats."typeId"
  LEFT JOIN challenges."ChallengeTrack" track
    ON track.id::text = stats."trackId"
  WHERE stats."isPrivate" = false
    AND (
      UPPER(COALESCE(track.name, stats."trackId")) LIKE '%DEVELOP%'
      OR UPPER(COALESCE(track.name, stats."trackId")) LIKE '%DESIGN%'
      OR UPPER(COALESCE(track.name, stats."trackId")) LIKE '%DATA%SCIENCE%'
      OR UPPER(COALESCE(track.name, stats."trackId")) = 'QA'
      OR UPPER(COALESCE(track.name, stats."trackId")) LIKE '%QUALITY%ASSURANCE%'
      OR UPPER(COALESCE(track.name, stats."trackId")) LIKE '%COPILOT%'
    )
  GROUP BY stats."userId"
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
    wins.wins
  FROM stats_wins wins
  JOIN members.member m
    ON m."userId" = wins."userId"
  LEFT JOIN members."memberMaxRating" mmr
    ON mmr."userId" = m."userId"
  WHERE COALESCE(
    NULLIF(TRIM(m."homeCountryCode"), ''),
    NULLIF(TRIM(m."competitionCountryCode"), '')
  ) IS NOT NULL
    AND wins.wins > 0
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
