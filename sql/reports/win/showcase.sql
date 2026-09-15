-- $1: optional project ID, $2: page size, $3: offset.
-- Use current project details so edits from either Work form remain synchronized.
WITH eligible AS (
  SELECT post.*, project.name AS "projectTitle", project.details,
    to_jsonb(project) || jsonb_build_object(
      'id', project.id::text,
      'directProjectId', project."directProjectId"::text,
      'billingAccountId', project."billingAccountId"::text
    ) AS "projectMetadata"
  FROM projects.project_showcase_posts post
  JOIN projects.projects project ON project.id = post."projectId"
  WHERE post."sendToWin" = true
    AND post.status <> 'ARCHIVED'
    AND project."deletedAt" IS NULL
    AND ($1::bigint IS NULL OR post."projectId" = $1::bigint)
), page AS (
  SELECT * FROM eligible ORDER BY id LIMIT $2 OFFSET $3
), payload AS (
  SELECT post.id, (to_jsonb(post) - 'details' - 'projectMetadata') || jsonb_build_object(
    'id', post.id::text,
    'projectId', post."projectId"::text,
    'customer', post.details->>'customer',
    'smu', post.details->>'smu',
    'smuOther', post.details->>'smuOther',
    'dealCloseDate', post.details->>'dealCloseDate',
    'project', post."projectMetadata",
    'challengeMetadata', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'challengeId', challenge.id,
        'name', challenge.name,
        'numOfSubmissions', challenge."numOfSubmissions",
        'numOfRegistrants', challenge."numOfRegistrants",
        'track', COALESCE(track.name, ''),
        'skills', COALESCE((
          SELECT jsonb_agg(jsonb_build_object('id', linked_skill."skillId", 'name', COALESCE(skill.name, ''))
            ORDER BY linked_skill."skillId")
          FROM challenges."ChallengeSkill" linked_skill
          LEFT JOIN skills.skill skill ON skill.id::text = linked_skill."skillId"
          WHERE linked_skill."challengeId" = challenge.id
        ), '[]'::jsonb),
        'countries', COALESCE((
          SELECT jsonb_agg(country ORDER BY country)
          FROM (
            SELECT DISTINCT COALESCE(NULLIF(member."competitionCountryCode", ''),
              NULLIF(member.country, ''), NULLIF(member."homeCountryCode", '')) AS country
            FROM resources."Resource" resource
            JOIN resources."ResourceRole" role ON role.id = resource."roleId" AND role.name = 'Submitter'
            JOIN members.member member ON member."userId"::text = resource."memberId"
            WHERE resource."challengeId" = challenge.id
          ) countries WHERE country IS NOT NULL
        ), '[]'::jsonb)
      ) ORDER BY challenge.id)
      FROM challenges."Challenge" challenge
      LEFT JOIN challenges."ChallengeTrack" track ON track.id = challenge."trackId"
      WHERE challenge.id = ANY(post."challengeIds")
    ), '[]'::jsonb),
    'industries', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', industry.id::text, 'name', industry.name) ORDER BY industry.id)
      FROM projects.project_showcase_post_industries link
      JOIN projects.project_post_industries industry ON industry.id = link."industryId"
      WHERE link."projectShowcasePostId" = post.id
    ), '[]'::jsonb),
    'categories', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', category.id::text, 'name', category.name) ORDER BY category.id)
      FROM projects.project_showcase_post_categories link
      JOIN projects.project_post_categories category ON category.id = link."categoryId"
      WHERE link."projectShowcasePostId" = post.id
    ), '[]'::jsonb),
    'media', COALESCE((
      SELECT jsonb_agg(to_jsonb(media) || jsonb_build_object(
        'id', media.id::text, 'projectShowcasePostId', media."projectShowcasePostId"::text,
        'createdBy', media."createdBy"::text
      ) ORDER BY media.id)
      FROM projects.project_showcase_post_media media
      WHERE media."projectShowcasePostId" = post.id
    ), '[]'::jsonb)
  ) AS data
  FROM page post
)
SELECT COALESCE(jsonb_agg(payload.data ORDER BY payload.id), '[]'::jsonb) AS data,
  (SELECT count(*)::integer FROM eligible) AS total
FROM payload;
