SELECT
  u.user_id AS "userId",
  u.handle AS "handle",
  e.address AS "email"
FROM identity.security_groups sg
JOIN identity.user_group_xref ugx
  ON sg.group_id = ugx.group_id
JOIN identity.security_user su
  ON ugx.login_id = su.login_id
JOIN identity."user" u
  ON su.user_id ~ '^[0-9]+$'
 AND su.user_id::numeric = u.user_id
LEFT JOIN identity.email e
  ON e.user_id = u.user_id
 AND e.primary_ind = 1
WHERE ($1::numeric IS NOT NULL OR $2::text IS NOT NULL)
  AND ($1::numeric IS NULL OR sg.group_id = $1::numeric)
  AND ($2::text IS NULL OR LOWER(sg.description) = LOWER($2::text));
