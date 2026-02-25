WITH submitter_role AS (
  SELECT rr.id
  FROM resources."ResourceRole" rr
  WHERE rr."nameLower" = 'submitter'
  LIMIT 1
),
filtered_challenges AS (
  SELECT
    c.id,
    c.status,
    latest_phase."actualEndDate" as "challengeCompletedDate"
  FROM
    challenges."Challenge" c
  JOIN challenges."ChallengeType" ct
    ON ct.id = c."typeId"
  LEFT JOIN LATERAL (
    SELECT cp."actualEndDate"
    FROM challenges."ChallengePhase" cp
    WHERE cp."challengeId" = c.id
    ORDER BY cp."scheduledEndDate" DESC
    LIMIT 1
  ) latest_phase ON true
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
    AND LOWER(ct.name) NOT IN ('task', 'topgear task')
    -- filter by completion date bounds on the latest challenge phase end date
    AND (
      ($4::timestamptz IS NULL AND $5::timestamptz IS NULL)
      OR (
        latest_phase."actualEndDate" IS NOT NULL
        AND ($4::timestamptz IS NULL OR latest_phase."actualEndDate" >= $4::timestamptz)
        AND ($5::timestamptz IS NULL OR latest_phase."actualEndDate" <= $5::timestamptz)
      )
    )
),
registrants AS (
  -- keep one submitter resource row per challenge/member
  SELECT DISTINCT ON (fc.id, res."memberId")
    fc.id as "challengeId",
    fc.status as "challengeStatus",
    fc."challengeCompletedDate",
    res."memberId",
    res."memberHandle" as "registrantHandle"
  FROM filtered_challenges fc
  JOIN submitter_role sr ON true
  JOIN resources."Resource" res
    ON res."challengeId" = fc.id
    AND res."roleId" = sr.id
  ORDER BY
    fc.id,
    res."memberId",
    res."updatedAt" DESC NULLS LAST,
    res."createdAt" DESC,
    res.id DESC
  LIMIT 1000
),
winners AS (
  -- keep one winner row per challenge/member
  SELECT
    cw."challengeId",
    cw."userId"::text as "memberId",
    MAX(cw.handle) as "winnerHandle"
  FROM challenges."ChallengeWinner" cw
  WHERE cw.placement = 1
  GROUP BY cw."challengeId", cw."userId"
),
submissions AS (
  -- keep one submission row per challenge/member
  SELECT
    sub."challengeId",
    sub."memberId",
    MAX(sub."finalScore") as "finalScore",
    BOOL_OR(sub.placement = 1) as "isWinner"
  FROM reviews."submission" sub
  GROUP BY sub."challengeId", sub."memberId"
)
SELECT
  registrants."challengeId",
  registrants."challengeStatus",
  win."winnerHandle",
  COALESCE(sub."isWinner", false) as "isWinner",
  CASE
    WHEN registrants."challengeStatus" = 'COMPLETED'
      THEN registrants."challengeCompletedDate"
    ELSE null
  END as "challengeCompletedDate",
  registrants."registrantHandle",
  ROUND(sub."finalScore", 2) as "registrantFinalScore"
FROM registrants
LEFT JOIN winners win
  ON win."challengeId" = registrants."challengeId"
  AND win."memberId" = registrants."memberId"
LEFT JOIN submissions sub
  ON sub."challengeId" = registrants."challengeId"
  AND sub."memberId" = registrants."memberId"
LIMIT 1000;
