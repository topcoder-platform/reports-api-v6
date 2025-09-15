-- INPUTS:
--   $1 :: timestamp  -- start of createdAt range (inclusive)
--   $2 :: timestamp  -- end of createdAt range   (inclusive)
WITH
-- 1) base challenges filtered by created window + statuses
c AS (
  SELECT *
  FROM challenges."Challenge" ch
  WHERE ch."createdAt" >= $1::timestamptz
    AND ch."createdAt" <= $2::timestamptz
    AND ch.status IN (
      'CANCELLED',
      'CANCELLED_FAILED_REVIEW',
      'CANCELLED_FAILED_SCREENING',
      'CANCELLED_ZERO_SUBMISSIONS',
      'CANCELLED_WINNER_UNRESPONSIVE',
      'CANCELLED_CLIENT_REQUEST',
      'CANCELLED_REQUIREMENTS_INFEASIBLE',
      'CANCELLED_ZERO_REGISTRATIONS',
      'CANCELLED_PAYMENT_FAILED'
    )
),

-- 2) project joined to each challenge
cp AS (
  SELECT
    c.id                         AS challenge_id,
    p.id                         AS project_id,
    p.name                       AS direct_project_name,
    p."directProjectId"          AS tc_direct_project_id,
    p."billingAccountId"         AS project_billing_account_id,
    p.details                    AS project_details_json
  FROM c
  INNER JOIN projects.projects p
    ON p.id = c."projectId"
),

-- 3) prize totals (PLACEMENT prizes)
prize_totals AS (
  SELECT
    ps."challengeId" AS challenge_id,
    COALESCE(SUM(pr.value), 0)  AS total_prize
  FROM challenges."ChallengePrizeSet" ps
  JOIN challenges."Prize" pr
    ON pr."prizeSetId" = ps.id
  WHERE ps.type = 'PLACEMENT'
  GROUP BY ps."challengeId"
),

-- 4) phases + ordering to compute posting/review/complete
phases AS (
  SELECT
    cp.challenge_id,
    ph.name,
    COALESCE(ph."actualStartDate", ph."scheduledStartDate") AS start_dt,
    COALESCE(ph."actualEndDate",   ph."scheduledEndDate")   AS end_dt,
    ROW_NUMBER() OVER (PARTITION BY cp.challenge_id ORDER BY COALESCE(ph."actualStartDate", ph."scheduledStartDate")) AS rn,
    LEAD(ph.name) OVER (PARTITION BY cp.challenge_id ORDER BY COALESCE(ph."actualStartDate", ph."scheduledStartDate")) AS next_phase_name
  FROM cp
  LEFT JOIN challenges."ChallengePhase" ph
    ON ph."challengeId" = cp.challenge_id
),

-- 5) per-challenge important derived dates / names from phases
phase_rollup AS (
  SELECT
    p.challenge_id,
    -- Posting Date: start of the Submission phase
    MIN(CASE WHEN p.name ILIKE 'submission%' THEN p.start_dt END) AS submission_start_dt,
    -- Review Phase Name: the phase immediately after the first Submission phase
    MAX(CASE WHEN p.name ILIKE 'submission%' THEN p.next_phase_name END) AS review_phase_name,
    -- Complete Date: end date of the last phase
    MAX(p.end_dt) AS last_phase_end_dt
  FROM phases p
  GROUP BY p.challenge_id
),

-- 6) copilot list (by ResourceRole name = 'Copilot'), prefer member.handle when available
copilots AS (
  SELECT
    r."challengeId" AS challenge_id,
    STRING_AGG(DISTINCT COALESCE(m.handle, r."memberHandle"), ', ' ORDER BY COALESCE(m.handle, r."memberHandle")) AS copilot_handles
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId" AND rr.name = 'Copilot'
  LEFT JOIN members.member m
    ON m."userId" = CASE WHEN r."memberId" ~ '^\d+$' THEN r."memberId"::bigint ELSE NULL END
  GROUP BY r."challengeId"
),

-- 7) creator handle from members.member (createdBy is text; cast safely when numeric)
creator AS (
  SELECT
    c.id AS challenge_id,
    m.handle AS creator_handle
  FROM c
  LEFT JOIN members.member m
    ON m."userId" = CASE WHEN c."createdBy" ~ '^\d+$' THEN c."createdBy"::bigint ELSE NULL END
),

-- 8) challenge type name (and isTask)
ctype AS (
  SELECT
    c.id AS challenge_id,
    ct.name AS challenge_type_name,
    COALESCE(ct."isTask", false) AS is_task
  FROM c
  LEFT JOIN challenges."ChallengeType" ct
    ON ct.id = c."typeId"
),

-- 9) billing info attached directly to the challenge
cb AS (
  SELECT
    "challengeId" AS challenge_id,
    "billingAccountId" AS billing_account_id
  FROM challenges."ChallengeBilling"
),

-- 10) effort metadata (names: 'offshoreEfforts', 'onsiteEfforts')
efforts AS (
  SELECT
    cm."challengeId" AS challenge_id,
    MAX(CASE WHEN cm.name = 'offshoreEfforts' THEN cm.value END) AS effort_offshore_days,
    MAX(CASE WHEN cm.name = 'onsiteEfforts'   THEN cm.value END) AS effort_onshore_days
  FROM challenges."ChallengeMetadata" cm
  WHERE cm.name IN ('offshoreEfforts', 'onsiteEfforts')
  GROUP BY cm."challengeId"
),

