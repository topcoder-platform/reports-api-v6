WITH development_submissions_ranked AS (
  SELECT
    s."memberId"::bigint AS member_id,
    s."challengeId"      AS challenge_id,
    s."submittedDate"    AS submitted_date,
    ROW_NUMBER() OVER (
      PARTITION BY s."memberId"
      ORDER BY s."submittedDate" ASC, s."challengeId" ASC
    )                    AS submission_rank
  FROM reviews.submission s
  JOIN challenges."Challenge" c
    ON c.id = s."challengeId"
  JOIN challenges."ChallengeTrack" tr
    ON tr.id = c."trackId"
  WHERE tr.abbreviation = 'DS'
),
development_first_submissions AS (
  SELECT
    member_id,
    challenge_id,
    submitted_date
  FROM development_submissions_ranked
  WHERE submission_rank = 1
)
SELECT
  m.handle                                         AS "user.handle",
  c.name                                           AS "challenge.challenge_name",
  dfs.submitted_date::date                         AS "newest_submitters.submit_date_date",
  max_rating.rating                                AS "submitter_profile.max_rating"
FROM development_first_submissions dfs
JOIN members.member m
  ON m."userId" = dfs.member_id
JOIN challenges."Challenge" c
  ON c.id = dfs.challenge_id
LEFT JOIN LATERAL (
  SELECT
    mmr.rating
  FROM members."memberMaxRating" mmr
  WHERE mmr."userId" = dfs.member_id
  ORDER BY mmr.rating DESC NULLS LAST
  LIMIT 1
) max_rating
  ON TRUE
WHERE dfs.submitted_date >= NOW() - INTERVAL '3 months'
ORDER BY "newest_submitters.submit_date_date" DESC, "user.handle" ASC;
