-- Resolve customer projects on the reporting connection before querying ENGAGEMENTS_DB_URL.
-- Match Sales member-payment customer rules, including internal/TaaS end-customer labels.
-- Unlinked projects cannot be classified as customer work and are excluded.
SELECT p.id::text AS project_id
FROM projects.projects p
JOIN "billing-accounts"."BillingAccount" ba ON ba.id = p."billingAccountId"
JOIN "billing-accounts"."Client" cl ON cl.id = ba."clientId"
WHERE NULLIF(BTRIM(cl.name), '') IS NOT NULL
  AND LOWER(BTRIM(cl.name)) <> 'topcoder'
  AND LOWER(BTRIM(COALESCE(ba."subcontractingEndCustomer", ''))) NOT IN ('topcoder', 'taas');
