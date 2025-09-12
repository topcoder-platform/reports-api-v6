WITH
proj AS (
  SELECT
    p.id                                            AS project_id,
    p.name                                          AS project_name,
    (p.details->'project_data'->>'group_customer_name') AS group_customer_name,
    (p.details->'project_data'->>'execution_hub')       AS execution_hub,
    (p.details->'project_data'->>'sector')              AS sector,
    (p.details->'project_data'->>'invoice_type')        AS invoice_type,
    (p.details->'project_data'->>'project_classification_code') AS project_classification_code,
    (p.details->'project_data'->>'initiator_email')     AS initiator_email,
    (p.details->'project_data'->>'wbs_code')            AS wbs_code,
    (p.details->'project_data'->>'sow_number')          AS sow_number,
    (p.details->'project_data'->>'smu')                 AS smu,
    (p.details->'project_data'->>'cost_center')         AS cost_center,
    (p.details->'project_data'->>'project_code')        AS project_code,
    CASE
      WHEN (p.details->'project_data'->>'planned_end_date') ~ '^\d+$'
      THEN to_timestamp((p.details->'project_data'->>'planned_end_date')::bigint)
      ELSE NULL
    END                                               AS planned_end_date
  FROM projects.projects p
),
bill AS (
  SELECT
    cb."challengeId" AS challenge_id,
    MAX(cb."billingAccountId") FILTER (WHERE cb."billingAccountId" IS NOT NULL) AS billing_account_id
  FROM challenges."ChallengeBilling" cb
  GROUP BY cb."challengeId"
),
meta AS (
  SELECT
    m."challengeId" AS challenge_id,
    MAX(m.value) FILTER (WHERE m.name = 'onsite_efforts')  AS onsite_efforts,
    MAX(m.value) FILTER (WHERE m.name = 'offsite_efforts') AS offsite_efforts
  FROM challenges."ChallengeMetadata" m
  GROUP BY m."challengeId"
),
prizes AS (
  SELECT
    cps."challengeId" AS challenge_id,
    COALESCE(SUM(pr.value),0)::numeric(12,2) AS prize
  FROM challenges."ChallengePrizeSet" cps
  JOIN challenges."Prize" pr
    ON pr."prizeSetId" = cps.id
  GROUP BY cps."challengeId"
),
tag_list AS (
  SELECT
    c.id AS challenge_id,
    STRING_AGG(t.tag, ', ' ORDER BY t.tag) AS tags
  FROM challenges."Challenge" c
  LEFT JOIN LATERAL (
    SELECT UNNEST(c.tags) AS tag
  ) t ON TRUE
  GROUP BY c.id
),
group_list AS (
  SELECT
    c.id AS challenge_id,
    STRING_AGG(DISTINCT g.name, ', ' ORDER BY g.name) AS groups
  FROM challenges."Challenge" c
  LEFT JOIN LATERAL UNNEST(c.groups) AS gid(group_id) ON TRUE
  LEFT JOIN groups."Group" g
    ON g.id = gid.group_id
  GROUP BY c.id
),
submissions AS (
  SELECT
    s."challengeId" AS challenge_id,
    COUNT(*)::int    AS num_submissions,
    MAX(s."submittedDate") AS latest_submission_date,
    MAX(s."memberId") FILTER (WHERE s.placement = 1) AS winner1_member_id
  FROM reviews.submission s
  GROUP BY s."challengeId"
),
registrants AS (
  SELECT
    r."challengeId" AS challenge_id,
    COUNT(DISTINCT r."memberId")::int AS num_registrations
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId"
  WHERE COALESCE(rr."nameLower", LOWER(rr.name)) = 'submitter'
  GROUP BY r."challengeId"
),
reviewer_roles AS (
  SELECT id FROM resources."ResourceRole"
  WHERE COALESCE("nameLower", LOWER(name)) LIKE '%review%'
),
reviewers AS (
  SELECT
    r."challengeId"                 AS challenge_id,
    COUNT(DISTINCT r."memberId")    AS num_reviews,
    STRING_AGG(DISTINCT m.email, ', ' ORDER BY m.email) AS reviewer_email,
	r."memberId"				    AS reviewer_member_id
  FROM resources."Resource" r
  JOIN reviewer_roles rr ON rr.id = r."roleId"
  LEFT JOIN members.member m
    ON m."userId"::text = r."memberId"::text
  GROUP BY r."challengeId", r."memberId"
),
reviewer_payments AS (
   SELECT
    c.id AS challenge_id,
    COALESCE(SUM(p.total_amount),0)::numeric(12,2) AS reviewer_payment,
    STRING_AGG(
      DISTINCT COALESCE(p.payment_status::text, 'UNKNOWN'),
      ', ' ORDER BY COALESCE(p.payment_status::text, 'UNKNOWN')
    ) AS reviewer_payment_status
  FROM challenges."Challenge" c
  LEFT JOIN reviewers r
  	ON r.challenge_id = c.id
  LEFT JOIN finance.winnings w
    ON w.external_id = c.id AND
	w.winner_id = r.reviewer_member_id
  LEFT JOIN finance.payment p
    ON p.winnings_id = w.winning_id
  WHERE c."createdAt" > '2025-01-01T00:00:00Z'
    AND c.status IN ('ACTIVE', 'COMPLETED')

  GROUP BY c.id
),
registrant_emails AS (
  SELECT
    r."challengeId" AS challenge_id,
    STRING_AGG(DISTINCT m.email, ', ' ORDER BY m.email) AS registrant_email_ids
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId"
  LEFT JOIN members.member m
    ON m."userId"::text = r."memberId"::text
  WHERE COALESCE(rr."nameLower", LOWER(rr.name)) = 'submitter'
  GROUP BY r."challengeId"
),
submitter_emails AS (
  SELECT
    s."challengeId" AS challenge_id,
    STRING_AGG(DISTINCT m.email, ', ' ORDER BY m.email) AS submitter_email_ids
  FROM reviews.submission s
  LEFT JOIN members.member m
    ON m."userId"::text = s."memberId"::text
  GROUP BY s."challengeId"
),
winner1 AS (
  SELECT
    c.id AS challenge_id,
    m.email AS winner_1_email,
    COALESCE(SUM(p.total_amount),0)::numeric(12,2) AS winner_1_prize_amount,
    STRING_AGG(
      DISTINCT COALESCE(p.payment_status::text,'UNKNOWN'),
      ', ' ORDER BY COALESCE(p.payment_status::text,'UNKNOWN')
    ) AS winner_1_payment_status
  FROM challenges."Challenge" c
  LEFT JOIN submissions s
    ON s.challenge_id = c.id
  LEFT JOIN members.member m
    ON m."userId"::text = s.winner1_member_id::text
  LEFT JOIN finance.winnings w
    ON w.external_id = c.id
       AND w.winner_id = s.winner1_member_id::text
  LEFT JOIN finance.payment p
    ON p.winnings_id = w.winning_id
  WHERE c."createdAt" > '2025-01-01T00:00:00Z'
    AND c.status IN ('ACTIVE', 'COMPLETED')

  GROUP BY c.id, m.email
),
completed_payments AS (
  SELECT
    c.id AS challenge_id,
    MAX(p.updated_at) AS payment_modify_date
  FROM challenges."Challenge" c
  LEFT JOIN finance.winnings w
    ON w.external_id = c.id
  LEFT JOIN finance.payment p
    ON p.winnings_id = w.winning_id
  WHERE c.status = 'COMPLETED' and
  c."createdAt" > '2025-01-01T00:00:00Z'
  GROUP BY c.id
)

