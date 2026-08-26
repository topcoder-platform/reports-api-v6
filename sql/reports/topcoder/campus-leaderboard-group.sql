-- Resolves a campus program group by name (or id / legacy id) and reports whether
-- the caller ($2, an optional user id) belongs to it, directly or via a sub-group.
-- $1 = group name (case insensitive), $2 = caller user id (nullable)
WITH RECURSIVE params AS (
  SELECT
    LOWER(BTRIM($1)) AS group_key,
    NULLIF(BTRIM(COALESCE($2, '')), '') AS caller_id
),
root_group AS (
  SELECT
    g.id,
    g.name,
    g."oldId",
    g."privateGroup"
  FROM groups."Group" AS g
  CROSS JOIN params AS p
  WHERE LOWER(g.name) = p.group_key
     OR LOWER(g.id) = p.group_key
     OR LOWER(COALESCE(g."oldId", '')) = p.group_key
  ORDER BY (LOWER(g.name) = p.group_key) DESC, g."createdAt" ASC
  LIMIT 1
),
group_tree AS (
  SELECT rg.id
  FROM root_group AS rg
  UNION
  SELECT gm."memberId"
  FROM groups."GroupMember" AS gm
  JOIN group_tree AS gt
    ON gt.id = gm."groupId"
  WHERE LOWER(gm."membershipType") = 'group'
)
SELECT
  rg.id AS "groupId",
  rg.name AS "groupName",
  rg."oldId" AS "groupOldId",
  rg."privateGroup" AS "privateGroup",
  EXISTS (
    SELECT 1
    FROM groups."GroupMember" AS gm
    JOIN group_tree AS gt
      ON gt.id = gm."groupId"
    CROSS JOIN params AS p
    WHERE LOWER(gm."membershipType") = 'user'
      AND p.caller_id IS NOT NULL
      AND gm."memberId" = p.caller_id
  ) AS "callerIsMember"
FROM root_group AS rg;
