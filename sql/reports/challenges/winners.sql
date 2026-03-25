WITH challenge_context AS (
  SELECT
    c.id,
    (ct.name = 'Marathon Match') AS is_marathon_match
  FROM challenges."Challenge" AS c
  JOIN challenges."ChallengeType" AS ct
    ON ct.id = c."typeId"
  WHERE c.id = $1::text
),
submission_metrics AS (
  SELECT
    s."memberId",
    COALESCE(
      final_review."aggregateScore",
      s."finalScore"::double precision,
      s."initialScore"::double precision
    ) AS standard_score,
    provisional_review.provisional_score,
    final_review."aggregateScore" AS final_score_raw
  FROM challenge_context AS cc
  JOIN reviews."submission" AS s
    ON s."challengeId" = cc.id
   AND s."memberId" IS NOT NULL
  LEFT JOIN LATERAL (
    SELECT rs."aggregateScore"
    FROM reviews."reviewSummation" AS rs
    WHERE rs."submissionId" = s.id
      AND COALESCE(rs."isFinal", TRUE) = TRUE
      AND rs."isProvisional" IS DISTINCT FROM TRUE
    ORDER BY COALESCE(rs."reviewedDate", rs."createdAt") DESC NULLS LAST, rs.id DESC
    LIMIT 1
  ) AS final_review ON TRUE
  LEFT JOIN LATERAL (
    SELECT MAX(rs."aggregateScore") AS provisional_score
    FROM reviews."reviewSummation" AS rs
    WHERE rs."submissionId" = s.id
      AND rs."isProvisional" IS TRUE
  ) AS provisional_review ON TRUE
),
winner_members AS MATERIALIZED (
  SELECT
    cc.is_marathon_match,
    cw."userId"::text AS "memberId",
    MAX(cw.handle) AS "winnerHandle",
    MIN(cw.placement) AS placement
  FROM challenge_context AS cc
  JOIN challenges."ChallengeWinner" AS cw
    ON cw."challengeId" = cc.id
   AND cw.type = 'PLACEMENT'
  GROUP BY
    cc.is_marathon_match,
    cw."userId"
),
standard_member_scores AS (
  SELECT
    sm."memberId",
    ROUND(MAX(sm.standard_score)::numeric, 2) AS "submissionScore"
  FROM submission_metrics AS sm
  GROUP BY sm."memberId"
),
mm_member_scores AS (
  SELECT
    sm."memberId",
    MAX(sm.provisional_score) AS provisional_score_raw,
    MAX(sm.final_score_raw) AS final_score_raw
  FROM submission_metrics AS sm
  GROUP BY sm."memberId"
),
mm_winner_scores AS (
  SELECT
    mms."memberId",
    CASE
      WHEN mms.provisional_score_raw IS NULL THEN NULL
      ELSE ROUND(mms.provisional_score_raw::numeric, 2)
    END AS "provisionalScore"
  FROM mm_member_scores AS mms
)
SELECT
  COALESCE(
    u.user_id::bigint,
    CASE
      WHEN wm."memberId" ~ '^[0-9]+$' THEN wm."memberId"::bigint
      ELSE NULL
    END
  ) AS "userId",
  COALESCE(
    NULLIF(TRIM(u.handle), ''),
    NULLIF(TRIM(mem.handle), ''),
    wm."winnerHandle"
  ) AS "handle",
  COALESCE(e.address, NULLIF(TRIM(mem.email), '')) AS "email",
  COALESCE(
    comp_code.name,
    comp_id.name,
    home_code.name,
    home_id.name,
    NULLIF(TRIM(mem."competitionCountryCode"), ''),
    NULLIF(TRIM(mem."homeCountryCode"), '')
  ) AS "country",
  wm.is_marathon_match AS "isMarathonMatch",
  CASE
    WHEN wm.is_marathon_match THEN NULL
    ELSE sms."submissionScore"
  END AS "submissionScore",
  CASE
    WHEN wm.is_marathon_match THEN mrs."provisionalScore"
    ELSE NULL
  END AS "provisionalScore",
  CASE
    WHEN wm.is_marathon_match THEN wm.placement
    ELSE NULL
  END AS "finalRank"
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
LEFT JOIN standard_member_scores AS sms
  ON sms."memberId" = wm."memberId"
LEFT JOIN mm_winner_scores AS mrs
  ON mrs."memberId" = wm."memberId"
ORDER BY
  wm.placement ASC NULLS LAST,
  CASE
    WHEN wm.is_marathon_match THEN NULL
    ELSE sms."submissionScore"
  END DESC NULLS LAST,
  "handle" ASC NULLS LAST,
  "userId" ASC NULLS LAST;
