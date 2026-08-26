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
member_wins AS (
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
  LEFT JOIN challenges."ChallengeType" ct
    ON ct.id::text = stats."typeId"
  WHERE stats."isPrivate" = false
    AND (
      UPPER(COALESCE(track.name, stats."trackId")) LIKE '%DEVELOP%'
      OR UPPER(COALESCE(track.name, stats."trackId")) LIKE '%DESIGN%'
      OR UPPER(COALESCE(track.name, stats."trackId")) LIKE '%DATA%SCIENCE%'
      OR UPPER(COALESCE(track.name, stats."trackId")) = 'QA'
      OR UPPER(COALESCE(track.name, stats."trackId")) LIKE '%QUALITY%ASSURANCE%'
      OR UPPER(COALESCE(track.name, stats."trackId")) LIKE '%COPILOT%'
    )
    AND (ct.name IS NULL OR NOT ct.name = ANY($1))
  GROUP BY stats."userId"
),
winners_country AS (
  SELECT
    COALESCE(
      NULLIF(TRIM(m."homeCountryCode"), ''),
      NULLIF(TRIM(m."competitionCountryCode"), '')
    ) AS country_code,
    w.wins
  FROM member_wins w
  JOIN members.member m ON m."userId" = w."userId"
  WHERE w.wins > 0
)
SELECT
  country_code,
  first_place_count AS "challenge_stats.count",
  DENSE_RANK() OVER (ORDER BY first_place_count DESC, country_code ASC)::int AS rank
FROM (
  SELECT
    country_code,
    SUM(wins)::bigint AS first_place_count
  FROM winners_country
  WHERE country_code IS NOT NULL
  GROUP BY country_code
) aggregated
ORDER BY "challenge_stats.count" DESC, country_code ASC;
