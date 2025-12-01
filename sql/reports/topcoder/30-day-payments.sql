WITH latest_payment AS (
  SELECT
    p.winnings_id,
    MAX(p.version) AS max_version
  FROM finance.payment p
  GROUP BY p.winnings_id
),
recent_payments AS (
  SELECT
    w.winning_id,
    w.winner_id,
    w.category,
    w.external_id AS challenge_id,
    w.created_at AS winning_created_at,
    p.payment_id,
    p.payment_status,
    p.installment_number,
    p.billing_account,
    p.total_amount,
    p.gross_amount,
    p.challenge_fee,
    p.challenge_markup,
    p.date_paid,
    p.created_at AS payment_created_at
  FROM finance.winnings w
  JOIN finance.payment p
    ON p.winnings_id = w.winning_id
  JOIN latest_payment lp
    ON lp.winnings_id = p.winnings_id
   AND lp.max_version = p.version
  WHERE w.type = 'PAYMENT'
    AND p.installment_number = 1
    AND p.payment_status = 'PAID'
    AND p.created_at >= (CURRENT_DATE - INTERVAL '3 months')
)
SELECT
  cl."name" AS customer,
  cl."codeName" AS client_codename,
  COALESCE(
  	NULLIF(TRIM(proj.details::jsonb #>> '{taasDefinition,oppurtunityDetails,customerName}'), ''),
    NULLIF(TRIM(proj.details::jsonb #>> '{project_data,group_customer_name}'), ''),
    ba."name"
  ) AS customer_name,
  COALESCE(c."projectId"::text, ba."projectId") AS project_id,
  proj.name AS project_name,
  ba.id::text AS billing_account_id,
  ba."name" AS billing_account_name,
  COALESCE(
    NULLIF(TRIM(proj.details::jsonb #>> '{taasDefinition,oppurtunityDetails,customerName}'), ''),
    NULLIF(TRIM(proj.details::jsonb #>> '{project_data,group_customer_name}'), ''),
    ba."name"
  ) AS customer_name,
  rp.challenge_id,
  c."name" AS challenge_name,
  c."createdAt" AS challenge_created_at,
  rp.winner_id AS member_id,
  mem.handle AS member_handle,
  CASE
    WHEN rp.category::text ILIKE '%REVIEW%' THEN 'review'
    WHEN rp.category::text ILIKE '%COPILOT%' THEN 'copilot'
    ELSE 'prize'
  END AS payment_type,
  COALESCE(rp.gross_amount, rp.total_amount) AS member_payment,
  COALESCE(
    rp.challenge_fee,
    COALESCE(rp.gross_amount, rp.total_amount) * (rp.challenge_markup / 100.0)
  ) AS fee,
  rp.payment_created_at AS payment_created_at,
  rp.date_paid AS paid_date
FROM recent_payments rp
LEFT JOIN challenges."Challenge" c
  ON c."id" = rp.challenge_id
LEFT JOIN challenges."ChallengeBilling" cb
  ON cb."challengeId" = c."id"
LEFT JOIN "billing-accounts"."BillingAccount" ba
  ON ba."id" = COALESCE(
    NULLIF(rp.billing_account, '')::int,
    NULLIF(cb."billingAccountId", '')::int
  )
LEFT JOIN "billing-accounts"."Client" cl
  ON cl."id" = ba."clientId"
LEFT JOIN projects.projects proj
  ON proj.id = c."projectId"::bigint
LEFT JOIN members.member mem
  ON mem."userId"::text = rp.winner_id
ORDER BY payment_created_at DESC;
