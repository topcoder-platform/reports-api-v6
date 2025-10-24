WITH f2f_wins AS (
  SELECT
    s."memberId"::bigint AS user_id,
    COALESCE(NULLIF(TRIM(m.handle), ''), m.handle) AS handle,
    COUNT(DISTINCT s."challengeId")::int AS wins_count
  FROM reviews.submission s
  JOIN challenges."Challenge" c
    ON c.id = s."challengeId"
  JOIN challenges."ChallengeType" ct
    ON ct.id = c."typeId"
  JOIN challenges."ChallengeTrack" tr
    ON tr.id = c."trackId"
  LEFT JOIN members.member m
    ON m."userId"::text = s."memberId"::text
  WHERE s.placement = 1
    AND tr.abbreviation = 'DS'
    AND ct.abbreviation = 'F2F'
    AND COALESCE(NULLIF(TRIM(m.handle), ''), m.handle) IS NOT NULL
  GROUP BY s."memberId", m.handle
)
SELECT
  fw.handle AS "challenge_stats.winner_handle",
  mmr.rating AS "member_profile_advanced.max_rating",
  fw.wins_count AS "challenge_stats.count",
  DENSE_RANK() OVER (ORDER BY fw.wins_count DESC, fw.handle ASC)::int AS rank
FROM f2f_wins fw
LEFT JOIN members."memberMaxRating" mmr
  ON mmr."userId" = fw.user_id
ORDER BY "challenge_stats.count" DESC, "challenge_stats.winner_handle" ASC;
