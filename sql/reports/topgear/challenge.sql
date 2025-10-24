WITH base AS (
  SELECT
    c.id                               AS challenge_id,
    c.name                             AS challenge_name,
    c.status                           AS challenge_status,
    c."typeId"                         AS challenge_type_id,
    c."projectId"                      AS project_id,
    c."createdAt"                      AS challenge_created_at,
    c."updatedAt"                      AS challenge_updated_at,
    c."endDate"                        AS planned_end_at,
    c."createdBy"                      AS created_by_member_id,  -- text in some schemas
    c.tags                             AS tags_array,
    c."numOfRegistrants"               AS num_of_registrants,
    c."numOfSubmissions"               AS num_of_submissions
  FROM challenges."Challenge" c
),
last_phase AS (
  SELECT cp."challengeId" AS challenge_id,
         MAX(COALESCE(cp."actualEndDate", cp."scheduledEndDate")) AS last_phase_end
  FROM challenges."ChallengePhase" cp
  GROUP BY cp."challengeId"
),
reg_end AS (
  SELECT cp."challengeId" AS challenge_id,
         MAX(COALESCE(cp."actualEndDate", cp."scheduledEndDate")) AS registration_end
  FROM challenges."ChallengePhase" cp
  JOIN challenges."Phase" p ON p.id = cp."phaseId"
  WHERE p.name ILIKE 'Registration%'
  GROUP BY cp."challengeId"
),
sub_end AS (
  SELECT cp."challengeId" AS challenge_id,
         MAX(COALESCE(cp."actualEndDate", cp."scheduledEndDate")) AS submission_end
  FROM challenges."ChallengePhase" cp
  JOIN challenges."Phase" p ON p.id = cp."phaseId"
  WHERE p.name ILIKE 'Submission%'
  GROUP BY cp."challengeId"
),
prize_sum AS (
  SELECT cps."challengeId" AS challenge_id,
         SUM(pr.value)::numeric AS total_prize
  FROM challenges."ChallengePrizeSet" cps
  JOIN challenges."Prize" pr ON pr."prizeSetId" = cps.id
  GROUP BY cps."challengeId"
),
billing AS (
  SELECT cb."challengeId" AS challenge_id,
         cb."billingAccountId" AS billing_account_id
  FROM challenges."ChallengeBilling" cb
),
offshore AS (
  SELECT m."challengeId" AS challenge_id, m.value AS offshore_effort
  FROM challenges."ChallengeMetadata" m
  WHERE m.name = 'offshoreEfforts'
),
onshore AS (
  SELECT m."challengeId" AS challenge_id, m.value AS onshore_effort
  FROM challenges."ChallengeMetadata" m
  WHERE m.name = 'onsiteEfforts'
),
registrant_email_list AS (
  SELECT r."challengeId" AS challenge_id,
         STRING_AGG(DISTINCT mem.email, ',' ORDER BY mem.email) AS registrant_emails
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId" AND rr.name = 'Submitter'
  JOIN members.member mem
    ON mem."userId" = r."memberId"::bigint
  GROUP BY r."challengeId"
),
submitter_email_list AS (
  SELECT s."challengeId" AS challenge_id,
         STRING_AGG(DISTINCT mem.email, ',' ORDER BY mem.email) AS submitter_emails
  FROM reviews.submission s
  JOIN members.member mem
    ON mem."userId" = s."memberId"::bigint
  GROUP BY s."challengeId"
),
proj AS (
  SELECT
    p.id AS project_id,
    (p.details::jsonb -> 'project_data' ->> 'cost_center')                 AS cost_center,
    (p.details::jsonb -> 'project_data' ->> 'execution_hub')               AS execution_hub,
    (p.details::jsonb -> 'project_data' ->> 'group_customer_name')         AS group_customer_name,
    (p.details::jsonb -> 'project_data' ->> 'initiator_email')             AS initiator_email,
    (p.details::jsonb -> 'project_data' ->> 'invoice_type')                AS invoice_type,
    (p.details::jsonb -> 'project_data' ->> 'practice')                    AS practice,
    (p.details::jsonb -> 'project_data' ->> 'sub_practice')                AS sub_practice,
    (p.details::jsonb -> 'project_data' ->> 'project_classification_code') AS project_classification_code,
    (p.details::jsonb -> 'project_data' ->> 'project_code')                AS project_code,
    (p.details::jsonb -> 'project_data' ->> 'sector')                      AS sector,
    (p.details::jsonb -> 'project_data' ->> 'sow_number')                  AS sow_number,
    (p.details::jsonb -> 'project_data' ->> 'wbs_code')                    AS wbs_code,
    p.name                                                                  AS project_name,
    p."billingAccountId"                                                    AS project_billing_account_id
  FROM projects.projects p
),
creator AS (
  SELECT m."userId" AS member_id, m.handle AS creator_handle
  FROM members.member m
)
SELECT
  COALESCE(b.billing_account_id, proj.project_billing_account_id)         AS "Billing Account ID",
  base.challenge_id                                                       AS "Challenge ID",
  base.challenge_name                                                     AS "Challenge Name",
  base.challenge_status                                                   AS "Challenge Status",
  ct.name                                                                 AS "Challenge Type",
  CASE WHEN base.challenge_status = 'COMPLETED'
       THEN TO_CHAR(lp.last_phase_end, 'YYYY-MM-DD') END                  AS "Completion Date",
  CASE WHEN base.challenge_status = 'COMPLETED'
       THEN TO_CHAR(lp.last_phase_end, 'Mon-YY') END                      AS "Completed on Month",
  proj.cost_center                                                        AS "Cost Center",
  TO_CHAR(base.challenge_created_at, 'YYYY-MM-DD')                        AS "Challenge Creation Date",
  TO_CHAR(base.challenge_created_at, 'YYYY-MM')                           AS "Challenge Creation Month",
  TO_CHAR(base.challenge_created_at, 'YYYY')                              AS "Challenge Creation Year",
  cr.creator_handle                                                       AS "Challenge Creator",
  proj.execution_hub                                                      AS "Execution Hub",
  proj.group_customer_name                                                AS "Group Customer Name",
  proj.initiator_email                                                    AS "Initiator Email",
  proj.invoice_type                                                       AS "Invoice Type",
  COALESCE(base.num_of_registrants, 0)                                    AS "Number of Registrants",
  COALESCE(base.num_of_submissions, 0)                                    AS "Number of Submissions",
  off.offshore_effort                                                     AS "Offshore Effort",
  onsh.onshore_effort                                                     AS "Onshore Effort",
  TO_CHAR(base.planned_end_at, 'YYYY-MM-DD')                              AS "Planned End Date",
  TO_CHAR(base.planned_end_at, 'YYYY-MM')                                 AS "Planned End Month",
  TO_CHAR(base.planned_end_at, 'YYYY')                                    AS "Planned End Year",
  proj.practice                                                           AS "Practice",
  COALESCE(ps.total_prize, 0)                                             AS "Prize",
  proj.project_classification_code                                        AS "Project Classification Code",
  proj.project_code                                                       AS "Project Code",
  base.project_id                                                         AS "Project ID",
  proj.project_name                                                       AS "Project Name",
  TO_CHAR(re.registration_end, 'YYYY-MM-DD')                              AS "Registration End Date",
  TO_CHAR(re.registration_end, 'YYYY-MM')                                 AS "Registration End Month",
  TO_CHAR(re.registration_end, 'YYYY')                                    AS "Registration End Year",
  proj.sector                                                             AS "Sector",
  proj.sow_number                                                         AS "SOW Number",
  proj.sub_practice                                                       AS "Sub Practice",
  TO_CHAR(se.submission_end, 'YYYY-MM-DD')                                AS "Submission End Date",
  TO_CHAR(se.submission_end, 'YYYY-MM')                                   AS "Submission End Month",
  TO_CHAR(se.submission_end, 'YYYY')                                      AS "Submission End Year",
  CASE WHEN base.tags_array IS NULL THEN NULL ELSE array_to_string(base.tags_array, ',') END
                                                                          AS "Tags",
  proj.wbs_code                                                           AS "WBS Code",
  TO_CHAR(base.challenge_updated_at, 'YYYY-MM-DD')                        AS "Modify date",
  reg_emails.registrant_emails                                            AS "Registrant emails",
  sub_emails.submitter_emails                                             AS "Submitter emails"
