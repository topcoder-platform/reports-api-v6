-- Resolves a campus program group by name (or id / legacy id).
-- $1 = group name (case insensitive)
WITH params AS (
  SELECT LOWER(BTRIM($1)) AS group_key
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
)
SELECT
  rg.id AS "groupId",
  rg.name AS "groupName",
  rg."oldId" AS "groupOldId",
  rg."privateGroup" AS "privateGroup"
FROM root_group AS rg;
