WITH skill_counts AS (
  SELECT
    s.name AS skill_name,
    COUNT(DISTINCT c.id)::bigint AS challenge_count
  FROM skills.work_skill ws
  JOIN skills.source_type st
    ON st.id = ws.work_type_id
  JOIN skills.skill s
    ON s.id = ws.skill_id
  JOIN challenges."Challenge" c
    ON c.id::text = ws.work_id::text
  JOIN challenges."ChallengeTrack" tr
    ON tr.id = c."trackId"
  LEFT JOIN challenges."ChallengeType" ct
    ON ct.id = c."typeId"
  WHERE st.name = 'challenge'
    AND tr.abbreviation = 'Dev'
    AND s.name IS NOT NULL
    AND s.deleted_at IS NULL
    AND COALESCE(ct."isTask", false) = false
    AND NOT EXISTS (
      SELECT 1
      FROM UNNEST(c.groups) AS gid(group_id)
      JOIN groups."Group" g
        ON g.id = gid.group_id
      WHERE g.name ILIKE '%wipro%'
         OR g.name ILIKE '%veterans%'
    )
  GROUP BY s.name
)
SELECT
  skill_name AS "challenge_technology.name",
  challenge_count AS "challenge_stats.count",
  DENSE_RANK() OVER (ORDER BY challenge_count DESC, skill_name ASC)::int AS rank
FROM skill_counts
ORDER BY "challenge_stats.count" DESC, "challenge_technology.name" ASC
LIMIT 100;
