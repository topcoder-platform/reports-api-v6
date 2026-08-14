WITH challenge_context AS (
  SELECT
    c.id AS challenge_id,
    c.name AS challenge_name,
    LOWER(ct.name) = 'marathon match' AS is_marathon_match
  FROM challenges."Challenge" AS c
  JOIN challenges."ChallengeType" AS ct
    ON ct.id = c."typeId"
  WHERE c.id = ANY($1::text[])
),
-- Automated review types that must never contribute a leaderboard score.
scan_review_types AS (
  SELECT rt.id
  FROM reviews."reviewType" AS rt
  WHERE LOWER(rt.name) IN ('av scan', 'sonarqube review', 'virus scan')
),
submission_metrics AS (
  SELECT
    cc.challenge_id,
    cc.challenge_name,
    cc.is_marathon_match,
    s.id AS submission_id,
    s."memberId" AS user_id,
    COALESCE(
      NULLIF(TRIM(u.handle), ''),
      NULLIF(TRIM(mem.handle), ''),
      fallback.member_handle
    ) AS handle,
    COALESCE(NULLIF(TRIM(mem."firstName"), ''), NULLIF(TRIM(u.handle), ''), NULLIF(TRIM(mem.handle), '')) AS name,
    COALESCE(
      NULLIF(TRIM(mem."competitionCountryCode"), ''),
      NULLIF(TRIM(mem."homeCountryCode"), '')
    ) AS country_code,
    mem."photoURL" AS photo_url,
    mmr.rating AS rating,
    mmr."ratingColor" AS rating_color,
    -- Final score comes ONLY from a non-provisional reviewSummation. submission."finalScore"
    -- is a denormalized column that is written during provisional MM reviews too, so using it
    -- here would surface a "final" score for matches that are still running.
    final_review."aggregateScore" AS final_score,
    final_review.is_strict_final,
    -- Provisional score: latest non-scan review row first, provisional summation second.
    -- NULLIF(..., 0) reproduces the old `||` chain, where a 0 review score fell through to
    -- the provisional summation before ending up back at 0.
    COALESCE(
      NULLIF(latest_review.review_score, 0),
      provisional_review.provisional_score,
      latest_review.review_score
    ) AS provisional_score,
    COALESCE(s."submittedDate", s."createdAt") AS submitted_date,
    COALESCE(s."updatedAt", s."submittedDate", s."createdAt") AS updated_date
  FROM challenge_context AS cc
  JOIN reviews."submission" AS s
    ON s."challengeId" = cc.challenge_id
   AND s."memberId" IS NOT NULL
  LEFT JOIN LATERAL (
    SELECT
      rs."aggregateScore",
      rs."isFinal" IS TRUE AS is_strict_final
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
    SELECT COALESCE(r."finalScore", r."initialScore") AS review_score
    FROM reviews.review AS r
    WHERE r."submissionId" = s.id
      AND (r."typeId" IS NULL OR r."typeId" NOT IN (SELECT id FROM scan_review_types))
      AND COALESCE(r."finalScore", r."initialScore") IS NOT NULL
    ORDER BY COALESCE(r."reviewDate", r."updatedAt", r."createdAt") DESC NULLS LAST, r.id DESC
    LIMIT 1
  ) AS latest_review ON TRUE
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
),
scored_submissions AS (
  SELECT sm.*
  FROM submission_metrics AS sm
  WHERE sm.handle IS NOT NULL
    AND (sm.final_score IS NOT NULL OR sm.provisional_score IS NOT NULL)
),
unique_member_submissions AS (
  SELECT DISTINCT ON (challenge_id, user_id)
    ss.*
  FROM scored_submissions AS ss
  ORDER BY
    ss.challenge_id,
    ss.user_id,
    ss.submitted_date DESC NULLS LAST,
    ss.updated_date DESC NULLS LAST,
    ss.submission_id DESC
),
-- A match is "complete" only when at least one submission carries an isFinal summation.
-- Until then the leaderboard is ranked on the provisional/standard score.
challenge_progress AS (
  SELECT
    challenge_id,
    BOOL_OR(is_strict_final AND final_score IS NOT NULL) AS has_final_results
  FROM unique_member_submissions
  GROUP BY challenge_id
),
ranked_submissions AS (
  SELECT
    ums.challenge_id,
    ums.challenge_name,
    ums.is_marathon_match,
    ums.user_id,
    ums.submission_id,
    ums.handle,
    ums.name,
    ums.country_code,
    ums.photo_url,
    ums.rating,
    ums.rating_color,
    ums.final_score,
    ums.provisional_score,
    COALESCE(ums.final_score, ums.provisional_score) AS standard_score,
    ums.submitted_date,
    ROW_NUMBER() OVER (
      PARTITION BY ums.challenge_id
      ORDER BY
        CASE
          WHEN cp.has_final_results THEN ums.final_score
          ELSE COALESCE(ums.final_score, ums.provisional_score)
        END DESC NULLS LAST,
        ums.submitted_date ASC NULLS LAST,
        ums.user_id ASC
    ) AS placement,
    ROW_NUMBER() OVER (
      PARTITION BY ums.challenge_id
      ORDER BY
        ums.provisional_score DESC NULLS LAST,
        ums.submitted_date ASC NULLS LAST,
        ums.user_id ASC
    ) AS provisional_rank
  FROM unique_member_submissions AS ums
  JOIN challenge_progress AS cp
    ON cp.challenge_id = ums.challenge_id
)
SELECT
  rs.challenge_id AS "challengeId",
  rs.challenge_name AS "challengeName",
  rs.is_marathon_match AS "isMarathonMatch",
  rs.user_id AS "userId",
  rs.submission_id AS "submissionId",
  rs.handle,
  rs.name,
  COALESCE(
    comp_code.name,
    comp_id.name,
    NULLIF(TRIM(rs.country_code), '')
  ) AS country,
  NULLIF(TRIM(rs.country_code), '') AS "countryCode",
  rs.photo_url AS "photoURL",
  rs.rating AS rating,
  rs.rating_color AS "ratingColor",
  rs.placement,
  rs.provisional_rank AS "provisionalRank",
  -- Match the legacy formatting: 2 decimals, with anything in (0, 0.01) pinned to 0.01
  -- so a non-zero score never renders as 0.
  CASE
    WHEN rs.provisional_score IS NULL THEN NULL
    WHEN rs.provisional_score > 0 AND rs.provisional_score < 0.01 THEN 0.01
    ELSE ROUND(rs.provisional_score::numeric, 2)::double precision
  END AS "provisionalScore",
  CASE
    WHEN rs.final_score IS NULL THEN NULL
    WHEN rs.final_score > 0 AND rs.final_score < 0.01 THEN 0.01
    ELSE ROUND(rs.final_score::numeric, 2)::double precision
  END AS "finalScore",
  CASE
    WHEN rs.standard_score IS NULL THEN NULL
    WHEN rs.standard_score > 0 AND rs.standard_score < 0.01 THEN 0.01
    ELSE ROUND(rs.standard_score::numeric, 2)::double precision
  END AS score,
  rs.submitted_date AS "submittedDate"
FROM ranked_submissions AS rs
LEFT JOIN lookups."Country" AS comp_code
  ON UPPER(comp_code."countryCode") = UPPER(rs.country_code)
LEFT JOIN lookups."Country" AS comp_id
  ON UPPER(comp_id.id) = UPPER(rs.country_code)
ORDER BY rs.challenge_id, rs.placement;
