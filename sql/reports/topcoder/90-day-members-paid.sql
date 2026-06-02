SELECT
  COUNT(DISTINCT w.winner_id) AS "payee.count"
FROM finance.payment AS p
INNER JOIN finance.winnings AS w
  ON w.winning_id = p.winnings_id
LEFT JOIN challenges."Challenge" AS c
  ON c.id = w.external_id
LEFT JOIN projects.projects AS proj
  ON proj.id = c."projectId"::bigint
WHERE (p.payment_status IS NULL OR p.payment_status != 'CANCELLED')
  AND p.created_at >= (DATE_TRUNC('day', CURRENT_TIMESTAMP) - INTERVAL '89 days')
  AND p.created_at < (DATE_TRUNC('day', CURRENT_TIMESTAMP) + INTERVAL '1 day')
  AND NOT EXISTS (
    SELECT 1
    FROM unnest(COALESCE(c.groups, ARRAY[]::text[])) AS group_ref(group_id)
    INNER JOIN groups."Group" AS g
      ON g.id = group_ref.group_id
    WHERE g.name ILIKE 'Wipro%'
  )
  AND (
    (
      proj.name NOT ILIKE 'Fun & Learning Challenges (Jaipur)'
      AND proj.name NOT ILIKE 'Fun & Learning - 2016 (Jaipur)'
      AND proj.name NOT ILIKE 'TopGear Trial'
    )
    OR proj.name IS NULL
  );
