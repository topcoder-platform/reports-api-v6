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
  WHERE tr.abbreviation = 'QA'
    AND c.status = 'COMPLETED'
    AND cw.placement = 1
),
placements AS (
  SELECT
    user_id,
    handle,
    COUNT(*)::int AS wins
  FROM raw_winners
  WHERE handle IS NOT NULL
  GROUP BY user_id, handle
)
SELECT
  p.handle AS "challenge_stats.registrant_handle",
  mmr.rating AS "member_profile_advanced.max_rating",
  p.wins AS first_place_winner_count,
  DENSE_RANK() OVER (ORDER BY p.wins DESC, p.handle ASC)::int AS rank
FROM placements p
LEFT JOIN members."memberMaxRating" mmr
  ON mmr."userId" = p.user_id
ORDER BY first_place_winner_count DESC, "challenge_stats.registrant_handle" ASC;
