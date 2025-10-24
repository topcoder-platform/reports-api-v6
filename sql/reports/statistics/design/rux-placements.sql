WITH placements AS (
  SELECT
    s."memberId"::bigint AS user_id,
    COALESCE(NULLIF(TRIM(m.handle), ''), m.handle) AS handle,
    COUNT(DISTINCT s."challengeId")::int AS placements_count
  FROM reviews.submission s
  JOIN challenges."Challenge" c
    ON c.id = s."challengeId"
  JOIN challenges."ChallengeTrack" tr
    ON tr.id = c."trackId"
  LEFT JOIN members.member m
    ON m."userId"::text = s."memberId"::text
  WHERE s.placement IS NOT NULL
    AND s.placement > 0
    AND tr.abbreviation = 'DS'
    AND (
      c.name ILIKE 'RUX%'
      OR c.name ILIKE 'TCO RUX%'
    )
    AND COALESCE(NULLIF(TRIM(m.handle), ''), m.handle) IS NOT NULL
  GROUP BY s."memberId", m.handle
)
SELECT
  p.handle AS "submitter.handle",
  mmr.rating AS "submitter_profile.max_rating",
  p.placements_count AS "challenge.count",
  DENSE_RANK() OVER (ORDER BY p.placements_count DESC, p.handle ASC)::int AS rank
FROM placements p
LEFT JOIN members."memberMaxRating" mmr
  ON mmr."userId" = p.user_id
ORDER BY "challenge.count" DESC, "submitter.handle" ASC;
