WITH window_bounds AS (
  SELECT
    DATE_TRUNC('week', CURRENT_TIMESTAMP + INTERVAL '1 day') - INTERVAL '1 day' AS window_ref
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
    ON ba.id = NULLIF(cb."billingAccountId", '')::bigint
  LEFT JOIN projects.projects proj
    ON proj.id = c."projectId"
  LEFT JOIN "billing-accounts"."BillingAccount" project_ba
    ON project_ba.id = proj."billingAccountId"
  GROUP BY c.id
),
project_clients AS (
  SELECT
    p.id AS project_id,
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
    c."projectId" AS project_id,
    c.groups AS challenge_groups,
    COALESCE(
      c."registrationStartDate",
      c."startDate",
      c."createdAt"
    ) AS posting_dt
  FROM challenges."Challenge" c
  CROSS JOIN window_bounds wb
  WHERE (
      c.status IS NULL
      OR c.status NOT IN ('DELETED', 'DRAFT')
    )
    AND COALESCE(
      c."registrationStartDate",
      c."startDate",
      c."createdAt"
    ) >= (wb.window_ref - INTERVAL '4 weeks')
    AND COALESCE(
      c."registrationStartDate",
      c."startDate",
      c."createdAt"
    ) < DATE_TRUNC('minute', CURRENT_TIMESTAMP)
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
    ) AS client_name,
    pc.project_name
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
    cc.challenge_groups,
    cc.project_name,
    cc.client_name
  FROM challenge_clients cc
  WHERE (
      cc.client_name IS NULL
      OR (
        cc.client_name NOT ILIKE '[topcoder] copilots'
        AND cc.client_name NOT ILIKE 'Topcoder'
      )
    )
    AND (
      cc.project_name IS NULL
      OR (
        cc.project_name NOT ILIKE 'Fun & Learning Challenges (Jaipur)'
        AND cc.project_name NOT ILIKE 'Fun & Learning - 2016 (Jaipur)'
        AND cc.project_name NOT ILIKE 'TopGear Trial'
      )
    )
    AND NOT EXISTS (
      SELECT 1
      FROM unnest(COALESCE(cc.challenge_groups, ARRAY[]::text[])) AS group_ref(group_id)
      JOIN groups."Group" g
        ON g.id = group_ref.group_id
      WHERE g.name ILIKE 'Wipro%'
    )
)
SELECT
  TO_CHAR(
    (
      DATE_TRUNC('week', fc.posting_dt + INTERVAL '1 day')
      - INTERVAL '1 day'
    )::date,
    'YYYY-MM-DD'
  ) AS "challenge.posting_week",
  COUNT(DISTINCT fc.challenge_id) AS "challenge.count"
FROM filtered_challenges fc
GROUP BY 1
ORDER BY 1 DESC
LIMIT 30000;
