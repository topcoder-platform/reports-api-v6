-- Query to return members with completed profiles
-- A profile is considered complete if it has:
-- - description (bio)
-- - profile photo
-- - at least 3 skills
-- - engagement availability (personalization trait with openToWork, availability boolean, and preferredRoles array)
-- - at least one work history entry
-- - at least one education entry
-- - at least one location (city in address AND homeCountryCode)

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
member_engagement_availability AS (
  SELECT DISTINCT
    mt."userId"
  FROM members."memberTraits" mt
  JOIN members."memberTraitPersonalization" mtp
    ON mtp."memberTraitId" = mt.id
  WHERE mtp.key = 'openToWork'
    AND mtp.value IS NOT NULL
    AND (
      NOT (mtp.value::jsonb ? 'availability')
      OR (
        mtp.value::jsonb ? 'availability'
        AND mtp.value::jsonb ? 'preferredRoles'
        AND jsonb_array_length(mtp.value::jsonb -> 'preferredRoles') > 0
      )
    )
),
member_location AS (
  SELECT DISTINCT
    ma."userId"
  FROM members."memberAddress" ma
  WHERE ma.city IS NOT NULL
    AND TRIM(ma.city) <> ''
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
  LEFT JOIN member_engagement_availability mea ON mea."userId" = m."userId"
  LEFT JOIN member_location ml ON ml."userId" = m."userId"
  WHERE m.description IS NOT NULL
    AND m.description <> ''
    AND m."photoURL" IS NOT NULL
    AND m."photoURL" <> ''
    AND m."homeCountryCode" IS NOT NULL
    AND COALESCE(ms.skill_count, 0) >= 3
    AND mwh."userId" IS NOT NULL
    AND me."userId" IS NOT NULL
    AND mea."userId" IS NOT NULL
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
