SELECT
  p.id::text AS project_id,
  NULLIF(BTRIM(p.name), '') AS project_name
FROM projects.projects p
WHERE p.id::text = ANY($1::text[])
  AND p."deletedAt" IS NULL
ORDER BY LOWER(p.name), p.id;
