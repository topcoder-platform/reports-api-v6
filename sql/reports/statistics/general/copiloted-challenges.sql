WITH copilots AS (
  SELECT
    r."memberId"::bigint AS user_id,
    COALESCE(NULLIF(TRIM(m.handle), ''), m.handle) AS handle,
    COUNT(DISTINCT r."challengeId")::int AS challenge_count
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId"
  LEFT JOIN members.member m
    ON m."userId"::text = r."memberId"::text
  WHERE COALESCE(rr."nameLower", LOWER(rr.name)) = 'copilot'
    AND COALESCE(NULLIF(TRIM(m.handle), ''), m.handle) IS NOT NULL
  GROUP BY r."memberId", m.handle
)
SELECT
  c.handle AS "copilot.handle",
  c.challenge_count AS "challenge.count",
  mmr.rating AS "copilot_profile.max_rating",
  DENSE_RANK() OVER (ORDER BY c.challenge_count DESC, c.handle ASC)::int AS rank
FROM copilots c
LEFT JOIN members."memberMaxRating" mmr
  ON mmr."userId" = c.user_id
ORDER BY "challenge.count" DESC, "copilot.handle" ASC;
