SELECT
  s.name AS "skillName",
  COUNT(DISTINCT ch.id) AS "challengeCount"
FROM challenges."Challenge" ch
JOIN challenges."ChallengeSkill" cs
  ON cs."challengeId" = ch.id
JOIN skills."skill" s
  ON s.id = cs."skillId"::uuid
JOIN projects."projects" p
  ON p.id = ch."projectId"::bigint
WHERE p."billingAccountId"::text = '80000062'
GROUP BY s.name
ORDER BY "challengeCount" DESC, "skillName";
