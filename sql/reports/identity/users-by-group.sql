SELECT
  DISTINCT u.user_id AS "userId",
  u.handle AS "handle",
  e.address AS "email"
FROM groups."Group" g
JOIN groups."GroupMember" gm
  ON g.id = gm."groupId"
LEFT JOIN groups."User" gu
  ON gu.id = gm."memberId"
JOIN identity."user" u
  ON u.user_id::text = (
    CASE
      WHEN gm."memberId" ~ '^[0-9]+$' THEN gm."memberId"
      WHEN gu."universalUID" ~ '^[0-9]+$' THEN gu."universalUID"
      ELSE NULL
    END
  )
LEFT JOIN identity.email e
  ON e.user_id = u.user_id
 AND e.primary_ind = 1
WHERE ($1::text IS NOT NULL OR $2::text IS NOT NULL)
  AND gm."membershipType" = 'user'
  AND g.status = 'active'
  AND (
    $1::text IS NULL
    OR g.id = $1::text
    OR g."oldId" = $1::text
  )
  AND (
    $2::text IS NULL
    OR LOWER(g.name) = LOWER($2::text)
    OR LOWER(COALESCE(g.description, '')) = LOWER($2::text)
  );
