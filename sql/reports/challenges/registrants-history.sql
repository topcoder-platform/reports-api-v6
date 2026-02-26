WITH submitter_role AS (
  SELECT rr.id
  FROM resources."ResourceRole" rr
  WHERE rr."nameLower" = 'submitter'
  LIMIT 1
),
filtered_challenges AS MATERIALIZED (
  SELECT
    c.id,
    c.status,
    ct.name AS "challengeType",
    lp."actualEndDate" AS "challengeCompletedDate"
  FROM challenges."Challenge" c
  JOIN challenges."ChallengeType" ct
    ON ct.id = c."typeId"
  LEFT JOIN LATERAL (
    SELECT cp."actualEndDate"
    FROM challenges."ChallengePhase" cp
    WHERE cp."challengeId" = c.id
    ORDER BY cp."scheduledEndDate" DESC
    LIMIT 1
  ) lp ON true
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
    -- include only challenge types supported by this report
    AND ct.name IN ('Challenge', 'Marathon Match', 'First2Finish')
    -- filter by completion date bounds on the latest challenge phase end date
    AND (
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
    fc."challengeType",
    fc."challengeCompletedDate",
    registrant."memberId",
    registrant."registrantHandle"
  FROM filtered_challenges fc
  JOIN submitter_role sr ON true
  JOIN LATERAL (
    SELECT
      res."memberId",
      MAX(res."memberHandle") AS "registrantHandle"
    FROM resources."Resource" res
    WHERE res."challengeId" = fc.id
      AND res."roleId" = sr.id
    GROUP BY res."memberId"
  ) registrant ON true
  LIMIT 1000
)
SELECT
  r."challengeId",
  r."challengeStatus",
  r."challengeType",
  win."winnerHandle",
  (
    COALESCE(win."isWinner", false)
    OR COALESCE(sub."isWinner", false)
    OR COALESCE(cr."isWinner", false)
  ) AS "isWinner",
  CASE
    WHEN r."challengeStatus" = 'COMPLETED'
      THEN r."challengeCompletedDate"
    ELSE null
  END AS "challengeCompletedDate",
  r."registrantHandle",
  COALESCE(sub."registrantFinalScore", cr."registrantFinalScore")
    AS "registrantFinalScore"
FROM registrants r
LEFT JOIN LATERAL (
  SELECT
    MAX(cw.handle) AS "winnerHandle",
    COUNT(*) > 0 AS "isWinner"
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
) sub ON true
LEFT JOIN LATERAL (
  SELECT
    BOOL_OR(cr.placement = 1) AS "isWinner",
    ROUND(MAX(cr."finalScore")::numeric, 2) AS "registrantFinalScore"
  FROM reviews."challengeResult" cr
  WHERE cr."challengeId" = r."challengeId"
    AND cr."userId" = r."memberId"
) cr ON true;
