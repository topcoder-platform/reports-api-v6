SELECT
  m."userId"             AS member_id,
  m.handle               AS handle,
  COUNT(DISTINCT r."challengeId")::int AS review_count
FROM resources."Resource" r
JOIN resources."ResourceRole" rr
  ON rr.id = r."roleId"
JOIN members.member m
  ON m."userId"::text = r."memberId"::text
WHERE (
  COALESCE(rr."nameLower", LOWER(rr.name)) IN (
    'reviewer', 'primary reviewer', 'secondary reviewer', 'failure reviewer', 'accuracy reviewer'
  )
  OR COALESCE(rr."nameLower", LOWER(rr.name)) LIKE '%reviewer%'
  OR COALESCE(rr."nameLower", LOWER(rr.name)) LIKE '%review%'
)
GROUP BY m."userId", m.handle
ORDER BY review_count DESC, handle ASC;

