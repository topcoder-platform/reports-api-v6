SELECT
  c.id as "challengeId",
  c.name as "challengeName",
  c.groups as "groupNames",
  c.status as "challengeStatus",
  c."registrationStartDate" as "registrationStartDate",
  CASE WHEN c.status = 'COMPLETED' THEN
    (SELECT cp."actualEndDate" FROM challenges."ChallengePhase" cp WHERE cp."challengeId"=c.id ORDER BY cp."scheduledEndDate" DESC LIMIT 1)
    ELSE null END as "challengeCompletionDate",
  c.tags as "tags",
  c."projectId" as "projectId"
FROM
  challenges."Challenge" c
LEFT JOIN
  challenges."ChallengeBilling" cb on cb."challengeId"=c.id
-- filter by billing account
WHERE ($1::text[] IS NULL OR cb."billingAccountId" = ANY($1::text[]))
  -- filter by excluding billing account
  AND ($2::text[] IS NULL OR cb."billingAccountId" <> ANY($2::text[]))
  -- filter by challenge status
  AND ($3::text[] IS NULL OR c.status::text= ANY($3::text[]))
  -- -- filter by completion date
  -- filter by challengeCompletedDate
  AND (c.status!='COMPLETED' OR (
    ($4::timestamptz IS NULL AND $5::timestamptz IS NULL)
    OR (
      $5::timestamptz IS NULL AND (
        (
          SELECT cp."actualEndDate"
          FROM challenges."ChallengePhase" cp
          WHERE cp."challengeId" = c.id
          ORDER BY cp."scheduledEndDate" DESC
          LIMIT 1
        ) >= $4::timestamptz
      )
    )
    OR (
      $4::timestamptz IS NULL AND $5::timestamptz IS NOT NULL AND (
        (
          SELECT cp."actualEndDate"
          FROM challenges."ChallengePhase" cp
          WHERE cp."challengeId" = c.id
          ORDER BY cp."scheduledEndDate" DESC
          LIMIT 1
        ) >= $5::timestamptz
      )
    )
    OR (
      $4::timestamptz IS NOT NULL AND $5::timestamptz IS NOT NULL AND ((
        SELECT cp."actualEndDate"
        FROM challenges."ChallengePhase" cp
        WHERE cp."challengeId" = c.id
        ORDER BY cp."scheduledEndDate" DESC
        LIMIT 1
      ) BETWEEN $4::timestamptz AND $5::timestamptz)
    )
  ))
LIMIT 1000;
