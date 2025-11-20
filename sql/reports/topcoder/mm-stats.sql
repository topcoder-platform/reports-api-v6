WITH member_base AS (
  SELECT
    mem."userId",
    mem.handle,
    mem."firstName",
    mem."lastName",
    COALESCE(
      comp_code.name,
      comp_id.name,
      NULLIF(TRIM(mem."competitionCountryCode"), '')
    ) AS competition_country,
    usr.create_date AS member_since
  FROM members."member" AS mem
  LEFT JOIN identity."user" AS usr
    ON usr.user_id::bigint = mem."userId"
  LEFT JOIN lookups."Country" AS comp_code
    ON UPPER(comp_code."countryCode") = UPPER(mem."competitionCountryCode")
  LEFT JOIN lookups."Country" AS comp_id
    ON UPPER(comp_id.id) = UPPER(mem."competitionCountryCode")
  WHERE mem."handleLower" = LOWER($1)
)
SELECT
  mb.handle,
  mb."firstName" AS first_name,
  mb."lastName" AS last_name,
  mb.competition_country,
  mb.member_since,
  marathon_stats.rating AS marathon_match_rating,
  marathon_stats.rank AS marathon_match_rank,
  max_rating.max_rating AS highest_track_rating,
  marathon_stats.challenges AS marathon_matches_registered,
  marathon_stats.wins AS marathon_match_wins,
  marathon_stats."topFiveFinishes" AS marathon_match_top_five_finishes,
  marathon_stats."avgRank" AS average_marathon_match_placement,
  CASE
    WHEN marathon_stats.challenges IS NULL
      OR marathon_stats.challenges = 0 THEN NULL
    ELSE marathon_stats.competitions::double precision
         / marathon_stats.challenges::double precision
  END AS marathon_submission_rate
FROM member_base AS mb
LEFT JOIN LATERAL (
  SELECT MAX(mmr.rating) AS max_rating
  FROM members."memberMaxRating" AS mmr
  WHERE mmr."userId" = mb."userId"
) AS max_rating ON TRUE
LEFT JOIN LATERAL (
  SELECT mmar.*
  FROM members."memberStats" AS ms
  JOIN members."memberDataScienceStats" AS mds
    ON mds."memberStatsId" = ms.id
  JOIN members."memberMarathonStats" AS mmar
    ON mmar."dataScienceStatsId" = mds.id
  WHERE ms."userId" = mb."userId"
  ORDER BY
    CASE WHEN ms."isPrivate" THEN 1 ELSE 0 END,
    ms."updatedAt" DESC NULLS LAST,
    ms.id DESC
  LIMIT 1
) AS marathon_stats ON TRUE;
