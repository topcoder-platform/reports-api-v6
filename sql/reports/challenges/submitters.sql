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
    s.id AS submission_id,
    s."memberId",
    COALESCE(s."submittedDate", s."createdAt") AS submission_timestamp,
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
    SELECT rs."aggregateScore" AS provisional_score
    FROM reviews."reviewSummation" AS rs
    WHERE rs."submissionId" = s.id
      AND rs."isProvisional" IS TRUE
    ORDER BY COALESCE(rs."reviewedDate", rs."createdAt") DESC NULLS LAST, rs.id DESC
    LIMIT 1
  ) AS provisional_review ON TRUE
),
submitter_members AS MATERIALIZED (
  SELECT
    cc.is_marathon_match,
    res."memberId",
    MAX(res."memberHandle") AS "memberHandle"
  FROM challenge_context AS cc
  JOIN resources."Resource" AS res
    ON res."challengeId" = cc.id
  JOIN resources."ResourceRole" AS rr
    ON rr.id = res."roleId"
   AND rr.name = 'Submitter'
  JOIN submission_metrics AS smx
    ON smx."memberId" = res."memberId"
  GROUP BY
    cc.is_marathon_match,
    res."memberId"
),
standard_member_scores AS (
  SELECT
    sm."memberId",
    ROUND(MAX(sm.standard_score)::numeric, 2) AS "submissionScore"
  FROM submission_metrics AS sm
  GROUP BY sm."memberId"
),
mm_latest_submission_scores AS (
  SELECT DISTINCT ON (sm."memberId")
    sm."memberId",
    sm.provisional_score AS provisional_score_raw,
    sm.final_score_raw,
    COALESCE(sm.final_score_raw, sm.provisional_score) AS effective_score_raw,
    sm.submission_timestamp
  FROM submission_metrics AS sm
  ORDER BY
    sm."memberId",
    sm.submission_timestamp DESC NULLS LAST,
    sm.submission_id DESC
),
mm_ranked_scores AS (
  SELECT
    mlss."memberId",
    CASE
      WHEN mlss.provisional_score_raw IS NULL THEN NULL
      ELSE ROUND(mlss.provisional_score_raw::numeric, 2)
    END AS "provisionalScore",
    CASE
      WHEN mlss.final_score_raw IS NULL THEN NULL
      ELSE ROUND(mlss.final_score_raw::numeric, 2)
    END AS "finalScore",
    CASE
      WHEN mlss.effective_score_raw IS NULL THEN NULL
      ELSE ROW_NUMBER() OVER (
        ORDER BY
          mlss.effective_score_raw DESC NULLS LAST,
          mlss.submission_timestamp ASC NULLS LAST,
          mlss."memberId" ASC
      )
    END AS "finalRank"
  FROM mm_latest_submission_scores AS mlss
)
SELECT
  COALESCE(
    u.user_id::bigint,
    CASE
      WHEN sm."memberId" ~ '^[0-9]+$' THEN sm."memberId"::bigint
      ELSE NULL
    END
  ) AS "userId",
  COALESCE(
    NULLIF(TRIM(u.handle), ''),
    NULLIF(TRIM(mem.handle), ''),
    sm."memberHandle"
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
  sm.is_marathon_match AS "isMarathonMatch",
  CASE
    WHEN sm.is_marathon_match THEN NULL
    ELSE sms."submissionScore"
  END AS "submissionScore",
  CASE
    WHEN sm.is_marathon_match THEN mrs."provisionalScore"
    ELSE NULL
  END AS "provisionalScore",
  CASE
    WHEN sm.is_marathon_match THEN mrs."finalScore"
    ELSE NULL
  END AS "finalScore",
  CASE
    WHEN sm.is_marathon_match THEN mrs."finalRank"
    ELSE NULL
  END AS "finalRank"
FROM submitter_members AS sm
LEFT JOIN identity."user" AS u
  ON sm."memberId" ~ '^[0-9]+$'
 AND u.user_id = sm."memberId"::numeric
LEFT JOIN identity.email AS e
  ON e.user_id = u.user_id
 AND e.primary_ind = 1
LEFT JOIN members."member" AS mem
  ON sm."memberId" ~ '^[0-9]+$'
 AND mem."userId" = sm."memberId"::bigint
LEFT JOIN lookups."Country" AS home_code
  ON UPPER(home_code."countryCode") = UPPER(mem."homeCountryCode")
LEFT JOIN lookups."Country" AS home_id
  ON UPPER(home_id.id) = UPPER(mem."homeCountryCode")
LEFT JOIN lookups."Country" AS comp_code
  ON UPPER(comp_code."countryCode") = UPPER(mem."competitionCountryCode")
LEFT JOIN lookups."Country" AS comp_id
  ON UPPER(comp_id.id) = UPPER(mem."competitionCountryCode")
LEFT JOIN standard_member_scores AS sms
  ON sms."memberId" = sm."memberId"
LEFT JOIN mm_ranked_scores AS mrs
  ON mrs."memberId" = sm."memberId"
ORDER BY
  CASE
    WHEN sm.is_marathon_match THEN mrs."finalRank"
    ELSE NULL
  END ASC NULLS LAST,
  CASE
    WHEN sm.is_marathon_match THEN NULL
    ELSE sms."submissionScore"
  END DESC NULLS LAST,
  "handle" ASC NULLS LAST,
  "userId" ASC NULLS LAST;
