WITH submitter_role AS (
  SELECT rr.id
  FROM resources."ResourceRole" rr
  WHERE rr."nameLower" = 'submitter'
  LIMIT 1
),
candidate_challenges AS MATERIALIZED (
  SELECT
    c.id,
    c.status
  FROM challenges."Challenge" c
  WHERE
    -- filter by billing account
    (
      $1::text[] IS NULL
      OR EXISTS (
        SELECT 1
        FROM challenges."ChallengeBilling" cb
        WHERE cb."challengeId" = c.id
          AND cb."billingAccountId" = ANY($1::text[])
      )
    )
    -- filter by excluding billing account
    AND (
      $2::text[] IS NULL
      OR NOT EXISTS (
        SELECT 1
        FROM challenges."ChallengeBilling" cb
        WHERE cb."challengeId" = c.id
          AND cb."billingAccountId" = ANY($2::text[])
      )
    )
    -- filter by challenge status
    AND ($3::text[] IS NULL OR c.status::text = ANY($3::text[]))
    -- exclude task challenge types from this report
    AND COALESCE(c."taskIsTask", false) = false
),
latest_phase AS MATERIALIZED (
  SELECT DISTINCT ON (cp."challengeId")
    cp."challengeId",
    cp."actualEndDate"
  FROM challenges."ChallengePhase" cp
  JOIN candidate_challenges cc
    ON cc.id = cp."challengeId"
  ORDER BY
    cp."challengeId",
    cp."scheduledEndDate" DESC
),
filtered_challenges AS MATERIALIZED (
  SELECT
    cc.id,
    cc.status,
    lp."actualEndDate" AS "challengeCompletedDate"
  FROM candidate_challenges cc
  LEFT JOIN latest_phase lp
    ON lp."challengeId" = cc.id
  WHERE
    -- filter by completion date bounds on the latest challenge phase end date
    (
      ($4::timestamptz IS NULL AND $5::timestamptz IS NULL)
      OR (
        lp."actualEndDate" IS NOT NULL
        AND ($4::timestamptz IS NULL OR lp."actualEndDate" >= $4::timestamptz)
        AND ($5::timestamptz IS NULL OR lp."actualEndDate" <= $5::timestamptz)
      )
    )
),
registrants AS MATERIALIZED (
  -- keep one submitter resource row per challenge/member
  SELECT
    fc.id AS "challengeId",
    fc.status AS "challengeStatus",
    fc."challengeCompletedDate",
    res."memberId",
    MAX(res."memberHandle") AS "registrantHandle"
  FROM filtered_challenges fc
  JOIN submitter_role sr ON true
  JOIN resources."Resource" res
    ON res."challengeId" = fc.id
    AND res."roleId" = sr.id
  GROUP BY
    fc.id,
    fc.status,
    fc."challengeCompletedDate",
    res."memberId"
  LIMIT 1000
)
SELECT
  r."challengeId",
  r."challengeStatus",
  win."winnerHandle",
  COALESCE(sub."isWinner", false) AS "isWinner",
  CASE
    WHEN r."challengeStatus" = 'COMPLETED'
      THEN r."challengeCompletedDate"
    ELSE null
  END AS "challengeCompletedDate",
  r."registrantHandle",
  sub."registrantFinalScore"
FROM registrants r
LEFT JOIN LATERAL (
  SELECT MAX(cw.handle) AS "winnerHandle"
  FROM challenges."ChallengeWinner" cw
  WHERE cw."challengeId" = r."challengeId"
    AND cw."userId"::text = r."memberId"
    AND cw.placement = 1
) win ON true
LEFT JOIN LATERAL (
  SELECT
    BOOL_OR(s.placement = 1) AS "isWinner",
    ROUND(MAX(s."finalScore"), 2) AS "registrantFinalScore"
  FROM reviews.submission s
  WHERE s."challengeId" = r."challengeId"
    AND s."memberId" = r."memberId"
) sub ON true;
