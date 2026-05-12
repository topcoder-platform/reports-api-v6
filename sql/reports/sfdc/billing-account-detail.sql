SELECT
  ba.name,
  ba.description,
  ba."subcontractingEndCustomer" AS "subcontractingEndCustomer",
  ba.status::text AS status,
  ba."startDate" AS "startDate",
  ba."endDate" AS "endDate",
  ba.budget,
  ba.markup
FROM "billing-accounts"."BillingAccount" ba
WHERE ba.id::text = TRIM($1)
