WITH challenge_context AS (
  SELECT
    c.id,
    (LOWER(ct.name) = LOWER('Marathon Match')) AS is_marathon_match
  FROM challenges."Challenge" AS c
  JOIN challenges."ChallengeType" AS ct
    ON ct.id = c."typeId"
  WHERE c.id = $1::text
),
member_submissions AS (
  SELECT
    cc.id AS challenge_id,
    cc.is_marathon_match,
    s.id AS submission_id,
    s."memberId"::bigint AS user_id,
    s.placement,
    s."submittedDate"
  FROM challenge_context AS cc
  JOIN reviews.submission AS s
    ON s."challengeId" = cc.id
   AND s."memberId" IS NOT NULL
),
submitters AS (
  SELECT DISTINCT
    ms.user_id,
    ms.is_marathon_match
  FROM member_submissions AS ms
),
primary_submission AS (
  SELECT DISTINCT ON (ms.user_id)
    ms.user_id,
    ms.submission_id,
    ms.placement
  FROM member_submissions AS ms
  ORDER BY
    ms.user_id,
    ms.placement NULLS LAST,
    ms."submittedDate" DESC NULLS LAST,
    ms.submission_id DESC
),
winner_placements AS (
  SELECT
    cw."userId"::bigint AS user_id,
    MIN(cw.placement) AS placement
  FROM challenge_context AS cc
  JOIN challenges."ChallengeWinner" AS cw
    ON cw."challengeId" = cc.id
  WHERE cw.type = 'PLACEMENT'
  GROUP BY cw."userId"
),
marathon_scores AS (
  SELECT
    st.user_id,
    COALESCE(
      jsonb_agg(
        rs."aggregateScore"
        ORDER BY COALESCE(rs."reviewedDate", rs."createdAt"), rs.id
      ) FILTER (
        WHERE rs."isProvisional" IS TRUE
      ),
      '[]'::jsonb
    ) AS provisional_scores
  FROM submitters AS st
  LEFT JOIN member_submissions AS ms
    ON ms.user_id = st.user_id
  LEFT JOIN reviews."reviewSummation" AS rs
    ON rs."submissionId" = ms.submission_id
  GROUP BY st.user_id
),
marathon_final_score AS (
  SELECT
    st.user_id,
    COALESCE(wp.placement, ps.placement) AS placement,
    final_score."aggregateScore" AS final_score
  FROM submitters AS st
  LEFT JOIN winner_placements AS wp
    ON wp.user_id = st.user_id
  LEFT JOIN primary_submission AS ps
    ON ps.user_id = st.user_id
  LEFT JOIN LATERAL (
    SELECT rs."aggregateScore"
    FROM reviews."reviewSummation" AS rs
    WHERE rs."submissionId" = ps.submission_id
      AND rs."isFinal" IS TRUE
    ORDER BY COALESCE(rs."reviewedDate", rs."createdAt") DESC, rs.id DESC
    LIMIT 1
  ) AS final_score ON TRUE
),
submitter_profiles AS (
  SELECT
    st.user_id,
    COALESCE(
      NULLIF(TRIM(mem.handle), ''),
      NULLIF(TRIM(handle_fallback.member_handle), '')
    ) AS handle,
    mem.email,
    COALESCE(
      home_code.name,
      home_id.name,
      NULLIF(TRIM(mem."homeCountryCode"), ''),
      comp_code.name,
      comp_id.name,
      NULLIF(TRIM(mem."competitionCountryCode"), '')
    ) AS country,
    st.is_marathon_match,
    mfs.placement,
    ms.provisional_scores,
    mfs.final_score
  FROM submitters AS st
  LEFT JOIN members.member AS mem
    ON mem."userId" = st.user_id
  LEFT JOIN LATERAL (
    SELECT MAX(res."memberHandle") AS member_handle
    FROM resources."Resource" AS res
    WHERE res."challengeId" = $1::text
      AND res."memberId" = st.user_id::text
  ) AS handle_fallback ON TRUE
  LEFT JOIN lookups."Country" AS home_code
    ON UPPER(home_code."countryCode") = UPPER(mem."homeCountryCode")
  LEFT JOIN lookups."Country" AS home_id
    ON UPPER(home_id.id) = UPPER(mem."homeCountryCode")
  LEFT JOIN lookups."Country" AS comp_code
    ON UPPER(comp_code."countryCode") = UPPER(mem."competitionCountryCode")
  LEFT JOIN lookups."Country" AS comp_id
    ON UPPER(comp_id.id) = UPPER(mem."competitionCountryCode")
  LEFT JOIN marathon_scores AS ms
    ON ms.user_id = st.user_id
  LEFT JOIN marathon_final_score AS mfs
    ON mfs.user_id = st.user_id
)
SELECT
  sp.user_id AS "userId",
  sp.handle AS "handle",
  sp.email AS "email",
  sp.country AS "country",
  CASE
    WHEN sp.is_marathon_match THEN sp.placement
    ELSE NULL
  END AS "place",
  CASE
    WHEN sp.is_marathon_match THEN sp.provisional_scores
    ELSE NULL
  END AS "provisionalScores",
  CASE
    WHEN sp.is_marathon_match THEN sp.final_score
    ELSE NULL
  END AS "finalScore"
FROM submitter_profiles AS sp
ORDER BY
  CASE
    WHEN sp.is_marathon_match THEN sp.placement
    ELSE NULL
  END ASC NULLS LAST,
  sp.handle ASC NULLS LAST,
  sp.user_id ASC;