-- 11) project details JSON pulled out (all the Wipro fields)
proj_details AS (
  SELECT
    cp.project_id,
	cp.challenge_id,
    -- JSON root is details; fields are under details.project_data
    (cp.project_details_json #>> '{project_data,invoice_type}')            AS invoice_type,
    (cp.project_details_json #>> '{project_data,du}')                      AS du,
    (cp.project_details_json #>> '{project_data,group_customer_name}')     AS group_customer_name,
    (cp.project_details_json #>> '{project_data,cost_center}')             AS cost_center,
    (cp.project_details_json #>> '{project_data,wbs_code}')                AS wbs_code,
    (cp.project_details_json #>> '{project_data,sow_number}')              AS sow_number,
    (cp.project_details_json #>> '{project_data,project_classification_code}') AS project_classification_code,
    (cp.project_details_json #>> '{project_data,project_code}')            AS project_code,
    (cp.project_details_json #>> '{project_data,execution_hub}')           AS execution_hub,
    (cp.project_details_json #>> '{project_data,sub_execution_hub}')       AS sub_execution_hub
  FROM cp
)

SELECT
  -- Project / challenge basics
  cp.project_id                                  AS "Project ID",
  c.name                                         AS "Challenge Name",
  /* Client Name: not available in this schema via a separate client table. If you add a client table,
     LEFT JOIN to it here using billing account or project linkage. For now, NULL. */
  NULL::text                                     AS "Client Name",
  -- Billing Account Name: not present in this schema (only IDs exist). Keep NULL; populate if you have a BA table.
  NULL::text                                     AS "Billing Account Name",
  cp.direct_project_name                         AS "Direct Project Name",
  cp.tc_direct_project_id                        AS "Tc Direct Project ID",
  c.id                                           AS "Component ID",
  c.name                                         AS "Challenge Name (duplicate for compatibility)",

  -- Posting Date: start of Submission phase (YYYY-MM-DD)
  TO_CHAR(pr."submission_start_dt", 'YYYY-MM-DD')        AS "Posting Date",

  -- Challenge Type
  ct.challenge_type_name                          AS "Challenge Type",

  -- Complete Date: end of last phase (YYYY-MM-DD)
  TO_CHAR(pr."last_phase_end_dt", 'YYYY-MM-DD')          AS "Complete Date",

  -- Is Task?
  ct.is_task                                      AS "Is Task?",

  -- Launcher
  NULL::text                                      AS "Launcher",

  -- Creator handle
  cr.creator_handle                               AS "Creator",

  -- Copilot(s)
  co.copilot_handles                              AS "Copilot",

  -- Projected End Date (from Challenge.endDate)
  TO_CHAR(c."endDate", 'YYYY-MM-DD')              AS "Projected End Date",

  -- Scheduled End Date (same as above per spec)
  TO_CHAR(c."endDate", 'YYYY-MM-DD')              AS "Scheduled End Date",

  -- Project details (from projects.projects.details JSON)
  pd.invoice_type                                 AS "Invoice Type",
  pd.du                                           AS "Du",
  pd.group_customer_name                          AS "Group Customer Name",
  pd.cost_center                                  AS "Cost Center",
  pd.wbs_code                                     AS "WBS Code",
  pd.sow_number                                   AS "SOW Number",
  pd.project_classification_code                  AS "Project Classification Code",
  pd.project_code                                 AS "Project Code",

  -- Technology List (null per spec)
  NULL::text                                      AS "Technology List",

  -- Posting Month: YYYY-MM
  TO_CHAR(pr."submission_start_dt", 'YYYY-MM')            AS "Posting Month",

  -- Complete Month: null per spec
  NULL::text                                      AS "Complete Month",

  -- Registration End Date (from Challenge)
  TO_CHAR(c."registrationEndDate", 'YYYY-MM-DD')  AS "Registration End Date",

  -- Submit By Date (Submission end from Challenge)
  TO_CHAR(c."submissionEndDate", 'YYYY-MM-DD')    AS "Submit By Date",

  -- Review Phase Name (phase immediately after Submission)
  pr."review_phase_name"                          AS "Review Phase Name",

  -- Status
  c.status                                        AS "Status",

  -- Execution Hub & Sub Execution Hub (from project details JSON)
  pd.execution_hub                                AS "Execution Hub",
  pd.sub_execution_hub                            AS "Sub Execution Hub",

  -- Total Prize (sum of PLACEMENT prizes)
  pt.total_prize                                  AS "Total Prize",

  -- Registrations / Submissions
  c."numOfRegistrants"                            AS "Num Registrations",
  c."numOfSubmissions"                            AS "Num Submissions",

  -- Effort days from ChallengeMetadata
  ef.effort_offshore_days                         AS "Effort Offshore Days",
  ef.effort_onshore_days                          AS "Effort Onshore Days"

FROM c
LEFT JOIN cp            ON cp.challenge_id = c.id
LEFT JOIN prize_totals pt ON pt.challenge_id = c.id
LEFT JOIN phase_rollup pr ON pr.challenge_id = c.id
LEFT JOIN copilots     co ON co.challenge_id = c.id
LEFT JOIN creator      cr ON cr.challenge_id = c.id
LEFT JOIN ctype        ct ON ct.challenge_id = c.id
LEFT JOIN cb           ON cb.challenge_id = c.id
LEFT JOIN proj_details pd ON pd.project_id = c."projectId"
LEFT JOIN efforts ef on ef.challenge_id = c.id

WHERE cb.billing_account_id='80000062'

ORDER BY cp.project_id, c."createdAt", c.id;
