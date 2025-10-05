-- INPUTS:
--   $1 :: timestamptz  -- start of window
--   $2 :: timestamptz  -- end of window
WITH base AS (
  SELECT
    c.id              AS challenge_id,
    c.name            AS challenge_name,
    c.status          AS challenge_status,
    c."typeId"        AS challenge_type_id,
    c."projectId"     AS project_id,
    c."createdAt"     AS challenge_created_at,
    c."updatedAt"     AS challenge_updated_at,
    c."endDate"       AS planned_end_at
  FROM challenges."Challenge" c
  WHERE c.status IN ('ACTIVE','COMPLETED')
),
last_phase AS (
  SELECT
    cp."challengeId" AS challenge_id,
    MAX(COALESCE(cp."actualEndDate", cp."scheduledEndDate")) AS last_phase_end
  FROM challenges."ChallengePhase" cp
  GROUP BY cp."challengeId"
),
reg_end AS (
  SELECT
    cp."challengeId" AS challenge_id,
    MAX(COALESCE(cp."actualEndDate", cp."scheduledEndDate")) AS registration_end
  FROM challenges."ChallengePhase" cp
  JOIN challenges."Phase" p ON p.id = cp."phaseId"
  WHERE p.name ILIKE 'Registration%'
  GROUP BY cp."challengeId"
),
submissions AS (
  SELECT
    s."challengeId"                 AS challenge_id,
    s."memberId"::bigint            AS member_id,
    MAX(s."finalScore") AS best_final_score
  FROM reviews.submission s
  GROUP BY s."challengeId", s."memberId"
),
winners AS (
  SELECT
    cw."challengeId" AS challenge_id,
    m.handle         AS winner_handle
  FROM challenges."ChallengeWinner" cw
  JOIN members.member m ON m."userId" = cw."userId"::bigint
  WHERE cw.placement = 1
),
billing AS (
  SELECT cb."challengeId" AS challenge_id,
         cb."billingAccountId"::bigint AS billing_account_id
  FROM challenges."ChallengeBilling" cb
),
proj AS (
  SELECT
    p.id AS project_id,
    (p.details::jsonb -> 'project_data' ->> 'group_customer_name') AS group_customer_name,
    p."billingAccountId"::bigint                                   AS project_billing_account_id
  FROM projects.projects p
),
proj_phase_end AS (
  SELECT
    pp."projectId"::bigint                 AS project_id,              -- cast to text to match base.project_id
    MAX(pp."endDate")           AS project_scheduled_end_date
  FROM projects."project_phases" pp
  WHERE pp.status ILIKE 'planned'
  GROUP BY pp."projectId"
),
registrants AS (
  SELECT
    r."challengeId"               AS challenge_id,
    r."memberId"::bigint          AS member_id,
    COALESCE(r."memberHandle", m.handle) AS registrant_handle,
    m.email                       AS registrant_email
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId" AND rr.name = 'Submitter'
  LEFT JOIN members.member m
    ON m."userId" = r."memberId"::bigint
)
SELECT
  reg.registrant_handle                               AS "Registrant handle",
  base.challenge_id                                    AS "Challenge ID",
  (sub.best_final_score IS NOT NULL)                   AS "Did registrant submit",
  win.winner_handle                                    AS "Winner handle",
  CASE WHEN base.challenge_status = 'COMPLETED'
       THEN lp.last_phase_end END                      AS "Challenge completion date",
  base.challenge_status                                AS "Challenge status",
  base.project_id                                      AS "Project ID",
  proj.group_customer_name                             AS "Customer name",
  reg.registrant_email                                 AS "Registrant email",
  CASE WHEN base.challenge_status = 'ACTIVE'
       THEN ppe.project_scheduled_end_date END         AS "Project scheduled end date",
  sub.best_final_score                                 AS "Submission score"
FROM base
JOIN registrants reg
  ON reg.challenge_id = base.challenge_id
LEFT JOIN submissions sub
  ON sub.challenge_id = base.challenge_id
 AND sub.member_id   = reg.member_id
LEFT JOIN winners win
  ON win.challenge_id = base.challenge_id
LEFT JOIN last_phase lp
  ON lp.challenge_id = base.challenge_id
LEFT JOIN reg_end re
  ON re.challenge_id = base.challenge_id
LEFT JOIN billing b
  ON b.challenge_id = base.challenge_id
LEFT JOIN proj
  ON proj.project_id = base.project_id
LEFT JOIN proj_phase_end ppe
  ON ppe.project_id = base.project_id
WHERE
  COALESCE(b.billing_account_id, proj.project_billing_account_id) = 80000062
  AND COALESCE(
        CASE WHEN base.challenge_status = 'COMPLETED' THEN lp.last_phase_end END,
        base.planned_end_at,
        base.challenge_created_at
      ) BETWEEN $1::timestamptz AND $2::timestamptz
  AND (
    (base.challenge_status = 'COMPLETED'
      AND lp.last_phase_end ) BETWEEN $1::timestamptz AND $2::timestamptz
    )
    OR
    (base.challenge_status = 'ACTIVE' AND (
         base.challenge_created_at ) BETWEEN $1::timestamptz AND $2::timestamptz
      OR base.challenge_updated_at ) BETWEEN $1::timestamptz AND $2::timestamptz
      OR base.planned_end_at       ) BETWEEN $1::timestamptz AND $2::timestamptz
    ))
  )
ORDER BY base.challenge_id DESC, reg.registrant_handle;
