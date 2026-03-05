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
winner_members AS MATERIALIZED (
  SELECT
    cc.id AS "challengeId",
    cc.is_marathon_match,
    cw."userId"::text AS "memberId",
    MAX(cw.handle) AS "winnerHandle",
    MIN(cw.placement) AS placement
  FROM challenge_context AS cc
  JOIN challenges."ChallengeWinner" AS cw
    ON cw."challengeId" = cc.id
  GROUP BY
    cc.id,
    cc.is_marathon_match,
    cw."userId"
)
SELECT
  COALESCE(
    u.user_id::bigint,
    CASE
      WHEN wm."memberId" ~ '^[0-9]+$' THEN wm."memberId"::bigint
      ELSE NULL
    END
  ) AS "userId",
  COALESCE(u.handle, wm."winnerHandle") AS "handle",
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
    WHEN wm.is_marathon_match THEN mm_score."submissionScore"
    ELSE NULL
  END AS "submissionScore"
FROM winner_members AS wm
LEFT JOIN identity."user" AS u
  ON wm."memberId" ~ '^[0-9]+$'
 AND u.user_id = wm."memberId"::numeric
LEFT JOIN identity.email AS e
  ON e.user_id = u.user_id
 AND e.primary_ind = 1
LEFT JOIN members."member" AS mem
  ON wm."memberId" ~ '^[0-9]+$'
 AND mem."userId" = wm."memberId"::bigint
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
  WHERE s."challengeId" = wm."challengeId"
    AND s."memberId" = wm."memberId"
) AS mm_score ON true
ORDER BY
  "submissionScore" DESC NULLS LAST,
  wm.placement ASC NULLS LAST,
  "handle" ASC NULLS LAST,
  "userId" ASC NULLS LAST;
