SELECT
  c.id as "challengeId",
  c.status as "challengeStatus",
  CASE WHEN c.status = 'COMPLETED' THEN
    (SELECT cp."actualEndDate" FROM challenges."ChallengePhase" cp WHERE cp."challengeId"=c.id ORDER BY cp."scheduledEndDate" DESC LIMIT 1)
    ELSE null END as "challengeCompletedDate",
  res."memberHandle" as "registrantHandle",
  ROUND(sub."finalScore", 2) as "registrantFinalScore",
  CASE WHEN sub."finalScore" > 98 THEN true ELSE false END AS "didSubmissionPass",
  sub.url as "submissionUrl",
  sub.id as "submissionId"
  sub."createdAt" as "submissionCreatedDate"
FROM
  challenges."Challenge" c
LEFT JOIN
  resources."Resource" res ON c.id = res."challengeId"
LEFT JOIN
  resources."ResourceRole" rr on res."roleId" = rr.id
LEFT JOIN
  reviews."submission" sub on sub."memberId"=res."memberId" AND sub."challengeId"=c.id
WHERE rr.name = 'Submitter'
  -- filter by challenge status
  AND ($1::text[] IS NULL OR c.status::text= ANY($3::text[]))
  -- -- filter by completion date
  -- filter by challengeCompletedDate
  AND (c.status!='COMPLETED' OR (
    ($2::timestamptz IS NULL AND $3::timestamptz IS NULL)
    OR (
      $3::timestamptz IS NULL AND (
        (
          SELECT cp."actualEndDate"
          FROM challenges."ChallengePhase" cp
          WHERE cp."challengeId" = c.id
          ORDER BY cp."scheduledEndDate" DESC
          LIMIT 1
        ) >= $2::timestamptz
      )
    )
    OR (
      $2::timestamptz IS NULL AND $3::timestamptz IS NOT NULL AND (
        (
          SELECT cp."actualEndDate"
          FROM challenges."ChallengePhase" cp
          WHERE cp."challengeId" = c.id
          ORDER BY cp."scheduledEndDate" DESC
          LIMIT 1
        ) >= $3::timestamptz
      )
    )
    OR (
      $2::timestamptz IS NOT NULL AND $3::timestamptz IS NOT NULL AND ((
        SELECT cp."actualEndDate"
        FROM challenges."ChallengePhase" cp
        WHERE cp."challengeId" = c.id
        ORDER BY cp."scheduledEndDate" DESC
        LIMIT 1
      ) BETWEEN $2::timestamptz AND $3::timestamptz)
    )
  ))
LIMIT 100;
