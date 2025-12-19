SELECT
  rb.id AS "resourceBookingId",
  rb.job_id AS "jobId",
  rb.project_id AS "projectId",
  rb.user_id AS "userId",
  u.handle AS "userHandle",
  u.first_name AS "firstName",
  u.last_name AS "lastName",
  rb.status,
  rb.start_date AS "startDate",
  rb.end_date AS "endDate",
  rb.member_rate AS "memberRate",
  rb.customer_rate AS "customerRate",
  rb.rate_type AS "rateType",
  rb.billing_account_id AS "billingAccountId",
  rb.created_at AT TIME ZONE 'America/New_York' AS "createdAt",
  rb.updated_at AT TIME ZONE 'America/New_York' AS "updatedAt"
FROM taas.resource_bookings rb
LEFT JOIN identity."user" u ON rb.user_id = u.user_id::text
WHERE
  rb.deleted_at IS NULL
  AND ($1::uuid[] IS NULL OR rb.id = ANY($1))
  AND ($2::uuid[] IS NULL OR rb.job_id = ANY($2))
  AND ($3::integer[] IS NULL OR rb.project_id = ANY($3))
  AND ($4::text[] IS NULL OR rb.user_id = ANY($4))
  AND ($5::text[] IS NULL OR LOWER(u.handle) = ANY($5))
  AND ($6::text[] IS NULL OR rb.status = ANY($6))
  AND ($7::text[] IS NULL OR rb.billing_account_id::text = ANY($7))
  AND ($8::timestamp IS NULL OR rb.start_date >= $8::date)
  AND ($9::timestamp IS NULL OR rb.end_date <= $9::date)
  AND ($10::numeric IS NULL OR rb.customer_rate >= $10)
  AND ($11::numeric IS NULL OR rb.customer_rate <= $11)
ORDER BY rb.created_at DESC
LIMIT 1000;
