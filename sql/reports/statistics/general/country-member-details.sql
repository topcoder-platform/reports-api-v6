WITH member_profiles AS (
  SELECT
    m."userId" AS user_id,
    COALESCE(
      NULLIF(TRIM(m."competitionCountryCode"), ''),
      NULLIF(TRIM(m."homeCountryCode"), '')
    ) AS country_code,
    m.handle,
    m."photoURL" AS photo_url
  FROM members.member m
),
country_members AS (
  SELECT
    country_code,
    COUNT(*)::bigint AS members_count
  FROM member_profiles
  WHERE country_code IS NOT NULL
  GROUP BY country_code
),
country_member_skills AS (
  SELECT DISTINCT
    members.country_code,
    members.user_id,
    skill.id AS skill_id,
    skill.name
  FROM member_profiles members
  JOIN skills.user_skill user_skill
    ON user_skill.user_id::bigint = members.user_id
  JOIN skills.user_skill_level skill_level
    ON skill_level.id = user_skill.user_skill_level_id
   AND LOWER(skill_level.name) IN ('verified', 'self-declared')
  JOIN skills.skill skill
    ON skill.id = user_skill.skill_id
   AND skill.deleted_at IS NULL
  WHERE members.country_code IS NOT NULL
),
country_skill_counts AS (
  SELECT
    owned.country_code,
    owned.skill_id,
    owned.name,
    COUNT(*)::bigint AS owned_count
  FROM country_member_skills owned
  GROUP BY owned.country_code, owned.skill_id, owned.name
),
country_skills AS (
  SELECT
    country_code,
    JSONB_AGG(
      JSONB_BUILD_OBJECT(
        'name', name,
        'count', owned_count,
        'ownedCount', owned_count
      )
      ORDER BY owned_count DESC, name ASC, skill_id ASC
    ) AS skills
  FROM country_skill_counts
  GROUP BY country_code
),
history_wins AS (
  SELECT
    history."userId",
    history."trackId",
    history."typeId",
    COUNT(*)::bigint AS wins
  FROM members."memberStatsHistory" history
  WHERE history.placement = 1
  GROUP BY history."userId", history."trackId", history."typeId"
),
stats_wins AS (
  SELECT
    stats."userId",
    SUM(COALESCE(stats.wins, history.wins, 0))::bigint AS wins
  FROM members."memberStats" stats
  LEFT JOIN history_wins history
    ON history."userId" = stats."userId"
   AND history."trackId" = stats."trackId"
   AND history."typeId" = stats."typeId"
  LEFT JOIN challenges."ChallengeTrack" track
    ON track.id::text = stats."trackId"
  WHERE stats."isPrivate" = false
    AND (
      UPPER(COALESCE(track.name, stats."trackId")) LIKE '%DEVELOP%'
      OR UPPER(COALESCE(track.name, stats."trackId")) LIKE '%DESIGN%'
      OR UPPER(COALESCE(track.name, stats."trackId")) LIKE '%DATA%SCIENCE%'
      OR UPPER(COALESCE(track.name, stats."trackId")) = 'QA'
      OR UPPER(COALESCE(track.name, stats."trackId")) LIKE '%QUALITY%ASSURANCE%'
      OR UPPER(COALESCE(track.name, stats."trackId")) LIKE '%COPILOT%'
    )
  GROUP BY stats."userId"
),
winner_counts AS (
  SELECT
    members.country_code,
    members.user_id,
    members.handle,
    members.photo_url,
    rating.rating AS max_rating,
    wins.wins
  FROM stats_wins wins
  JOIN member_profiles members
    ON members.user_id = wins."userId"
  LEFT JOIN members."memberMaxRating" rating
    ON rating."userId" = members.user_id
  WHERE members.country_code IS NOT NULL
    AND NULLIF(TRIM(members.handle), '') IS NOT NULL
    AND wins.wins > 0
),
ranked_members AS (
  SELECT
    winner_counts.*,
    ROW_NUMBER() OVER (
      PARTITION BY country_code
      ORDER BY wins DESC, handle ASC, user_id ASC
    ) AS member_rank
  FROM winner_counts
),
top_members AS (
  SELECT
    country_code,
    JSONB_AGG(
      JSONB_BUILD_OBJECT(
        'handle', handle,
        'wins', wins,
        'photoURL', photo_url,
        'maxRating', max_rating
      )
      ORDER BY member_rank
    ) FILTER (WHERE member_rank <= 3) AS top_members
  FROM ranked_members
  GROUP BY country_code
)
SELECT
  countries.country_code,
  countries.members_count AS "user.count",
  COALESCE(skills.skills, '[]'::jsonb) AS skills,
  COALESCE(members.top_members, '[]'::jsonb) AS top_members
FROM country_members countries
LEFT JOIN country_skills skills
  ON skills.country_code = countries.country_code
LEFT JOIN top_members members
  ON members.country_code = countries.country_code
ORDER BY "user.count" DESC, country_code ASC;
