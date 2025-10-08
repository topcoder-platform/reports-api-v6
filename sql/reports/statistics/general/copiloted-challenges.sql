SELECT
  m."userId"             AS member_id,
  m.handle               AS handle,
  COUNT(DISTINCT r."challengeId")::int AS copiloted_challenges
FROM resources."Resource" r
JOIN resources."ResourceRole" rr
  ON rr.id = r."roleId"
JOIN members.member m
  ON m."userId"::text = r."memberId"::text
WHERE COALESCE(rr."nameLower", LOWER(rr.name)) = 'copilot'
GROUP BY m."userId", m.handle
ORDER BY copiloted_challenges DESC, handle ASC;

