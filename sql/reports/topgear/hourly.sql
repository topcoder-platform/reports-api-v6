WITH base_challenges AS (
  SELECT
    c.*,
    ba.billing_account_id
  FROM challenges."Challenge" c
  JOIN LATERAL (
    SELECT
      MAX(cb."billingAccountId") AS billing_account_id
    FROM challenges."ChallengeBilling" cb
    WHERE cb."challengeId" = c.id
      AND cb."billingAccountId" = '80000062'
  ) ba ON TRUE
  WHERE c."updatedAt" >= now() - interval '100 days'
    AND ba.billing_account_id IS NOT NULL
),
project_details AS (
  SELECT
    bc.id                                            AS challenge_id,
    p.id                                             AS project_id,
    p.name                                           AS project_name,
    (p.details->'project_data'->>'group_customer_name') AS group_customer_name,
    (p.details->'project_data'->>'execution_hub')    AS execution_hub,
    (p.details->'project_data'->>'sector')           AS sector,
    (p.details->'project_data'->>'invoice_type')     AS invoice_type,
    (p.details->'project_data'->>'project_classification_code') AS project_classification_code,
    (p.details->'project_data'->>'initiator_email')  AS initiator_email,
    (p.details->'project_data'->>'wbs_code')         AS wbs_code,
    (p.details->'project_data'->>'sow_number')       AS sow_number,
    (p.details->'project_data'->>'smu')              AS smu,
    (p.details->'project_data'->>'cost_center')      AS cost_center,
    (p.details->'project_data'->>'project_code')     AS project_code,
    CASE
      WHEN (p.details->'project_data'->>'planned_end_date') ~ '^\d+$'
        THEN to_timestamp((p.details->'project_data'->>'planned_end_date')::bigint)
      ELSE NULL
    END                                              AS planned_end_date
  FROM base_challenges bc
  LEFT JOIN projects.projects p
    ON p.id = bc."projectId"
),
meta AS (
  SELECT
    m."challengeId" AS challenge_id,
    MAX(m.value) FILTER (WHERE m.name = 'onsite_efforts')  AS onsite_efforts,
    MAX(m.value) FILTER (WHERE m.name = 'offsite_efforts') AS offsite_efforts
  FROM challenges."ChallengeMetadata" m
  JOIN base_challenges bc
    ON bc.id = m."challengeId"
  WHERE m.name IN ('onsite_efforts', 'offsite_efforts')
  GROUP BY m."challengeId"
),
prizes AS (
  SELECT
    cps."challengeId" AS challenge_id,
    COALESCE(SUM(pr.value), 0)::numeric(12, 2) AS prize
  FROM challenges."ChallengePrizeSet" cps
  JOIN challenges."Prize" pr
    ON pr."prizeSetId" = cps.id
  JOIN base_challenges bc
    ON bc.id = cps."challengeId"
  GROUP BY cps."challengeId"
),
tag_list AS (
  SELECT
    bc.id AS challenge_id,
    STRING_AGG(DISTINCT t.tag, ', ') AS tags
  FROM base_challenges bc
  LEFT JOIN LATERAL UNNEST(bc.tags) AS t(tag)
    ON TRUE
  GROUP BY bc.id
),
group_list AS (
  SELECT
    bc.id AS challenge_id,
    STRING_AGG(DISTINCT g.name, ', ') AS groups
  FROM base_challenges bc
  LEFT JOIN LATERAL UNNEST(bc.groups) AS gid(group_id)
    ON TRUE
  LEFT JOIN groups."Group" g
    ON g.id = gid.group_id
  GROUP BY bc.id
),
reviewer_roles AS (
  SELECT id
  FROM resources."ResourceRole"
  WHERE COALESCE("nameLower", LOWER(name)) LIKE '%review%'
),
submitter_roles AS (
  SELECT id
  FROM resources."ResourceRole"
  WHERE COALESCE("nameLower", LOWER(name)) = 'submitter'
),
registration_end AS (
  SELECT
    cp."challengeId" AS challenge_id,
    MAX(COALESCE(cp."actualEndDate", cp."scheduledEndDate")) AS registration_end_date
  FROM challenges."ChallengePhase" cp
  JOIN challenges."Phase" p ON p.id = cp."phaseId"
  WHERE p.name = 'Registration'
  GROUP BY cp."challengeId"
),
submission_end AS (
  SELECT
    cp."challengeId" AS challenge_id,
    cp."scheduledEndDate" AS submission_end_date
  FROM challenges."ChallengePhase" cp
  JOIN challenges."Phase" p ON p.id = cp."phaseId"
  WHERE p.name IN ('Topcoder Submission', 'Topgear Submission', 'Submission')
  GROUP BY cp."challengeId"
)
SELECT
  bc."updatedAt"                                   AS modify_date,
  bc.billing_account_id                            AS billing_account_id,
  prj.project_name                                 AS project_name,
  prj.project_id                                   AS project_id,
  bc.id                                            AS challenge_id,
  bc.name                                          AS challenge_name,
  bc.status                                        AS challenge_status,
  ct.name                                          AS challenge_type,
  reg.registration_end_date                        AS registration_end_date,
  se.submission_end_date                           AS submission_end_date,
  pd.latest_actual_end_date                        AS completed_date,
  mt.onsite_efforts                                AS onsite_efforts,
  mt.offsite_efforts                               AS offsite_efforts,
  COALESCE(rv.num_reviews, 0)                      AS num_reviews,
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
  prj.planned_end_date                             AS planned_end_date,
  bc.id                                            AS id,
  bc."legacyId"                                    AS legacy_id,
  bc."numOfSubmissions"                            AS num_submissions,
  bc."numOfRegistrants"                            AS num_registrations,
  ''::text                                         AS sub_practice,
  ''::text                                         AS practice,
  mt.onsite_efforts                                AS v5_onsite_efforts,
  mt.offsite_efforts                               AS v5_offsite_efforts,
  pz.prize                                         AS prize,
  tl.tags                                          AS tags,
  gl.groups                                        AS groups,
  bc."createdBy"                                   AS creator,
  bc."createdAt"                                   AS creation_date,
  CASE
    WHEN bc.status = 'COMPLETED' AND pd.latest_actual_end_date IS NOT NULL
      THEN to_char(pd.latest_actual_end_date, 'Mon-YY')
    ELSE NULL
  END                                              AS completed_month,
  CASE
    WHEN bc.status = 'COMPLETED' AND pd.latest_actual_end_date IS NOT NULL
      THEN to_char(pd.latest_actual_end_date, 'DD-Mon-YYYY HH24:MI:SS')
    ELSE NULL
  END                                              AS completed_date_formatted,
  bc."registrationStartDate"                       AS registration_start_date,
  CASE
    WHEN bc.status = 'COMPLETED'
      AND bc."createdAt" > '2025-01-01T00:00:00Z'
      THEN cp.payment_modify_date
    ELSE NULL
  END                                              AS payment_modify_date,
  rv.reviewer_email                                AS reviewer_email,
  CASE
    WHEN bc."createdAt" > '2025-01-01T00:00:00Z'
      AND bc.status IN ('ACTIVE', 'COMPLETED')
      THEN COALESCE(rvp.reviewer_payment, 0::numeric(12, 2))
    ELSE NULL
  END                                              AS reviewer_payment,
  CASE
    WHEN bc."createdAt" > '2025-01-01T00:00:00Z'
      AND bc.status IN ('ACTIVE', 'COMPLETED')
      THEN COALESCE(rvp.reviewer_payment_status, 'UNKNOWN')
    ELSE NULL
  END                                              AS reviewer_payment_status,
  w1.winner_1_email,
  CASE
    WHEN bc."createdAt" > '2025-01-01T00:00:00Z'
      AND bc.status IN ('ACTIVE', 'COMPLETED')
      THEN COALESCE(w1.winner_1_prize_amount, 0::numeric(12, 2))
    ELSE NULL
  END                                              AS winner_1_prize_amount,
  CASE
    WHEN bc."createdAt" > '2025-01-01T00:00:00Z'
      AND bc.status IN ('ACTIVE', 'COMPLETED')
      THEN COALESCE(w1.winner_1_payment_status, 'UNKNOWN')
    ELSE NULL
  END                                              AS winner_1_payment_status,
  re.registrant_email_ids,
  sub.submitter_email_ids,
  to_char(bc."createdAt", 'DD-Mon-YYYY HH24:MI:SS') AS creation_date_formatted,
  CASE
    WHEN sub.latest_submission_date IS NOT NULL
      THEN to_char(sub.latest_submission_date, 'DD-Mon-YYYY HH24:MI:SS')
    ELSE NULL
  END                                              AS submission_date_formatted
