WITH requested_categories AS (
  SELECT DISTINCT id
  FROM unnest($1::uuid[]) AS t(id)
),
skill_counts AS (
  SELECT
    sk.category_id,
    COUNT(*)::int AS total_skills
  FROM skills.skill sk
  WHERE sk.deleted_at IS NULL
    AND sk.category_id = ANY($1::uuid[])
  GROUP BY sk.category_id
),
member_counts AS (
  SELECT
    sk.category_id,
    COUNT(DISTINCT us.user_id)::int AS total_members
  FROM skills.user_skill us
  JOIN skills.skill sk
    ON sk.id = us.skill_id
   AND sk.deleted_at IS NULL
  WHERE sk.category_id = ANY($1::uuid[])
    AND NOT (us.user_id::text = ANY($2))
  GROUP BY sk.category_id
),
win_events AS (
  SELECT
    sk.category_id,
    sk.id AS skill_id,
    sk.name AS skill_name,
    se.user_id
  FROM skills.skill_event se
  JOIN skills.skill sk
    ON sk.id = se.skill_id
   AND sk.deleted_at IS NULL
  JOIN skills.skill_event_type set_t
    ON set_t.id = se.skill_event_type_id
  JOIN skills.source_type sest
    ON sest.id = se.source_type_id
  WHERE sk.category_id = ANY($1::uuid[])
    AND NOT (se.user_id::text = ANY($2))
    AND (
      LOWER(set_t.name) IN (
        'challenge_win',
        'challenge_2nd_place',
        'challenge_3rd_place',
        'gig_completion'
      )
      OR sest.name = 'engagement'
    )
),
win_counts AS (
  SELECT
    category_id,
    COUNT(*)::int AS total_wins
  FROM win_events
  GROUP BY category_id
),
top_skills AS (
  SELECT
    category_id,
    skill_name AS name,
    COUNT(*)::int AS skill_wins,
    ROW_NUMBER() OVER (
      PARTITION BY category_id
      ORDER BY COUNT(*) DESC, skill_name ASC
    ) AS rn
  FROM win_events
  GROUP BY category_id, skill_id, skill_name
)
SELECT
  rc.id::text AS id,
  COALESCE(mc.total_members, 0) AS "totalMembers",
  COALESCE(sc.total_skills, 0) AS "totalSkills",
  COALESCE(wc.total_wins, 0) AS "totalWins",
  COALESCE(
    (
      SELECT jsonb_agg(
        jsonb_build_object(
          'name', ts.name,
          'percentage', CASE
            WHEN COALESCE(wc.total_wins, 0) = 0 THEN 0
            ELSE ROUND((ts.skill_wins::numeric / wc.total_wins::numeric) * 100)::int
          END
        )
        ORDER BY ts.rn
      )
      FROM top_skills ts
      WHERE ts.category_id = rc.id
        AND ts.rn <= 3
    ),
    '[]'::jsonb
  ) AS "skillsBreakdown"
FROM requested_categories rc
LEFT JOIN skill_counts sc ON sc.category_id = rc.id
LEFT JOIN member_counts mc ON mc.category_id = rc.id
LEFT JOIN win_counts wc ON wc.category_id = rc.id;
