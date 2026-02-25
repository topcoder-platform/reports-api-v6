SELECT
  c.id as "challengeId",
  c.status as "challengeStatus",
  cw.handle as "winnerHandle",
  CASE WHEN sub.placement = 1 THEN true ELSE false END as "isWinner",
  CASE
    WHEN c.status = 'COMPLETED' THEN latest_phase."actualEndDate"
    ELSE null
  END as "challengeCompletedDate",
  res."memberHandle" as "registrantHandle",
  ROUND(sub."finalScore", 2) as "registrantFinalScore"
FROM
  challenges."Challenge" c
LEFT JOIN LATERAL (
  SELECT cp."actualEndDate"
  FROM challenges."ChallengePhase" cp
  WHERE cp."challengeId" = c.id
  ORDER BY cp."scheduledEndDate" DESC
  LIMIT 1
) latest_phase ON true
LEFT JOIN
  resources."Resource" res ON c.id = res."challengeId"
LEFT JOIN
  resources."ResourceRole" rr on res."roleId" = rr.id
LEFT JOIN
  challenges."ChallengeWinner" cw ON c.id = cw."challengeId" AND cw."userId"::text=res."memberId"
LEFT JOIN
  reviews."submission" sub on sub."memberId"=res."memberId" AND sub."challengeId"=c.id
LEFT JOIN
  challenges."ChallengeBilling" cb on cb."challengeId"=c.id
WHERE rr.name = 'Submitter'
  -- filter by billing account
  AND ($1::text[] IS NULL OR cb."billingAccountId" = ANY($1::text[]))
  -- filter by excluding billing account
  AND ($2::text[] IS NULL OR cb."billingAccountId" <> ANY($2::text[]))
  -- filter by challenge status
  AND ($3::text[] IS NULL OR c.status::text= ANY($3::text[]))
  -- filter by completion date bounds on the latest challenge phase end date
  AND (
    ($4::timestamptz IS NULL AND $5::timestamptz IS NULL)
    OR (
      latest_phase."actualEndDate" IS NOT NULL
      AND ($4::timestamptz IS NULL OR latest_phase."actualEndDate" >= $4::timestamptz)
      AND ($5::timestamptz IS NULL OR latest_phase."actualEndDate" <= $5::timestamptz)
    )
  )
LIMIT 1000;
