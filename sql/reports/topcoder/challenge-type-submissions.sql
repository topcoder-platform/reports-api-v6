WITH typed_challenges AS (
  SELECT
    c.id,
    c.name
  FROM challenges."Challenge" AS c
  WHERE c."typeId" = '929bc408-9cf2-4b3e-ba71-adfbf693046c'
),
submission_participants AS (
  SELECT DISTINCT ON (s."memberId", tc.id)
    s."memberId"::bigint AS member_id,
    COALESCE(NULLIF(TRIM(m.handle), ''), m.handle) AS member_handle,
    tc.id AS challenge_id,
    s.placement
  FROM typed_challenges AS tc
  JOIN reviews."submission" AS s
    ON s."challengeId" = tc.id
  LEFT JOIN members."member" AS m
    ON m."userId" = s."memberId"::bigint
  ORDER BY
    s."memberId",
    tc.id,
    s.placement NULLS FIRST,
    s.id DESC
),
winner_participants AS (
  SELECT DISTINCT ON (cw."userId", tc.id)
    cw."userId"::bigint AS member_id,
    COALESCE(
      NULLIF(TRIM(cw.handle), ''),
      NULLIF(TRIM(m.handle), ''),
      m.handle
    ) AS member_handle,
    tc.id AS challenge_id,
    cw.placement
  FROM typed_challenges AS tc
  JOIN challenges."ChallengeWinner" AS cw
    ON cw."challengeId" = tc.id
  LEFT JOIN members."member" AS m
    ON m."userId" = cw."userId"::bigint
  ORDER BY
    cw."userId",
    tc.id,
    cw.placement NULLS FIRST,
    cw.id DESC
),
combined_participants AS (
  SELECT
    COALESCE(wp.member_id, sp.member_id) AS member_id,
    COALESCE(wp.member_handle, sp.member_handle) AS member_handle,
    COALESCE(wp.challenge_id, sp.challenge_id) AS challenge_id,
    COALESCE(wp.placement, sp.placement) AS placement
  FROM submission_participants AS sp
  FULL OUTER JOIN winner_participants AS wp
    ON wp.member_id = sp.member_id
   AND wp.challenge_id = sp.challenge_id
)
SELECT
  cp.member_id AS "memberId",
  cp.member_handle AS "memberHandle",
  COUNT(*)::int AS "uniqueChallengesSubmitted",
  COUNT(*) FILTER (WHERE cp.placement = 1)::int AS "placementsOfOne",
  COUNT(*) FILTER (WHERE cp.placement BETWEEN 1 AND 5)::int AS "placementsOneThroughFive"
FROM combined_participants AS cp
GROUP BY
  cp.member_id,
  cp.member_handle
ORDER BY
  "uniqueChallengesSubmitted" DESC,
  "memberHandle" ASC;
