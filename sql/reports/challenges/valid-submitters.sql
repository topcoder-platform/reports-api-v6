WITH challenge_context AS (
  SELECT
    c.id,
    ct.name AS "challengeType",
    (ct.name = 'Marathon Match') AS is_marathon_match
  FROM challenges."Challenge" AS c
  JOIN challenges."ChallengeType" AS ct
    ON ct.id = c."typeId"
  WHERE c.id = $1::text
),
valid_submitter_members AS MATERIALIZED (
  SELECT
    cc.id AS "challengeId",
    cc.is_marathon_match,
    res."memberId",
    MAX(res."memberHandle") AS "memberHandle"
  FROM challenge_context AS cc
  JOIN resources."Resource" AS res
    ON res."challengeId" = cc.id
  JOIN resources."ResourceRole" AS rr
    ON rr.id = res."roleId"
   AND rr.name = 'Submitter'
  JOIN reviews."submission" AS s
    ON s."challengeId" = cc.id
   AND s."memberId" = res."memberId"
   AND (
     -- Prefer explicit passing review summation when available (review-api v6 flow).
     EXISTS (
       SELECT 1
       FROM reviews."reviewSummation" AS rs_pass
       WHERE rs_pass."submissionId" = s.id
         AND rs_pass."isPassing" = TRUE
         AND COALESCE(rs_pass."isFinal", TRUE) = TRUE
     )
     -- Keep legacy finalScore threshold fallback for older data where summations may be missing.
     OR s."finalScore" > 98
   )
  GROUP BY
    cc.id,
    cc.is_marathon_match,
    res."memberId"
)
SELECT
  COALESCE(
    u.user_id::bigint,
    CASE
      WHEN vsm."memberId" ~ '^[0-9]+$' THEN vsm."memberId"::bigint
      ELSE NULL
    END
  ) AS "userId",
  COALESCE(u.handle, vsm."memberHandle") AS "handle",
  e.address AS "email",
  -- Resolve competition country first, then fall back to home country.
  COALESCE(
    comp_code.name,
    comp_id.name,
    home_code.name,
    home_id.name,
    mem."competitionCountryCode",
    mem."homeCountryCode"
  ) AS "country",
  -- Marathon Match detection controls whether aggregate score is emitted.
  CASE
    WHEN vsm.is_marathon_match THEN mm_score."submissionScore"
    ELSE NULL
  END AS "submissionScore"
FROM valid_submitter_members AS vsm
LEFT JOIN identity."user" AS u
  ON vsm."memberId" ~ '^[0-9]+$'
 AND u.user_id = vsm."memberId"::numeric
LEFT JOIN identity.email AS e
  ON e.user_id = u.user_id
 AND e.primary_ind = 1
LEFT JOIN members."member" AS mem
  ON vsm."memberId" ~ '^[0-9]+$'
 AND mem."userId" = vsm."memberId"::bigint
LEFT JOIN lookups."Country" AS home_code
  ON UPPER(home_code."countryCode") = UPPER(mem."homeCountryCode")
LEFT JOIN lookups."Country" AS home_id
  ON UPPER(home_id.id) = UPPER(mem."homeCountryCode")
LEFT JOIN lookups."Country" AS comp_code
  ON UPPER(comp_code."countryCode") = UPPER(mem."competitionCountryCode")
LEFT JOIN lookups."Country" AS comp_id
  ON UPPER(comp_id.id) = UPPER(mem."competitionCountryCode")
LEFT JOIN LATERAL (
  -- For MM, use the best aggregateScore across this member's submissions.
  SELECT ROUND(MAX(rs."aggregateScore")::numeric, 2) AS "submissionScore"
  FROM reviews."submission" AS s
  JOIN reviews."reviewSummation" AS rs
    ON rs."submissionId" = s.id
  WHERE s."challengeId" = vsm."challengeId"
    AND s."memberId" = vsm."memberId"
) AS mm_score ON true
ORDER BY
  "submissionScore" DESC NULLS LAST,
  "handle" ASC NULLS LAST,
  "userId" ASC NULLS LAST;
