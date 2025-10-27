WITH billing AS (
  SELECT
    c.id AS challenge_id,
    COALESCE(
      MAX(ba.name) FILTER (WHERE ba.name IS NOT NULL),
      MAX(project_ba.name) FILTER (WHERE project_ba.name IS NOT NULL)
    ) AS billing_account_name
  FROM challenges."Challenge" c
  LEFT JOIN challenges."ChallengeBilling" cb
    ON cb."challengeId" = c.id
  LEFT JOIN "billing-accounts"."BillingAccount" ba
    ON ba.id = NULLIF(cb."billingAccountId", '')::bigint
  LEFT JOIN projects.projects proj
    ON proj.id = c."projectId"::bigint
  LEFT JOIN "billing-accounts"."BillingAccount" project_ba
    ON project_ba.id = proj."billingAccountId"
  GROUP BY c.id
),
filtered_challenges AS (
  SELECT
    c.id AS challenge_id
  FROM challenges."Challenge" c
  LEFT JOIN billing bill
    ON bill.challenge_id = c.id
  WHERE (
      (
        bill.billing_account_name NOT ILIKE 'Fun & Learning Challenges (Jaipur)'
        AND bill.billing_account_name NOT ILIKE 'Fun & Learning - 2016 (Jaipur)'
        AND bill.billing_account_name NOT ILIKE 'TopGear Trial'
      )
      OR bill.billing_account_name IS NULL
    )
    AND NOT EXISTS (
      SELECT 1
      FROM unnest(COALESCE(c.groups, ARRAY[]::text[])) AS group_ref(group_id)
      JOIN groups."Group" g ON g.id = group_ref.group_id
      WHERE g.name ILIKE 'Wipro%'
    )
),
registrants AS (
  SELECT
    r."challengeId" AS challenge_id,
    r."memberId"::bigint AS member_id,
    COALESCE(NULLIF(r."memberHandle", ''), m.handle) AS member_handle,
    r."createdAt" AS registered_at
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr
    ON rr.id = r."roleId" AND rr.name = 'Submitter'
  LEFT JOIN members.member m
    ON m."userId" = r."memberId"::bigint
  WHERE r."createdAt" >= (CURRENT_DATE - INTERVAL '89 days')
    AND r."createdAt" < (CURRENT_DATE + INTERVAL '1 day')
    AND COALESCE(NULLIF(r."memberHandle", ''), m.handle) IS NOT NULL
),
submissions AS (
  SELECT DISTINCT
    s."challengeId" AS challenge_id,
    s."memberId"::bigint AS member_id
  FROM reviews.submission s
  WHERE s.status <> 'DELETED'
)
SELECT
  COUNT(DISTINCT reg.member_handle) AS "challenge_stats.count_distinct_registrant",
  COUNT(DISTINCT CASE WHEN sub.member_id IS NOT NULL THEN reg.member_handle END) AS "challenge_stats.count_distinct_submitter"
FROM registrants reg
JOIN filtered_challenges fc
  ON fc.challenge_id = reg.challenge_id
LEFT JOIN submissions sub
  ON sub.challenge_id = reg.challenge_id
 AND sub.member_id = reg.member_id;
