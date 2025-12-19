SELECT
  j.id AS "jobId",
  j.project_id AS "projectId",
  j.external_id AS "externalId",
  j.title,
  j.description,
  j.status,
  j.resource_type AS "resourceType",
  j.rate_type AS "rateType",
  j.skills,
  j.num_positions AS "numPositions",
  j.start_date AS "startDate",
  j.duration,
  j.workload,
  j.min_salary AS "minSalary",
  j.max_salary AS "maxSalary",
  j.hours_per_week AS "hoursPerWeek",
  j.currency,
  j.created_at AT TIME ZONE 'America/New_York' AS "createdAt",
  j.updated_at AT TIME ZONE 'America/New_York' AS "updatedAt"
FROM taas.jobs j
WHERE
  j.deleted_at IS NULL
  AND ($1::uuid[] IS NULL OR j.id = ANY($1))
  AND ($2::integer[] IS NULL OR j.project_id = ANY($2))
  AND ($3::text[] IS NULL OR j.status = ANY($3))
  AND ($4::text[] IS NULL OR j.resource_type = ANY($4))
  AND ($5::text[] IS NULL OR j.skills ?| $5)
  AND ($6::timestamp IS NULL OR j.start_date >= $6::date)
  AND ($7::timestamp IS NULL OR j.start_date <= $7::date)
  AND ($8::integer IS NULL OR j.num_positions >= $8)
  AND ($9::integer IS NULL OR j.num_positions <= $9)
ORDER BY j.created_at DESC
LIMIT 1000;
