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
    ) AS posting_dt,
    CASE
      WHEN COALESCE(c."taskIsTask", false) THEN 1
      ELSE 0
    END AS task_indicator
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
    cb.project_id,
    cb.posting_dt,
    cb.task_indicator,
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
    cc.task_indicator,
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
),
weekly_challenge_counts AS (
  SELECT
    fc.task_indicator AS "challenge.task_ind",
    TO_CHAR(
      (
        DATE_TRUNC('week', fc.posting_dt + INTERVAL '1 day')
        - INTERVAL '1 day'
      )::date,
      'YYYY-MM-DD'
    ) AS "challenge.posting_week",
    COUNT(DISTINCT fc.challenge_id) AS "challenge.count"
  FROM filtered_challenges fc
  GROUP BY 1, 2
),
ranked_columns AS (
  SELECT
    wcc.*,
    DENSE_RANK() OVER (
      ORDER BY wcc."challenge.task_ind" NULLS LAST
    ) AS z__pivot_col_rank
  FROM weekly_challenge_counts wcc
),
ranked_rows AS (
  SELECT
    rc.*,
    RANK() OVER (
      ORDER BY rc."challenge.posting_week" DESC, rc.z__pivot_col_rank
    ) AS z___rank
  FROM ranked_columns rc
),
row_min_rank AS (
  SELECT
    rr.*,
    MIN(rr.z___rank) OVER (
      PARTITION BY rr."challenge.posting_week"
    ) AS z___min_rank
  FROM ranked_rows rr
),
final_rows AS (
  SELECT
    rmr.*,
    DENSE_RANK() OVER (
      ORDER BY rmr.z___min_rank
    ) AS z___pivot_row_rank,
    RANK() OVER (
      PARTITION BY rmr.z__pivot_col_rank
      ORDER BY rmr.z___min_rank
    ) AS z__pivot_col_ordering,
    CASE
      WHEN rmr.z___min_rank = rmr.z___rank THEN 1
      ELSE 0
    END AS z__is_highest_ranked_cell
  FROM row_min_rank rmr
)
SELECT
  fr."challenge.task_ind",
  fr."challenge.posting_week",
  fr."challenge.count",
  fr.z__pivot_col_rank,
  fr.z___rank,
  fr.z___min_rank,
  fr.z___pivot_row_rank,
  fr.z__pivot_col_ordering,
  fr.z__is_highest_ranked_cell
FROM final_rows fr
WHERE (fr.z__pivot_col_rank <= 50 OR fr.z__is_highest_ranked_cell = 1)
  AND (fr.z___pivot_row_rank <= 4 OR fr.z__pivot_col_ordering = 1)
ORDER BY fr.z___pivot_row_rank;
