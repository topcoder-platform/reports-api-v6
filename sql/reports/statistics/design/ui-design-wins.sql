SELECT
  m."userId"             AS member_id,
  m.handle               AS handle,
  COUNT(DISTINCT s."challengeId")::int AS wins_count
FROM reviews.submission s
JOIN challenges."Challenge" c
  ON c.id = s."challengeId"
JOIN challenges."ChallengeType" ct
  ON ct.id = c."typeId"
JOIN challenges."ChallengeTrack" tr
  ON tr.id = c."trackId"
JOIN members.member m
  ON m."userId"::text = s."memberId"::text
WHERE s.placement = 1
  AND tr.abbreviation = 'DESIGN'
  AND ct.abbreviation = 'CH'
GROUP BY m."userId", m.handle
ORDER BY wins_count DESC, handle ASC;

