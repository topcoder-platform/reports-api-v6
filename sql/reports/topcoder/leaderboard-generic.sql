WITH challenge_context AS (
  SELECT
    c.id AS challenge_id,
    c.name AS challenge_name,
    COALESCE(
      cp."actualStartDate",
      cp."scheduledStartDate"
    ) AS start_date,
    COALESCE(
      cp."actualEndDate",
      cp."scheduledEndDate"
    ) AS end_date,
    GREATEST(
      1,
      CEIL(
        EXTRACT(EPOCH FROM COALESCE(cp."actualEndDate", cp."scheduledEndDate") - COALESCE(cp."actualStartDate", cp."scheduledStartDate"))
          / 86400.0
      )
    ) AS duration_days
  FROM challenges."Challenge" AS c
  JOIN challenges."ChallengePhase" AS cp
    ON cp."challengeId" = c.id
   AND cp.name = 'Submission'
  WHERE c.id = ANY($1::text[])
),
member_submissions AS (
  SELECT
    cc.challenge_id,
    s.id AS submission_id,
    s."memberId" AS user_id,
    COALESCE(
      NULLIF(TRIM(u.handle), ''),
      NULLIF(TRIM(mem.handle), ''),
      fallback.member_handle
    ) AS handle,
    COALESCE(NULLIF(TRIM(mem."firstName"), ''), NULLIF(TRIM(u.handle), ''), NULLIF(TRIM(mem.handle), '')) AS name,
    COALESCE(
      home_code.name,
      home_id.name,
      comp_code.name,
      comp_id.name,
      NULLIF(TRIM(mem."competitionCountryCode"), ''),
      NULLIF(TRIM(mem."homeCountryCode"), '')
    ) AS country,
    COALESCE(
      NULLIF(TRIM(mem."competitionCountryCode"), ''),
      NULLIF(TRIM(mem."homeCountryCode"), '')
    ) AS country_code,
    mem."photoURL" AS photoURL,
    mmr.rating AS rating,
    mmr."ratingColor" AS ratingColor,
    COALESCE(
      CASE
        WHEN challenge_reviewers.is_ai_only_challenge
          THEN ai_decision."totalScore"
        ELSE final_review."aggregateScore"
      END,
      s."finalScore"::double precision,
      s."initialScore"::double precision
    ) AS score,
    COALESCE(s."submittedDate", s."createdAt") AS submitted_date,
    cc.duration_days
  FROM challenge_context AS cc
  JOIN reviews."submission" AS s
    ON s."challengeId" = cc.challenge_id
   AND s."memberId" IS NOT NULL
  LEFT JOIN LATERAL (
    SELECT rs."aggregateScore", rs."scorecardId", rs."isPassing"
    FROM reviews."reviewSummation" AS rs
    WHERE rs."submissionId" = s.id
      AND COALESCE(rs."isFinal", TRUE) = TRUE
      AND rs."isProvisional" IS DISTINCT FROM TRUE
    ORDER BY COALESCE(rs."reviewedDate", rs."createdAt") DESC NULLS LAST, rs.id DESC
    LIMIT 1
  ) AS final_review ON TRUE
  LEFT JOIN LATERAL (
    SELECT
      COUNT(*) > 0 AS has_reviewers,
      BOOL_AND(cr."aiWorkflowId" IS NOT NULL AND cr."isMemberReview" = FALSE) AND COUNT(*) > 0 AS is_ai_only_challenge
    FROM challenges."ChallengeReviewer" AS cr
    WHERE cr."challengeId" = cc.challenge_id
  ) AS challenge_reviewers ON TRUE
  LEFT JOIN LATERAL (
    SELECT d."totalScore", d.status
    FROM reviews."aiReviewDecision" AS d
    WHERE d."submissionId" = s.id
      AND UPPER(d.status::text) != 'PENDING'
    ORDER BY d."updatedAt" DESC NULLS LAST
    LIMIT 1
  ) AS ai_decision ON TRUE
  LEFT JOIN reviews.scorecard AS sc
    ON sc.id = final_review."scorecardId"
  LEFT JOIN members."member" AS mem
    ON mem."userId" = s."memberId"::bigint
  LEFT JOIN LATERAL (
    SELECT DISTINCT ON (mmr."userId")
      mmr.rating,
      mmr."ratingColor"
    FROM members."memberMaxRating" AS mmr
    WHERE mmr."userId" = s."memberId"::bigint
    ORDER BY mmr."userId", mmr.rating DESC
  ) AS mmr ON TRUE
  LEFT JOIN identity."user" AS u
    ON s."memberId" ~ '^[0-9]+$'
   AND u.user_id = s."memberId"::numeric
  LEFT JOIN LATERAL (
    SELECT MAX(r."memberHandle") AS member_handle
    FROM resources."Resource" AS r
    WHERE r."challengeId" = cc.challenge_id
      AND r."memberId" = s."memberId"
  ) AS fallback ON TRUE
  LEFT JOIN lookups."Country" AS home_code
    ON UPPER(home_code."countryCode") = UPPER(mem."homeCountryCode")
  LEFT JOIN lookups."Country" AS home_id
    ON UPPER(home_id.id) = UPPER(mem."homeCountryCode")
  LEFT JOIN lookups."Country" AS comp_code
    ON UPPER(comp_code."countryCode") = UPPER(mem."competitionCountryCode")
  LEFT JOIN lookups."Country" AS comp_id
    ON UPPER(comp_id.id) = UPPER(mem."competitionCountryCode")
  WHERE COALESCE(
          CASE
            WHEN challenge_reviewers.is_ai_only_challenge
              THEN ai_decision."totalScore"
            ELSE final_review."aggregateScore"
          END,
          s."finalScore"::double precision,
          s."initialScore"::double precision
        ) IS NOT NULL
    AND (
      (challenge_reviewers.is_ai_only_challenge
        AND UPPER(ai_decision.status::text) = 'PASSED')
      OR (
        NOT challenge_reviewers.is_ai_only_challenge
        AND (
          final_review."isPassing" IS TRUE
          OR (
            final_review."isPassing" IS NULL
            AND COALESCE(final_review."aggregateScore", s."finalScore"::double precision, s."initialScore"::double precision)
              >= COALESCE(sc."minimumPassingScore", sc."minScore", 0)
          )
        )
      )
    )
),
unique_member_submissions AS (
  SELECT DISTINCT ON (challenge_id, user_id)
    ms.*
  FROM member_submissions AS ms
  ORDER BY
    ms.challenge_id,
    ms.user_id,
    ms.score DESC NULLS LAST,
    ms.submitted_date DESC NULLS LAST,
    ms.submission_id DESC
),
challenge_prizes AS (
  SELECT
    cps."challengeId" AS challenge_id,
    ROW_NUMBER() OVER (PARTITION BY cps."challengeId" ORDER BY p.id) AS placement,
    p.value
  FROM challenges."ChallengePrizeSet" AS cps
  JOIN challenges."Prize" AS p
    ON p."prizeSetId" = cps.id
  WHERE cps.type = 'PLACEMENT'
),
challenge_summary AS (
  SELECT
    cc.challenge_id,
    cc.challenge_name,
    cc.duration_days,
    COALESCE(SUM(pr.value), 0) AS prize_pool,
    (
      SELECT COUNT(DISTINCT ums.user_id)
      FROM unique_member_submissions AS ums
      WHERE ums.challenge_id = cc.challenge_id
    ) AS submissions_count,
    JSONB_AGG(
      JSONB_BUILD_OBJECT('placement', pr.placement, 'value', pr.value) ORDER BY pr.placement
    ) FILTER (WHERE pr.value IS NOT NULL) AS placement_prizes
  FROM challenge_context AS cc
  LEFT JOIN challenge_prizes AS pr
    ON pr.challenge_id = cc.challenge_id
  GROUP BY cc.challenge_id, cc.challenge_name, cc.duration_days
)
SELECT
  ums.challenge_id AS "challengeId",
  cs.challenge_name AS "challengeName",
  cs.duration_days AS "durationDays",
  cs.prize_pool AS "prizePool",
  cs.submissions_count AS "submissionsCount",
  cs.placement_prizes AS "placementPrizes",
  ums.user_id AS "userId",
  ums.handle AS handle,
  ums.name AS name,
  COALESCE(
    home_code.name,
    home_id.name,
    comp_code.name,
    comp_id.name,
    NULLIF(TRIM(ums.country), '')
  ) AS country,
  COALESCE(
    NULLIF(TRIM(ums.country_code), ''),
    NULLIF(TRIM(ums.country_code), '')
  ) AS "countryCode",
  ums.photoURL AS "photoURL",
  ums.rating AS rating,
  ums.ratingColor AS "ratingColor",
  ums.score AS score,
  ums.submitted_date AS submitted_date,
  ROW_NUMBER() OVER (
    PARTITION BY ums.challenge_id
    ORDER BY ums.score DESC NULLS LAST, ums.submitted_date ASC NULLS LAST, ums.user_id ASC
  ) AS placement
FROM unique_member_submissions AS ums
LEFT JOIN lookups."Country" AS home_code
  ON UPPER(home_code."countryCode") = UPPER(ums.country_code)
LEFT JOIN lookups."Country" AS home_id
  ON UPPER(home_id.id) = UPPER(ums.country_code)
LEFT JOIN lookups."Country" AS comp_code
  ON UPPER(comp_code."countryCode") = UPPER(ums.country_code)
LEFT JOIN lookups."Country" AS comp_id
  ON UPPER(comp_id.id) = UPPER(ums.country_code)
JOIN challenge_summary AS cs
  ON cs.challenge_id = ums.challenge_id
ORDER BY ums.challenge_id, ums.score DESC NULLS LAST, ums.submitted_date ASC NULLS LAST, ums.user_id ASC;