SELECT
  c."updatedAt"                                   AS modify_date,
  b.billing_account_id                            AS billing_account_id,
  prj.project_name                                AS project_name,
  prj.project_id                                  AS project_id,
  c.id                                            AS challenge_id,
  c.name                                          AS challenge_name,
  c.status                                        AS challenge_status,
  ct.name                                         AS challenge_type,
  c."registrationEndDate"                         AS registration_end_date,
  c."submissionEndDate"                           AS submission_end_date,
  c."endDate"                                     AS completed_date,
  m.onsite_efforts                                AS onsite_efforts,
  m.offsite_efforts                               AS offsite_efforts,
  COALESCE(rv.num_reviews, 0)                     AS num_reviews,

  prj.group_customer_name,
  prj.execution_hub,
  prj.sector,
  prj.invoice_type,
  prj.project_classification_code,
  prj.initiator_email,
  prj.wbs_code,
  prj.sow_number,
  prj.smu,
  prj.cost_center,
  prj.project_code,

  prj.planned_end_date                            AS planned_end_date,

  c.id                                            AS id,
  c."legacyId"                                    AS legacy_id,

  c."numOfSubmissions"			                  AS num_submissions,
  c."numOfRegistrants"				              AS num_registrations,

  ''::text                                        AS sub_practice,
  ''::text                                        AS practice,

  m.onsite_efforts                                AS v5_onsite_efforts,
  m.offsite_efforts                               AS v5_offsite_efforts,

  pz.prize                                        AS prize,

  tl.tags                                         AS tags,
  gl.groups                                       AS groups,

  c."createdBy"                                   AS creator,
  c."createdAt"                                   AS creation_date,
  CASE
    WHEN c.status = 'COMPLETED' AND c."endDate" IS NOT NULL
      THEN to_char(c."endDate", 'Mon-YY')
    ELSE NULL
  END                                             AS completed_month,
  CASE
    WHEN c.status = 'COMPLETED' AND c."endDate" IS NOT NULL
      THEN to_char(c."endDate", 'DD-Mon-YYYY HH24:MI:SS')
    ELSE NULL
  END                                             AS completed_date_formatted,
  c."registrationStartDate"                       AS registration_start_date,

  cp.payment_modify_date                          AS payment_modify_date,

  rv.reviewer_email                               AS reviewer_email,
  rvp.reviewer_payment                            AS reviewer_payment,
  rvp.reviewer_payment_status                     AS reviewer_payment_status,

  w1.winner_1_email,
  w1.winner_1_prize_amount,
  w1.winner_1_payment_status,

  re.registrant_email_ids,
  se.submitter_email_ids,

  to_char(c."createdAt", 'DD-Mon-YYYY HH24:MI:SS') AS creation_date_formatted,
  CASE WHEN s.latest_submission_date IS NOT NULL
       THEN to_char(s.latest_submission_date, 'DD-Mon-YYYY HH24:MI:SS')
       ELSE NULL END                               AS submission_date_formatted

