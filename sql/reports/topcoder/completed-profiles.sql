-- Query to return members with completed profiles
-- A profile is considered complete if it has:
-- - description (bio)
-- - profile photo
-- - at least 3 skills
-- - gig availability set (true or false)
-- - at least one work history entry
-- - at least one education entry
-- - at least one location (address)

WITH member_skills AS (
  SELECT
    us.user_id,
    COUNT(*) AS skill_count
  FROM skills.user_skill us
  GROUP BY us.user_id
),
member_work_history AS (
  SELECT DISTINCT
    mt."userId"
  FROM members."memberTraits" mt
  JOIN members."memberTraitWork" mw
    ON mw."memberTraitId" = mt.id
),
member_education AS (
  SELECT DISTINCT
    mt."userId"
  FROM members."memberTraits" mt
  JOIN members."memberTraitEducation" me
    ON me."memberTraitId" = mt.id
),
member_location AS (
  SELECT DISTINCT
    ma."userId"
  FROM members."memberAddress" ma
),
completed_profiles AS (
  SELECT
    m."userId",
    m.handle,
    COALESCE(m."homeCountryCode", m."competitionCountryCode") AS "countryCode",
    m.country AS "countryName",
    m.email
  FROM members.member m
  LEFT JOIN member_skills ms ON ms.user_id = m."userId"
  LEFT JOIN member_work_history mwh ON mwh."userId" = m."userId"
  LEFT JOIN member_education me ON me."userId" = m."userId"
  LEFT JOIN member_location ml ON ml."userId" = m."userId"
  WHERE m.description IS NOT NULL
    AND m.description <> ''
    AND m."photoURL" IS NOT NULL
    AND m."photoURL" <> ''
    AND m."availableForGigs" IS NOT NULL
    AND COALESCE(ms.skill_count, 0) >= 3
    AND mwh."userId" IS NOT NULL
    AND me."userId" IS NOT NULL
    AND ml."userId" IS NOT NULL
    AND ($1::text IS NULL OR COALESCE(m."homeCountryCode", m."competitionCountryCode") = $1)
)
SELECT
  cp."userId" AS "userId",
  cp.handle,
  cp."countryCode",
  cp."countryName"
FROM completed_profiles cp
ORDER BY cp.handle;
