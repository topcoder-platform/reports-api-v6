SELECT
  u.user_id AS "userId",
  u.handle AS "handle",
  e.address AS "email"
FROM identity.role r
JOIN identity.role_assignment ra
  ON r.id = ra.role_id
JOIN identity."user" u
  ON ra.subject_id = u.user_id
LEFT JOIN identity.email e
  ON e.user_id = u.user_id
 AND e.primary_ind = 1
WHERE ($1::int IS NOT NULL OR $2::text IS NOT NULL)
  AND ra.subject_type = 1
  AND ($1::int IS NULL OR r.id = $1::int)
  AND ($2::text IS NULL OR LOWER(r.name) = LOWER($2::text));
