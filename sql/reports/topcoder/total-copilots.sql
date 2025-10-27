SELECT
    COUNT(DISTINCT gm.id) AS "group_membership.count"
FROM groups."GroupMember" AS gm
INNER JOIN groups."Group" AS g
    ON g.id = gm."groupId"
WHERE g.name = 'Copilots';
