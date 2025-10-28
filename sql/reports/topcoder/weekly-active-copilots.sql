WITH window_bounds AS (
  SELECT
    DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '5 months' AS window_start,
    DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month' AS window_end
),
challenge_base AS (
  SELECT
    c.id AS challenge_id,
    c."projectId" AS project_id,
    c.groups,
    c."typeId" AS type_id,
    c."trackId" AS track_id,
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
billing AS (
  SELECT
    cb.challenge_id,
    COALESCE(
      NULLIF(TRIM(MAX(ba.name) FILTER (WHERE ba.name IS NOT NULL)), ''),
      NULLIF(TRIM(MAX(project_ba.name) FILTER (WHERE project_ba.name IS NOT NULL)), '')
    ) AS billing_account_name
  FROM challenge_base cb
  LEFT JOIN challenges."ChallengeBilling" chb
    ON chb."challengeId" = cb.challenge_id
  LEFT JOIN "billing-accounts"."BillingAccount" ba
    ON ba.id = NULLIF(chb."billingAccountId", '')::bigint
  LEFT JOIN projects.projects proj
    ON proj.id = cb.project_id::bigint
  LEFT JOIN "billing-accounts"."BillingAccount" project_ba
    ON project_ba.id = proj."billingAccountId"
  GROUP BY cb.challenge_id
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
challenge_clients AS (
  SELECT
    cb.challenge_id,
    cb.posting_dt,
    cb.type_id,
    cb.track_id,
    cb.groups,
    cb.project_id,
    COALESCE(
      NULLIF(TRIM(b.billing_account_name), ''),
      NULLIF(TRIM(pc.group_customer_name), ''),
      NULLIF(TRIM(pc.project_name), '')
    ) AS client_name,
    NULLIF(TRIM(pc.project_name), '') AS project_name
  FROM challenge_base cb
  LEFT JOIN billing b
    ON b.challenge_id = cb.challenge_id
  LEFT JOIN project_clients pc
    ON pc.project_id = cb.project_id::bigint
),
filtered_challenges AS (
  SELECT
    cc.challenge_id,
    cc.posting_dt,
    cc.type_id,
    cc.track_id,
    cc.groups,
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
      FROM unnest(COALESCE(cc.groups, ARRAY[]::text[])) AS group_ref(group_id)
      JOIN groups."Group" g
        ON g.id = group_ref.group_id
      WHERE g.name ILIKE 'Wipro%'
    )
),
copilot_assignments AS (
  SELECT DISTINCT
    r."challengeId" AS challenge_id,
    COALESCE(
      NULLIF(TRIM(m.handle), ''),
      NULLIF(TRIM(r."memberHandle"), '')
    ) AS copilot_handle
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId"
  LEFT JOIN members.member m
    ON m."userId"::text = r."memberId"
  WHERE COALESCE(rr."nameLower", LOWER(rr.name)) = 'copilot'
    AND COALESCE(
      NULLIF(TRIM(m.handle), ''),
      NULLIF(TRIM(r."memberHandle"), '')
    ) IS NOT NULL
    AND (
      m.email IS NULL
      OR (
        m.email NOT ILIKE '%@topcoder.com'
        AND m.email NOT ILIKE '%@wipro.com'
      )
    )
),
challenge_type_map AS (
  SELECT
    ct.id,
    CASE
      WHEN UPPER(TRIM(ct.name)) IN (
        'FIRST2FINISH',
        'FIRST2FINISH CHALLENGE',
        'CODE',
        'ASSEMBLY COMPETITION',
        'UI PROTOTYPE COMPETITION',
        'ARCHITECTURE',
        'COPILOT POSTING',
        'TEST SCENARIOS',
        'CONTENT CREATION',
        'TEST SUITES',
        'SPECIFICATION',
        'CONCEPTUALIZATION',
        'DESIGN',
        'DEVELOPMENT',
        'BUG HUNT'
      ) THEN 'Develop'
      WHEN UPPER(TRIM(ct.name)) IN (
        'WEB DESIGN',
        'WIDGET OR MOBILE SCREEN DESIGN',
        'DESIGN FIRST2FINISH',
        'WIREFRAMES',
        'PRINT/PRESENTATION',
        'IDEA GENERATION',
        'LOGO DESIGN',
        'APPLICATION FRONT-END DESIGN',
        'BANNERS/ICONS',
        'STUDIO OTHER'
      ) THEN 'Design'
      WHEN UPPER(TRIM(ct.name)) = 'MARATHON MATCH' THEN 'Data Science'
      ELSE 'Other'
    END AS mapped_track
  FROM challenges."ChallengeType" ct
),
challenge_track_map AS (
  SELECT
    ct.id,
    CASE ct.track
      WHEN 'DEVELOPMENT' THEN 'Develop'
      WHEN 'DESIGN' THEN 'Design'
      WHEN 'DATA_SCIENCE' THEN 'Data Science'
      ELSE 'Other'
    END AS default_track
  FROM challenges."ChallengeTrack" ct
),
weekly AS (
  SELECT
    (DATE_TRUNC('week', fc.posting_dt + INTERVAL '1 day') - INTERVAL '1 day')::date AS posting_week,
    COALESCE(
      ctm.mapped_track,
      ctrack.default_track,
      'Other'
    ) AS track_name,
    COUNT(DISTINCT fc.challenge_id)::bigint AS challenge_count,
    COUNT(DISTINCT ca.copilot_handle)::bigint AS copilot_count
  FROM filtered_challenges fc
  JOIN copilot_assignments ca
    ON ca.challenge_id = fc.challenge_id
  LEFT JOIN challenge_type_map ctm
    ON ctm.id = fc.type_id
  LEFT JOIN challenge_track_map ctrack
    ON ctrack.id = fc.track_id
  GROUP BY 1, 2
)
SELECT
  TO_CHAR(w.posting_week, 'YYYY-MM-DD') AS "challenge_stats.posting_week",
  w.track_name AS "challenge.track",
  w.challenge_count AS "challenge.count",
  w.copilot_count AS "copilot.count"
FROM weekly w
ORDER BY w.posting_week DESC, w.track_name;
