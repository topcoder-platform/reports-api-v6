WITH raw_winners AS (
  SELECT
    cw."userId"::bigint AS user_id,
    COALESCE(NULLIF(TRIM(cw.handle), ''), m.handle) AS handle
  FROM challenges."ChallengeWinner" cw
  JOIN challenges."Challenge" c
    ON c.id = cw."challengeId"
  JOIN challenges."ChallengeTrack" tr
    ON tr.id = c."trackId"
  LEFT JOIN members.member m
    ON m."userId" = cw."userId"::bigint
  WHERE tr.abbreviation = 'DS'
    AND c.status = 'COMPLETED'
    AND cw.placement IS NOT NULL
    AND cw.placement > 0
    AND (
      c.name ILIKE 'LUX%'
      OR c.name ILIKE 'TCO LUX%'
    )
),
placements AS (
  SELECT
    user_id,
    handle,
    COUNT(*)::int AS placements_count
  FROM raw_winners
  WHERE handle IS NOT NULL
  GROUP BY user_id, handle
)
SELECT
  p.handle,
  p.placements_count AS wins_count,
  p.placements_count AS count,
  mmr.rating AS max_rating,
  DENSE_RANK() OVER (ORDER BY p.placements_count DESC, p.handle ASC)::int AS rank
FROM placements p
LEFT JOIN members."memberMaxRating" mmr
  ON mmr."userId" = p.user_id
ORDER BY wins_count DESC, handle ASC;
