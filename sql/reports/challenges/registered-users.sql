WITH challenge_context AS (
  SELECT c.id
  FROM challenges."Challenge" AS c
  WHERE c.id = $1::text
),
registered_members AS MATERIALIZED (
  SELECT
    res."memberId",
    MAX(res."memberHandle") AS "memberHandle"
  FROM challenge_context AS cc
  JOIN resources."Resource" AS res
    ON res."challengeId" = cc.id
  JOIN resources."ResourceRole" AS rr
    ON rr.id = res."roleId"
   AND rr.name = 'Submitter'
  GROUP BY res."memberId"
)
SELECT
  COALESCE(
    u.user_id::bigint,
    CASE
      WHEN rm."memberId" ~ '^[0-9]+$' THEN rm."memberId"::bigint
      ELSE NULL
    END
  ) AS "userId",
  COALESCE(
    NULLIF(TRIM(u.handle), ''),
    NULLIF(TRIM(mem.handle), ''),
    rm."memberHandle"
  ) AS "handle",
  COALESCE(
    NULLIF(TRIM(u.first_name), ''),
    NULLIF(TRIM(mem."firstName"), '')
  ) AS "firstName",
  COALESCE(
    NULLIF(TRIM(u.last_name), ''),
    NULLIF(TRIM(mem."lastName"), '')
  ) AS "lastName",
  COALESCE(e.address, NULLIF(TRIM(mem.email), '')) AS "email",
  COALESCE(
    comp_code.name,
    comp_id.name,
    home_code.name,
    home_id.name,
    NULLIF(TRIM(mem."competitionCountryCode"), ''),
    NULLIF(TRIM(mem."homeCountryCode"), '')
  ) AS "country"
FROM registered_members AS rm
LEFT JOIN identity."user" AS u
  ON rm."memberId" ~ '^[0-9]+$'
 AND u.user_id = rm."memberId"::numeric
LEFT JOIN identity.email AS e
  ON e.user_id = u.user_id
 AND e.primary_ind = 1
LEFT JOIN members."member" AS mem
  ON rm."memberId" ~ '^[0-9]+$'
 AND mem."userId" = rm."memberId"::bigint
LEFT JOIN lookups."Country" AS home_code
  ON UPPER(home_code."countryCode") = UPPER(mem."homeCountryCode")
LEFT JOIN lookups."Country" AS home_id
  ON UPPER(home_id.id) = UPPER(mem."homeCountryCode")
LEFT JOIN lookups."Country" AS comp_code
  ON UPPER(comp_code."countryCode") = UPPER(mem."competitionCountryCode")
LEFT JOIN lookups."Country" AS comp_id
  ON UPPER(comp_id.id) = UPPER(mem."competitionCountryCode")
ORDER BY
  "handle" ASC NULLS LAST,
  "userId" ASC NULLS LAST;
