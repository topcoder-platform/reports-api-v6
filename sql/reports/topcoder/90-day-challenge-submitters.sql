WITH registrants AS (
  SELECT
    r."memberHandle" AS registrant_handle,
    r."memberId",
    r."challengeId",
    c.groups,
    ba.name AS billing_account_name
  FROM resources."Resource" AS r
  JOIN resources."ResourceRole" AS rr
    ON rr.id = r."roleId"
  JOIN challenges."Challenge" AS c
    ON c.id = r."challengeId"
  LEFT JOIN challenges."ChallengeBilling" AS cb
    ON cb."challengeId" = r."challengeId"
  LEFT JOIN "billing-accounts"."BillingAccount" AS ba
    ON ba.id::text = cb."billingAccountId"
  WHERE LOWER(rr.name) = 'submitter'
    AND r."createdAt" >= (DATE_TRUNC('day', CURRENT_TIMESTAMP) - INTERVAL '89 days')
    AND r."createdAt" < (DATE_TRUNC('day', CURRENT_TIMESTAMP) + INTERVAL '1 day')
    AND NOT EXISTS (
      SELECT 1
      FROM UNNEST(COALESCE(c.groups, ARRAY[]::text[])) AS group_ref(group_id)
      JOIN groups."Group" AS g
        ON g.id = group_ref.group_id
      WHERE g.name ILIKE 'Wipro%'
    )
    AND (
      ba.name IS NULL OR (
        ba.name NOT ILIKE 'Fun & Learning Challenges (Jaipur)'
        AND ba.name NOT ILIKE 'Fun & Learning - 2016 (Jaipur)'
        AND ba.name NOT ILIKE 'TopGear Trial'
      )
    )
)
SELECT
  COUNT(DISTINCT registrants.registrant_handle)::bigint AS "challenge_stats.count_distinct_registrant",
  COUNT(
    DISTINCT CASE
      WHEN EXISTS (
        SELECT 1
        FROM reviews.submission AS s
        WHERE s."challengeId" = registrants."challengeId"
          AND s."memberId" = registrants."memberId"
      )
      THEN registrants.registrant_handle
    END
  )::bigint AS "challenge_stats.count_distinct_submitter"
FROM registrants;
