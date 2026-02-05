WITH provided_dates AS (
  SELECT
    NULLIF($1, '')::timestamptz AS start_date,
    NULLIF($2, '')::timestamptz AS end_date
),
window_bounds AS (
  SELECT
    COALESCE(
      pd.start_date,
      CASE
        WHEN pd.end_date IS NOT NULL THEN pd.end_date - INTERVAL '5 weeks'
        ELSE DATE_TRUNC('week', CURRENT_DATE) - INTERVAL '4 weeks'
      END
    ) AS window_start,
    COALESCE(
      pd.end_date,
      DATE_TRUNC('week', CURRENT_DATE) + INTERVAL '1 week'
    ) AS window_end
  FROM provided_dates pd
),
billing AS (
  SELECT
    c.id AS challenge_id,
    COALESCE(
      NULLIF(TRIM(MAX(ba.name) FILTER (WHERE ba.name IS NOT NULL)), ''),
      NULLIF(TRIM(MAX(project_ba.name) FILTER (WHERE project_ba.name IS NOT NULL)), '')
    ) AS billing_account_name
  FROM challenges."Challenge" c
  LEFT JOIN challenges."ChallengeBilling" cb
    ON cb."challengeId" = c.id
  LEFT JOIN "billing-accounts"."BillingAccount" ba
    ON ba.id::text = NULLIF(TRIM(cb."billingAccountId"), '')
  LEFT JOIN projects.projects proj
    ON proj.id::text = NULLIF(TRIM(c."projectId"::text), '')
  LEFT JOIN "billing-accounts"."BillingAccount" project_ba
    ON project_ba.id::text = NULLIF(TRIM(proj."billingAccountId"::text), '')
  GROUP BY c.id
),
project_clients AS (
  SELECT
    p.id::text AS project_id,
    NULLIF(TRIM(p.name), '') AS project_name,
    NULLIF(
      TRIM(p.details::jsonb -> 'project_data' ->> 'group_customer_name'),
      ''
    ) AS group_customer_name
  FROM projects.projects p
),
challenge_base AS (
  SELECT
    c.id AS challenge_id,
    NULLIF(TRIM(c."projectId"::text), '') AS project_id,
    c.groups AS challenge_groups,
    COALESCE(
      c."registrationStartDate",
      c."startDate",
      c."createdAt"
    ) AS posting_dt
  FROM challenges."Challenge" c
  JOIN window_bounds wb ON TRUE
  WHERE (
      c.status IS NULL
      OR c.status NOT IN ('DELETED', 'DRAFT', 'NEW')
    )
    AND COALESCE(
      c."registrationStartDate",
      c."startDate",
      c."createdAt"
    ) >= wb.window_start
    AND COALESCE(
      c."registrationStartDate",
      c."startDate",
      c."createdAt"
    ) < wb.window_end
),
challenge_clients AS (
  SELECT
    cb.challenge_id,
    cb.posting_dt,
    cb.challenge_groups,
    COALESCE(
      NULLIF(TRIM(b.billing_account_name), ''),
      NULLIF(TRIM(pc.group_customer_name), ''),
      NULLIF(TRIM(pc.project_name), '')
    ) AS client_name
  FROM challenge_base cb
  LEFT JOIN billing b
    ON b.challenge_id = cb.challenge_id
  LEFT JOIN project_clients pc
    ON pc.project_id = cb.project_id
),
filtered_challenges AS (
  SELECT
    cc.challenge_id,
    cc.posting_dt,
    cc.client_name,
    cc.challenge_groups
  FROM challenge_clients cc
  WHERE (
      cc.client_name IS NULL
      OR (
        cc.client_name NOT ILIKE '[topcoder] copilots'
        AND cc.client_name NOT ILIKE 'Topcoder'
      )
    )
    AND NOT EXISTS (
      SELECT 1
      FROM unnest(COALESCE(cc.challenge_groups, ARRAY[]::text[])) AS group_ref(group_id)
      JOIN groups."Group" g
        ON g.id = group_ref.group_id
      WHERE g.name ILIKE 'Wipro%'
    )
),
registrants AS (
  SELECT
    r."challengeId" AS challenge_id,
    NULLIF(TRIM(r."memberId"), '') AS member_id,
    COALESCE(
      NULLIF(TRIM(r."memberHandle"), ''),
      NULLIF(TRIM(m.handle), '')
    ) AS member_handle
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId"
   AND COALESCE(rr."nameLower", LOWER(rr.name)) = 'submitter'
  LEFT JOIN members.member m
    ON m."userId"::text = NULLIF(TRIM(r."memberId"), '')
  WHERE COALESCE(
      NULLIF(TRIM(r."memberHandle"), ''),
      NULLIF(TRIM(m.handle), '')
    ) IS NOT NULL
),
submissions AS (
  SELECT DISTINCT
    s."challengeId" AS challenge_id,
    NULLIF(TRIM(s."memberId"), '') AS member_id
  FROM reviews.submission s
  WHERE s.status <> 'DELETED'
),
weekly_participation AS (
  SELECT
    (DATE_TRUNC('week', fc.posting_dt + INTERVAL '1 day') - INTERVAL '1 day')::date AS posting_week,
    reg.member_handle,
    (sub.member_id IS NOT NULL) AS did_submit
  FROM filtered_challenges fc
  JOIN registrants reg
    ON reg.challenge_id = fc.challenge_id
  LEFT JOIN submissions sub
    ON sub.challenge_id = fc.challenge_id
   AND sub.member_id = reg.member_id
)
SELECT
  TO_CHAR(wp.posting_week, 'YYYY-MM-DD') AS "challenge_stats.posting_date_week",
  COUNT(DISTINCT wp.member_handle) AS "challenge_stats.count_distinct_registrant",
  COUNT(
    DISTINCT CASE WHEN wp.did_submit THEN wp.member_handle END
  ) AS "challenge_stats.count_distinct_submitter"
FROM weekly_participation wp
GROUP BY wp.posting_week
ORDER BY wp.posting_week DESC;