FROM base_challenges bc
LEFT JOIN challenges."ChallengeType" ct
  ON ct.id = bc."typeId"
LEFT JOIN project_details prj
  ON prj.challenge_id = bc.id
LEFT JOIN meta mt
  ON mt.challenge_id = bc.id
LEFT JOIN prizes pz
  ON pz.challenge_id = bc.id
LEFT JOIN tag_list tl
  ON tl.challenge_id = bc.id
LEFT JOIN group_list gl
  ON gl.challenge_id = bc.id
LEFT JOIN registration_end reg
  ON reg.challenge_id = bc.id
LEFT JOIN submission_end se
  ON se.challenge_id = bc.id
LEFT JOIN LATERAL (
  SELECT
    MAX(cp."actualEndDate") AS latest_actual_end_date
  FROM challenges."ChallengePhase" cp
  WHERE cp."challengeId" = bc.id
) pd ON TRUE
LEFT JOIN LATERAL (
  SELECT
    COUNT(*)::int AS num_submissions,
    MAX(s."submittedDate") AS latest_submission_date,
    MAX(s."memberId"::text) FILTER (WHERE s.placement = 1) AS winner1_member_id,
    STRING_AGG(DISTINCT mm.email, ', ')
      FILTER (WHERE mm.email IS NOT NULL) AS submitter_email_ids
  FROM reviews.submission s
  LEFT JOIN members.member mm
    ON mm."userId"::text = s."memberId"::text
  WHERE s."challengeId" = bc.id
) sub ON TRUE
LEFT JOIN LATERAL (
  SELECT
    COUNT(DISTINCT r."memberId"::text) AS num_reviews,
    STRING_AGG(DISTINCT mm.email, ', ')
      FILTER (WHERE mm.email IS NOT NULL) AS reviewer_email
  FROM resources."Resource" r
  JOIN reviewer_roles rr
    ON rr.id = r."roleId"
  LEFT JOIN members.member mm
    ON mm."userId"::text = r."memberId"::text
  WHERE r."challengeId" = bc.id
) rv ON TRUE
LEFT JOIN LATERAL (
  SELECT
    COALESCE(SUM(COALESCE(ps.total_amount, 0)), 0)::numeric(12, 2) AS reviewer_payment,
    STRING_AGG(DISTINCT COALESCE(ps.payment_status, 'UNKNOWN'), ', ') AS reviewer_payment_status
  FROM resources."Resource" r
  JOIN reviewer_roles rr
    ON rr.id = r."roleId"
  LEFT JOIN finance.winnings w
    ON w.external_id = bc.id
   AND w.winner_id = r."memberId"::text
  LEFT JOIN LATERAL (
    SELECT
      SUM(p.total_amount)::numeric(12, 2) AS total_amount,
      STRING_AGG(DISTINCT COALESCE(p.payment_status::text, 'UNKNOWN'), ', ') AS payment_status
    FROM finance.payment p
    WHERE p.winnings_id = w.winning_id
  ) ps ON TRUE
  WHERE r."challengeId" = bc.id
    AND bc."createdAt" > '2025-01-01T00:00:00Z'
    AND bc.status IN ('ACTIVE', 'COMPLETED')
) rvp ON TRUE
LEFT JOIN LATERAL (
  SELECT
    STRING_AGG(DISTINCT mm.email, ', ')
      FILTER (WHERE mm.email IS NOT NULL) AS registrant_email_ids
  FROM resources."Resource" r
  JOIN submitter_roles sr
    ON sr.id = r."roleId"
  LEFT JOIN members.member mm
    ON mm."userId"::text = r."memberId"::text
  WHERE r."challengeId" = bc.id
) re ON TRUE
LEFT JOIN LATERAL (
  SELECT
    mm.email AS winner_1_email,
    ps.total_amount AS winner_1_prize_amount,
    ps.payment_status AS winner_1_payment_status
  FROM finance.winnings w
  LEFT JOIN LATERAL (
    SELECT
      SUM(p.total_amount)::numeric(12, 2) AS total_amount,
      STRING_AGG(DISTINCT COALESCE(p.payment_status::text, 'UNKNOWN'), ', ') AS payment_status
    FROM finance.payment p
    WHERE p.winnings_id = w.winning_id
  ) ps ON TRUE
  LEFT JOIN members.member mm
    ON mm."userId"::text = w.winner_id
  WHERE w.external_id = bc.id
    AND w.winner_id = sub.winner1_member_id
    AND bc."createdAt" > '2025-01-01T00:00:00Z'
    AND bc.status IN ('ACTIVE', 'COMPLETED')
  LIMIT 1
) w1 ON TRUE
LEFT JOIN LATERAL (
  SELECT
    MAX(p.updated_at) AS payment_modify_date
  FROM finance.winnings w
  LEFT JOIN finance.payment p
    ON p.winnings_id = w.winning_id
  WHERE w.external_id = bc.id
    AND bc.status = 'COMPLETED'
    AND bc."createdAt" > '2025-01-01T00:00:00Z'
) cp ON TRUE
WHERE bc.billing_account_id = '80000062'
  AND (pd.latest_actual_end_date >= now() - interval '100 days'
  OR bc.status='ACTIVE')
ORDER BY bc."updatedAt" DESC;
