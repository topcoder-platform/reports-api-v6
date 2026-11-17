-- PM-6737: submissions where the member answered the submit-page question
-- "Did AI tools ... most of your submission?" (reviews.submission."aiAssisted").
SELECT
  c.id AS "challengeId",
  c.name AS "challengeName",
  ctr.name AS "challengeTrack",
  cty.name AS "challengeType",
  c.status AS "challengeStatus",
  s.id AS "submissionId",
  s.type AS "submissionType",
  s."memberId" AS "memberId",
  m.handle AS "submitterHandle",
  s."aiAssisted" AS "aiAssisted",
  COALESCE(s."submittedDate", s."createdAt") AS "submittedDate"
FROM reviews."submission" s
JOIN challenges."Challenge" c
  ON c.id = s."challengeId"
LEFT JOIN challenges."ChallengeTrack" ctr
  ON ctr.id = c."trackId"
LEFT JOIN challenges."ChallengeType" cty
  ON cty.id = c."typeId"
LEFT JOIN members."member" m
  ON m."userId"::text = s."memberId"
WHERE s."aiAssisted" IS NOT NULL
  -- filter by challenge
  AND ($1::text IS NULL OR c.id = $1::text)
  -- filter by challenge status
  AND ($2::text[] IS NULL OR c.status::text = ANY($2::text[]))
  -- filter by submission date bounds
  AND ($3::timestamptz IS NULL OR COALESCE(s."submittedDate", s."createdAt") >= $3::timestamptz)
  AND ($4::timestamptz IS NULL OR COALESCE(s."submittedDate", s."createdAt") <= $4::timestamptz)
ORDER BY COALESCE(s."submittedDate", s."createdAt") DESC, s.id;
