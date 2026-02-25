SELECT
  c.id as "challengeId",
  c.name as "challengeName",
  c.groups as "groupNames",
  c.status as "challengeStatus",
  c."registrationStartDate" as "registrationStartDate",
  CASE
    WHEN c.status = 'COMPLETED' THEN latest_phase."actualEndDate"
    ELSE null
  END as "challengeCompletionDate",
  c.tags as "tags",
  c."projectId" as "projectId"
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
  challenges."ChallengeBilling" cb on cb."challengeId"=c.id
-- filter by billing account
WHERE ($1::text[] IS NULL OR cb."billingAccountId" = ANY($1::text[]))
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
