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
  HAVING COUNT(*) >= 3  -- Filter early to reduce dataset
)
SELECT
  m."userId" AS "userId",
  m.handle,
  COALESCE(m."homeCountryCode", m."competitionCountryCode") AS "countryCode",
  m.country AS "countryName",
  (
    SELECT mtp.value
    FROM members."memberTraits" mt
    INNER JOIN members."memberTraitPersonalization" mtp ON mtp."memberTraitId" = mt.id
    WHERE mt."userId" = m."userId"
      AND mtp.key = 'openToWork'
    LIMIT 1
  ) AS "openToWork"
FROM members.member m
INNER JOIN member_skills ms ON ms.user_id = m."userId"
WHERE m.description IS NOT NULL
  AND m.description <> ''
  AND m."photoURL" IS NOT NULL
  AND m."photoURL" <> ''
  AND m."homeCountryCode" IS NOT NULL
  AND ($1::text IS NULL OR COALESCE(m."homeCountryCode", m."competitionCountryCode") = $1)
  -- Check work history exists
  AND EXISTS (
    SELECT 1
    FROM members."memberTraits" mt
    INNER JOIN members."memberTraitWork" mw ON mw."memberTraitId" = mt.id
    WHERE mt."userId" = m."userId"
  )
  -- Check education exists
  AND EXISTS (
    SELECT 1
    FROM members."memberTraits" mt
    INNER JOIN members."memberTraitEducation" me ON me."memberTraitId" = mt.id
    WHERE mt."userId" = m."userId"
  )
  -- Check engagement availability exists
  AND EXISTS (
    SELECT 1
    FROM members."memberTraits" mt
    INNER JOIN members."memberTraitPersonalization" mtp ON mtp."memberTraitId" = mt.id
    WHERE mt."userId" = m."userId"
      AND mtp.key = 'openToWork'
      AND mtp.value IS NOT NULL
      AND (
        NOT (mtp.value::jsonb ? 'availability')
        OR (
          mtp.value::jsonb ? 'availability'
          AND mtp.value::jsonb ? 'preferredRoles'
          AND jsonb_array_length(mtp.value::jsonb -> 'preferredRoles') > 0
        )
      )
  )
  -- Check location exists
  AND EXISTS (
    SELECT 1
    FROM members."memberAddress" ma
    WHERE ma."userId" = m."userId"
      AND ma.city IS NOT NULL
      AND TRIM(ma.city) <> ''
  )
ORDER BY m.handle;