FROM challenges."Challenge" c
LEFT JOIN challenges."ChallengeType" ct
  ON ct.id = c."typeId"
LEFT JOIN proj prj
  ON prj.project_id = c."projectId"
LEFT JOIN bill b
  ON b.challenge_id = c.id
LEFT JOIN meta m
  ON m.challenge_id = c.id
LEFT JOIN prizes pz
  ON pz.challenge_id = c.id
LEFT JOIN tag_list tl
  ON tl.challenge_id = c.id
LEFT JOIN group_list gl
  ON gl.challenge_id = c.id
LEFT JOIN submissions s
  ON s.challenge_id = c.id
LEFT JOIN registrants rg
  ON rg.challenge_id = c.id
LEFT JOIN reviewers rv
  ON rv.challenge_id = c.id
LEFT JOIN reviewer_payments rvp
  ON rvp.challenge_id = c.id
LEFT JOIN registrant_emails re
  ON re.challenge_id = c.id
LEFT JOIN submitter_emails se
  ON se.challenge_id = c.id
LEFT JOIN winner1 w1
  ON w1.challenge_id = c.id
LEFT JOIN completed_payments cp
  ON cp.challenge_id = c.id
WHERE billing_account_id = '80000062'
ORDER BY c."createdAt" DESC
;
