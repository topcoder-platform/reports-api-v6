WITH design_first_submissions AS (
  SELECT
    s."memberId"::text               AS member_id,
    MIN(s."submittedDate")           AS first_submission_date
  FROM reviews.submission s
  JOIN challenges."Challenge" c
    ON c.id = s."challengeId"
  JOIN challenges."ChallengeTrack" tr
    ON tr.id = c."trackId"
  WHERE tr.abbreviation = 'DESIGN'
  GROUP BY s."memberId"
)
SELECT
  m."userId"           AS member_id,
  m.handle             AS handle,
  d.first_submission_date
FROM design_first_submissions d
JOIN members.member m
  ON m."userId"::text = d.member_id
WHERE d.first_submission_date >= NOW() - INTERVAL '3 months'
ORDER BY d.first_submission_date DESC, handle ASC;

