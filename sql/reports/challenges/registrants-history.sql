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
    -- filter by completion date bounds on the latest challenge phase end date
    AND (
      ($4::timestamptz IS NULL AND $5::timestamptz IS NULL)
      OR (
        latest_phase."actualEndDate" IS NOT NULL
        AND ($4::timestamptz IS NULL OR latest_phase."actualEndDate" >= $4::timestamptz)
        AND ($5::timestamptz IS NULL OR latest_phase."actualEndDate" <= $5::timestamptz)
      )
    )
)
SELECT
  registrants."challengeId",
  registrants."challengeStatus",
  cw.handle as "winnerHandle",
  CASE WHEN sub.placement = 1 THEN true ELSE false END as "isWinner",
  CASE
    WHEN registrants."challengeStatus" = 'COMPLETED'
      THEN registrants."challengeCompletedDate"
    ELSE null
  END as "challengeCompletedDate",
  registrants."registrantHandle",
  ROUND(sub."finalScore", 2) as "registrantFinalScore"
FROM (
  SELECT
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
  LIMIT 1000
) registrants
LEFT JOIN challenges."ChallengeWinner" cw
  ON cw."challengeId" = registrants."challengeId"
  AND cw."userId"::text = registrants."memberId"
LEFT JOIN reviews."submission" sub
  ON sub."challengeId" = registrants."challengeId"
  AND sub."memberId" = registrants."memberId"
LIMIT 1000;
