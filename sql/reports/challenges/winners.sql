WITH challenge_context AS (
  SELECT
    c.id,
    (ct.name = 'Marathon Match') AS is_marathon_match,
    (c.status = 'COMPLETED') AS is_completed
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
    CASE
      WHEN s.status IN (
        'FAILED_SCREENING',
        'FAILED_REVIEW',
        'FAILED_CHECKPOINT_SCREENING',
        'FAILED_CHECKPOINT_REVIEW',
        'DELETED'
      ) THEN NULL
      WHEN provisional_review.has_provisional_review THEN CASE
        WHEN provisional_review.provisional_score >= 0 THEN provisional_review.provisional_score
        ELSE NULL
      END
      WHEN s."initialScore"::double precision >= 0 THEN s."initialScore"::double precision
      ELSE NULL
    END AS provisional_score,
    CASE
      WHEN NOT cc.is_completed THEN NULL
      WHEN s.status IN (
        'FAILED_SCREENING',
        'FAILED_REVIEW',
        'FAILED_CHECKPOINT_SCREENING',
        'FAILED_CHECKPOINT_REVIEW',
        'DELETED'
      ) THEN NULL
      WHEN final_review.has_final_review THEN CASE
        WHEN final_review."aggregateScore" >= 0 THEN final_review."aggregateScore"
        ELSE NULL
      END
      WHEN s."finalScore"::double precision >= 0 THEN s."finalScore"::double precision
      ELSE NULL
    END AS final_score_raw
  FROM challenge_context AS cc
  JOIN reviews."submission" AS s
    ON s."challengeId" = cc.id
   AND s."memberId" IS NOT NULL
  LEFT JOIN LATERAL (
    SELECT
      TRUE AS has_final_review,
      rs."aggregateScore"
    FROM reviews."reviewSummation" AS rs
    WHERE rs."submissionId" = s.id
      AND COALESCE(rs."isFinal", TRUE) = TRUE
      AND rs."isProvisional" IS DISTINCT FROM TRUE
    ORDER BY COALESCE(rs."reviewedDate", rs."createdAt") DESC NULLS LAST, rs.id DESC
    LIMIT 1
  ) AS final_review ON TRUE
  LEFT JOIN LATERAL (
    SELECT
      TRUE AS has_provisional_review,
      rs."aggregateScore" AS provisional_score
    FROM reviews."reviewSummation" AS rs
    WHERE rs."submissionId" = s.id
      AND rs."isProvisional" IS TRUE
    ORDER BY COALESCE(rs."reviewedDate", rs."createdAt") DESC NULLS LAST, rs.id DESC
    LIMIT 1
  ) AS provisional_review ON TRUE
),
winner_members AS MATERIALIZED (
  SELECT
    cc.is_marathon_match,
    cc.is_completed,
    cw."userId"::text AS "memberId",
    MAX(cw.handle) AS "winnerHandle",
    MIN(cw.placement) AS placement
  FROM challenge_context AS cc
  JOIN challenges."ChallengeWinner" AS cw
    ON cw."challengeId" = cc.id
   AND cw.type = 'PLACEMENT'
  GROUP BY
    cc.is_marathon_match,
    cc.is_completed,
    cw."userId"
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
    sm.final_score_raw
  FROM submission_metrics AS sm
  WHERE
    sm.provisional_score IS NOT NULL
    OR sm.final_score_raw IS NOT NULL
  ORDER BY
    sm."memberId",
    sm.submission_timestamp DESC NULLS LAST,
    sm.submission_id DESC
),
mm_winner_scores AS (
  SELECT
    mlss."memberId",
    CASE
      WHEN mlss.provisional_score_raw IS NULL THEN NULL
      ELSE ROUND(mlss.provisional_score_raw::numeric, 2)
    END AS "provisionalScore",
    CASE
      WHEN mlss.final_score_raw IS NULL THEN NULL
      ELSE ROUND(mlss.final_score_raw::numeric, 2)
    END AS "finalScore"
  FROM mm_latest_submission_scores AS mlss
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
    WHEN wm.is_marathon_match THEN mrs."finalScore"
    ELSE NULL
  END AS "finalScore",
  CASE
    WHEN wm.is_marathon_match AND wm.is_completed THEN wm.placement
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
