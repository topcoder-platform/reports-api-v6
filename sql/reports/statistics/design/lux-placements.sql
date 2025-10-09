WITH member_placements AS (
  SELECT
    m."userId" AS member_id,
    m.handle AS handle,
    COUNT(DISTINCT s."challengeId")::int AS placements_count
  FROM reviews.submission s
  JOIN challenges."Challenge" c
    ON c.id = s."challengeId"
  JOIN challenges."ChallengeTrack" tr
    ON tr.id = c."trackId"
  JOIN members.member m
    ON m."userId"::text = s."memberId"::text
  WHERE s.placement IS NOT NULL
    AND s.placement > 0
    AND tr.abbreviation = 'DS'
    AND (
      c.name ILIKE 'RUX%'
      OR c.name ILIKE 'TCO RUX%'
    )
  GROUP BY m."userId", m.handle
)
SELECT
  member_id,
  handle,
  NULL::int AS max_rating,
  placements_count,
  placements_count AS count,
  RANK() OVER (ORDER BY placements_count DESC, handle ASC) AS rank
FROM member_placements
ORDER BY placements_count DESC, handle ASC;
