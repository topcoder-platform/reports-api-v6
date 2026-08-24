SELECT
  sc.id::text AS id,
  sc.name
FROM skills.skill_category sc
ORDER BY sc.name ASC;
