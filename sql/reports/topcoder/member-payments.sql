WITH base AS (
  SELECT
    DATE(p.created_at) AS payment_created_date,

    -- Payment info
    p.payment_id,
    w.description AS payment_desc,

    -- Challenge system id
    COALESCE(
      NULLIF(TRIM(w.external_id), ''),
      NULLIF(TRIM(c."id"::text), '')
    ) AS challenge_system_id,

    p.payment_status,                
    w.category::text AS payment_type_desc,

    -- Member info
    mem.handle AS member_handle,
    NULL::text AS payment_method_desc,
    mem."userId" AS member_user_id,

    -- Billing / client info
    ba."name" AS billing_account_name,
    cl."name" AS customer_name,
    cl."codeName" AS sfdc_account_name,
    NULL::text AS parent_name,

    -- Challenge dates
    DATE(c."createdAt") AS challenge_created_date,

    -- Amount
    COALESCE(p.gross_amount, p.total_amount) AS gross_amount
  FROM finance.payment p
  JOIN finance.winnings w
    ON w.winning_id = p.winnings_id
  JOIN members.member mem
    ON mem."userId"::text = w.winner_id

  LEFT JOIN challenges."Challenge" c
    ON c."id" = w.external_id

  LEFT JOIN challenges."ChallengeBilling" cb
    ON cb."challengeId" = c."id"

  LEFT JOIN "billing-accounts"."BillingAccount" ba
    ON ba."id" = COALESCE(
      NULLIF(p.billing_account, '')::int,
      NULLIF(cb."billingAccountId", '')::int
    )

  LEFT JOIN "billing-accounts"."Client" cl
    ON cl."id" = ba."clientId"

  LEFT JOIN projects.projects proj
    ON proj.id = c."projectId"::bigint

  WHERE DATE(p.created_at) >= $1::date
    AND DATE(p.created_at) <  $2::date
)
SELECT
  payment_created_date                         AS "payment_create_date.date_date",
  payment_id                                   AS "payment.payment_id",
  payment_desc                                 AS "payment.payment_desc",
  COALESCE(challenge_system_id, '-')           AS "challenge.challenge_system_id",
  payment_status                               AS "payment.payment_status_desc",
  payment_type_desc                            AS "payment.payment_type_desc",
  member_handle                                AS "payee.handle",
  payment_method_desc                          AS "payee.payment_method_desc",
  billing_account_name                         AS "billing_account_budgets.billing_account_name",
  customer_name                                AS "billing_account_budgets.customer_name",
  sfdc_account_name                            AS "sfdc_account.name",
  member_user_id                               AS "member_profile_basic.user_id",
  parent_name                                  AS "sfdc_account.parent_name",
  challenge_created_date                       AS "challenge.create_date",
  COALESCE(SUM(gross_amount), 0)               AS "user_payment.gross_amount"
FROM base
GROUP BY
  payment_created_date,
  payment_id,
  payment_desc,
  challenge_system_id,
  payment_status,
  payment_type_desc,
  member_handle,
  payment_method_desc,
  billing_account_name,
  customer_name,
  sfdc_account_name,
  member_user_id,
  parent_name,
  challenge_created_date
ORDER BY
  payment_created_date DESC
LIMIT 5000;
