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
    final_review."aggregateScore" AS final_score_raw,
    (
      passing_review.is_passing IS TRUE
      OR COALESCE(s."finalScore"::double precision, 0) > 98
    ) AS is_valid_submission
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
  LEFT JOIN LATERAL (
    SELECT TRUE AS is_passing
    FROM reviews."reviewSummation" AS rs
    WHERE rs."submissionId" = s.id
      AND rs."isPassing" = TRUE
      AND COALESCE(rs."isFinal", TRUE) = TRUE
    LIMIT 1
  ) AS passing_review ON TRUE
),
valid_submission_metrics AS (
  SELECT *
  FROM submission_metrics
  WHERE is_valid_submission = TRUE
),
valid_submitter_members AS MATERIALIZED (
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
  JOIN valid_submission_metrics AS vsmx
    ON vsmx."memberId" = res."memberId"
  GROUP BY
    cc.is_marathon_match,
    res."memberId"
),
standard_member_scores AS (
  SELECT
    vsm."memberId",
    ROUND(MAX(vsm.standard_score)::numeric, 2) AS "submissionScore"
  FROM valid_submission_metrics AS vsm
  GROUP BY vsm."memberId"
),
mm_latest_submission_scores AS (
  SELECT DISTINCT ON (vsm."memberId")
    vsm."memberId",
    vsm.provisional_score AS provisional_score_raw,
    vsm.final_score_raw,
    COALESCE(vsm.final_score_raw, vsm.provisional_score) AS effective_score_raw,
    vsm.submission_timestamp
  FROM valid_submission_metrics AS vsm
  ORDER BY
    vsm."memberId",
    vsm.submission_timestamp DESC NULLS LAST,
    vsm.submission_id DESC
),
mm_ranked_scores AS (
  SELECT
    mlss."memberId",
    CASE
      WHEN mlss.provisional_score_raw IS NULL THEN NULL
      ELSE ROUND(mlss.provisional_score_raw::numeric, 2)
    END AS "provisionalScore",
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
      WHEN vsm."memberId" ~ '^[0-9]+$' THEN vsm."memberId"::bigint
      ELSE NULL
    END
  ) AS "userId",
  COALESCE(
    NULLIF(TRIM(u.handle), ''),
    NULLIF(TRIM(mem.handle), ''),
    vsm."memberHandle"
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
  ) AS "country",
  vsm.is_marathon_match AS "isMarathonMatch",
  CASE
    WHEN vsm.is_marathon_match THEN NULL
    ELSE sms."submissionScore"
  END AS "submissionScore",
  CASE
    WHEN vsm.is_marathon_match THEN mrs."provisionalScore"
    ELSE NULL
  END AS "provisionalScore",
  CASE
    WHEN vsm.is_marathon_match THEN mrs."finalRank"
    ELSE NULL
  END AS "finalRank"
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
LEFT JOIN standard_member_scores AS sms
  ON sms."memberId" = vsm."memberId"
LEFT JOIN mm_ranked_scores AS mrs
  ON mrs."memberId" = vsm."memberId"
ORDER BY
  CASE
    WHEN vsm.is_marathon_match THEN mrs."finalRank"
    ELSE NULL
  END ASC NULLS LAST,
  CASE
    WHEN vsm.is_marathon_match THEN NULL
    ELSE sms."submissionScore"
  END DESC NULLS LAST,
  "handle" ASC NULLS LAST,
  "userId" ASC NULLS LAST;