FROM base
LEFT JOIN challenges."ChallengeType" ct ON ct.id = base.challenge_type_id
LEFT JOIN last_phase lp                ON lp.challenge_id = base.challenge_id
LEFT JOIN reg_end re                   ON re.challenge_id = base.challenge_id
LEFT JOIN sub_end se                   ON se.challenge_id = base.challenge_id
LEFT JOIN prize_sum ps                 ON ps.challenge_id = base.challenge_id
LEFT JOIN billing b                    ON b.challenge_id = base.challenge_id
LEFT JOIN offshore off                 ON off.challenge_id = base.challenge_id
LEFT JOIN onshore onsh                 ON onsh.challenge_id = base.challenge_id
LEFT JOIN registrant_email_list reg_emails ON reg_emails.challenge_id = base.challenge_id
LEFT JOIN submitter_email_list sub_emails  ON sub_emails.challenge_id  = base.challenge_id
LEFT JOIN proj                         ON proj.project_id = base.project_id
LEFT JOIN creator cr                   ON cr.creator_handle = base.created_by_member_id
WHERE COALESCE(
        CASE WHEN base.challenge_status = 'COMPLETED' THEN lp.last_phase_end END,
        base.planned_end_at,
        base.challenge_created_at
      ) BETWEEN $1::timestamptz AND $2::timestamptz AND
      COALESCE(b.billing_account_id, proj.project_billing_account_id) = '80000062'
ORDER BY base.challenge_created_at DESC, base.challenge_id;
