WITH rux_wins AS (
  SELECT
    s."memberId"::bigint AS user_id,
    COALESCE(NULLIF(TRIM(m.handle), ''), m.handle) AS handle,
    COUNT(DISTINCT s."challengeId")::int AS wins_count
  FROM reviews.submission s
  JOIN challenges."Challenge" c
    ON c.id = s."challengeId"
  JOIN challenges."ChallengeTrack" tr
    ON tr.id = c."trackId"
  LEFT JOIN members.member m
    ON m."userId"::text = s."memberId"::text
  WHERE s.placement = 1
    AND tr.abbreviation = 'DS'
    AND (
      c.name ILIKE 'RUX%'
      OR c.name ILIKE 'TCO RUX%'
    )
    AND COALESCE(NULLIF(TRIM(m.handle), ''), m.handle) IS NOT NULL
  GROUP BY s."memberId", m.handle
)
SELECT
  rw.handle AS "challenge_stats.winner_handle",
  rw.handle AS handle,
  rw.wins_count AS "challenge_stats.count",
  rw.wins_count AS count,
  mmr.rating AS "member_profile_advanced.max_rating",
  DENSE_RANK() OVER (ORDER BY rw.wins_count DESC, rw.handle ASC)::int AS rank
FROM rux_wins rw
LEFT JOIN members."memberMaxRating" mmr
  ON mmr."userId" = rw.user_id
ORDER BY "challenge_stats.count" DESC, "challenge_stats.winner_handle" ASC;
