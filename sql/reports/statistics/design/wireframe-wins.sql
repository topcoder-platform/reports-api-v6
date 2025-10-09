SELECT
  m."userId" AS member_id,
  m.handle AS handle,
  COUNT(DISTINCT s."challengeId")::int AS wins_count,
  COUNT(DISTINCT s."challengeId")::int AS count
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
GROUP BY m."userId", m.handle
ORDER BY wins_count DESC, handle ASC;
