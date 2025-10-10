WITH raw_winners AS (
  SELECT
    m."userId"::bigint AS user_id,
    NULLIF(TRIM(m.handle), '') AS handle,
    s."challengeId" AS challenge_id
  FROM reviews.submission s
  JOIN challenges."Challenge" c
    ON c.id = s."challengeId"
  JOIN challenges."ChallengeTrack" tr
    ON tr.id = c."trackId"
  JOIN members.member m
    ON m."userId"::text = s."memberId"::text
  WHERE s.placement = 1
    AND tr.abbreviation = 'DS'
    AND EXISTS (
      SELECT 1
      FROM UNNEST(c.tags) AS tag
      WHERE LOWER(tag) = 'wireframe'
    )
),
placements AS (
  SELECT
    user_id,
    handle,
    COUNT(DISTINCT challenge_id)::int AS wins_count
  FROM raw_winners
  WHERE handle IS NOT NULL
  GROUP BY user_id, handle
)
SELECT
  p.handle AS "challenge_stats.winner_handle",
  p.handle AS handle,
  p.wins_count AS "challenge_stats.count",
  p.wins_count AS count,
  mmr.rating AS "member_profile_advanced.max_rating",
  DENSE_RANK() OVER (ORDER BY p.wins_count DESC, p.handle ASC)::int AS rank
FROM placements p
LEFT JOIN members."memberMaxRating" mmr
  ON mmr."userId" = p.user_id
ORDER BY "challenge_stats.count" DESC, "challenge_stats.winner_handle" ASC;
