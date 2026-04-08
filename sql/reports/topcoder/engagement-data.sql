WITH assignment_members AS (
  SELECT
    NULLIF(BTRIM(a."memberId"), '') AS member_id,
    NULLIF(BTRIM(a."memberHandle"), '') AS fallback_handle,
    NULLIF(BTRIM(e."projectId"), '') AS project_id
  FROM "EngagementAssignment" a
  JOIN "Engagement" e
    ON e.id = a."engagementId"
  WHERE NULLIF(BTRIM(a."memberId"), '') IS NOT NULL
),
assigned_summary AS (
  SELECT
    member_id,
    MAX(fallback_handle) AS fallback_handle,
    ARRAY_REMOVE(ARRAY_AGG(DISTINCT project_id), NULL) AS assigned_project_ids
  FROM assignment_members
  GROUP BY member_id
),
ranked_public_applications AS (
  SELECT
    NULLIF(BTRIM(app."userId"), '') AS member_id,
    NULLIF(BTRIM(app.handle), '') AS application_handle,
    NULLIF(BTRIM(app.email), '') AS application_email,
    NULLIF(BTRIM(app.address), '') AS application_address,
    NULLIF(BTRIM(app."mobileNumber"), '') AS application_phone,
    NULLIF(BTRIM(app.name), '') AS application_name,
    ROW_NUMBER() OVER (
      PARTITION BY app."userId"
      ORDER BY app."updatedAt" DESC, app."createdAt" DESC, app.id DESC
    ) AS rn
  FROM "EngagementApplication" app
  JOIN "Engagement" e
    ON e.id = app."engagementId"
  WHERE COALESCE(e."isPrivate", false) = false
    AND NULLIF(BTRIM(app."userId"), '') IS NOT NULL
),
latest_public_application AS (
  SELECT
    member_id,
    application_handle,
    application_email,
    application_address,
    application_phone,
    application_name
  FROM ranked_public_applications
  WHERE rn = 1
),
eligible_members AS (
  SELECT member_id
  FROM assigned_summary
  UNION
  SELECT member_id
  FROM latest_public_application
)
SELECT
  em.member_id,
  COALESCE(assigned_summary.fallback_handle, latest_public_application.application_handle)
    AS fallback_handle,
  latest_public_application.application_email,
  latest_public_application.application_address,
  latest_public_application.application_phone,
  latest_public_application.application_name,
  (assigned_summary.member_id IS NOT NULL) AS has_assignment,
  COALESCE(assigned_summary.assigned_project_ids, ARRAY[]::text[]) AS assigned_project_ids
FROM eligible_members em
LEFT JOIN assigned_summary
  ON assigned_summary.member_id = em.member_id
LEFT JOIN latest_public_application
  ON latest_public_application.member_id = em.member_id
ORDER BY COALESCE(
  assigned_summary.fallback_handle,
  latest_public_application.application_handle,
  em.member_id
);
