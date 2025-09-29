WITH base AS (
  SELECT
    c.id          AS challenge_id,
    c.status      AS challenge_status,
    c."projectId" AS project_id,
    c."createdAt" AS challenge_created_at,
    c."endDate"   AS planned_end_at
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
submissions AS (
  SELECT
    s."challengeId"      AS challenge_id,
    s."memberId"::bigint AS member_id,
    MAX(s."finalScore")  AS best_final_score
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
  SELECT
    cb."challengeId"              AS challenge_id,
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
registrants AS (
  SELECT
    r."challengeId"                      AS challenge_id,
    r."memberId"::bigint                 AS member_id,
    COALESCE(r."memberHandle", m.handle) AS registrant_handle,
    m.email                              AS registrant_email
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId" AND rr.name = 'Submitter'
  LEFT JOIN members.member m
    ON m."userId" = r."memberId"::bigint
),
base_data AS (
  SELECT
    reg.registrant_handle,
    reg.member_id,
    reg.registrant_email,
    bse.challenge_id,
    bse.challenge_status,
    prj.group_customer_name,
    COALESCE(
      CASE WHEN bse.challenge_status = 'COMPLETED' THEN lp.last_phase_end END,
      bse.planned_end_at,
      bse.challenge_created_at
    ) AS posting_date,
    CASE WHEN sub.best_final_score IS NOT NULL THEN 1 ELSE 0 END AS did_submit,
    CASE WHEN win.winner_handle = reg.registrant_handle THEN 1 ELSE 0 END AS did_win
  FROM base bse
  JOIN registrants reg
    ON reg.challenge_id = bse.challenge_id
  LEFT JOIN submissions sub
    ON sub.challenge_id = bse.challenge_id
   AND sub.member_id   = reg.member_id
  LEFT JOIN winners win
    ON win.challenge_id = bse.challenge_id
  LEFT JOIN last_phase lp
    ON lp.challenge_id = bse.challenge_id
  LEFT JOIN proj prj
    ON prj.project_id = bse.project_id
  LEFT JOIN billing bil
    ON bil.challenge_id = bse.challenge_id
  WHERE COALESCE(bil.billing_account_id, prj.project_billing_account_id) = 80000062
)
SELECT
  bd.registrant_handle                                 AS "challengeRegistrantHandle",
  bd.registrant_email                                  AS "userEmail",
  COUNT(DISTINCT bd.challenge_id)                      AS "challengeDistinctCount",
  SUM(bd.did_submit)                                   AS "submissionByAUser",
  SUM(bd.did_win)                                      AS "challengeStatsWins"
FROM base_data bd
WHERE
  bd.posting_date BETWEEN $1::timestamptz AND $2::timestamptz
  AND bd.challenge_status::text = 'COMPLETED'
  AND bd.registrant_handle IS NOT NULL
GROUP BY
  bd.registrant_handle,
  bd.registrant_email
ORDER BY
  "challenge_stats.count_distinct_challenge" DESC
LIMIT 1000;
