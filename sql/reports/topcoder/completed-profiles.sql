-- A profile is considered complete if it has:
-- - description (bio)
-- - profile photo
-- - at least 3 skills
-- - engagement availability (personalization trait with openToWork, availability boolean, and preferredRoles array)
-- - at least one work history entry
-- - at least one education entry
-- - at least one location (city in address AND homeCountryCode)
--
-- totalCount is computed via COUNT(*) OVER() across all qualifying rows before
-- LIMIT/OFFSET, so callers don't need a separate count query.

WITH member_skills AS (
  SELECT
    us.user_id,
    COUNT(*) AS skill_count,
    ARRAY_AGG(DISTINCT us.skill_id::uuid) AS skill_ids
  FROM skills.user_skill us
  GROUP BY us.user_id
  HAVING COUNT(*) >= 3  -- Filter early to reduce dataset
),
qualified AS (
  SELECT
    m."userId",
    m.handle,
    m."firstName",
    m."lastName",
    m."photoURL",
    COALESCE(m."homeCountryCode", m."competitionCountryCode") AS "countryCode",
    m.country AS "countryName",
    m."availableForGigs" AS "isOpenToWork",
    ot.open_to_work_value AS "openToWork",
    ms.skill_count AS "skillCount",
    COUNT(*) OVER() AS "totalCount"
  FROM members.member m
  INNER JOIN member_skills ms ON ms.user_id = m."userId"
  LEFT JOIN LATERAL (
    SELECT
      mtp.value AS open_to_work_value
    FROM members."memberTraits" mt
    INNER JOIN members."memberTraitPersonalization" mtp ON mtp."memberTraitId" = mt.id
    WHERE mt."userId" = m."userId"
      AND mtp.key = 'openToWork'
    ORDER BY mt."updatedAt" DESC
    LIMIT 1
  ) ot ON TRUE
  WHERE m.description IS NOT NULL
    AND m.description <> ''
    AND m."homeCountryCode" IS NOT NULL
    AND ($1::text IS NULL OR COALESCE(m."homeCountryCode", m."competitionCountryCode") = $1)
    AND ($5::uuid[] IS NULL OR ms.skill_ids @> $5::uuid[])
    AND (
      $2::boolean IS NULL
      OR m."availableForGigs" = $2::boolean
    )
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
    AND ot.open_to_work_value IS NOT NULL
    AND (
      NOT (ot.open_to_work_value::jsonb ? 'availability')
      OR (
        ot.open_to_work_value::jsonb ? 'availability'
        AND ot.open_to_work_value::jsonb ? 'preferredRoles'
        AND jsonb_array_length(ot.open_to_work_value::jsonb -> 'preferredRoles') > 0
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
)
SELECT
  q."userId",
  q.handle,
  q."firstName",
  q."lastName",
  q."photoURL",
  q."countryCode",
  q."countryName",
  q."isOpenToWork",
  q."openToWork",
  q."skillCount",
  q."totalCount",
  ma.city
FROM qualified q
LEFT JOIN LATERAL (
  SELECT
    ma.city
  FROM members."memberAddress" ma
  WHERE ma."userId" = q."userId"
    AND ma.city IS NOT NULL
    AND TRIM(ma.city) <> ''
  ORDER BY ma.id ASC
  LIMIT 1
) ma ON TRUE
ORDER BY q.handle
LIMIT $3::int
OFFSET $4::int;

