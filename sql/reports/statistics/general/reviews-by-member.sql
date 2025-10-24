WITH reviewers AS (
  SELECT
    r."memberId"::bigint AS user_id,
    COALESCE(NULLIF(TRIM(m.handle), ''), m.handle) AS handle,
    COUNT(DISTINCT r."challengeId")::int AS challenge_count
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId"
  LEFT JOIN members.member m
    ON m."userId"::text = r."memberId"::text
  WHERE (
    COALESCE(rr."nameLower", LOWER(rr.name)) IN (
      'reviewer', 'primary reviewer', 'secondary reviewer', 'failure reviewer', 'accuracy reviewer'
    )
    OR COALESCE(rr."nameLower", LOWER(rr.name)) LIKE '%reviewer%'
    OR COALESCE(rr."nameLower", LOWER(rr.name)) LIKE '%review%'
  )
    AND COALESCE(NULLIF(TRIM(m.handle), ''), m.handle) IS NOT NULL
  GROUP BY r."memberId", m.handle
)
SELECT
  rv.handle AS "reviewer.handle",
  rv.challenge_count AS "challenge.count",
  mmr.rating AS "submitter_profile.max_rating",
  DENSE_RANK() OVER (ORDER BY rv.challenge_count DESC, rv.handle ASC)::int AS rank
FROM reviewers rv
LEFT JOIN members."memberMaxRating" mmr
  ON mmr."userId" = rv.user_id
ORDER BY "challenge.count" DESC, "reviewer.handle" ASC;
