WITH category_wins AS (
  SELECT
    se.user_id,
    COUNT(*)::int AS wins
  FROM skills.skill_event se
  JOIN skills.skill sk
    ON sk.id = se.skill_id
   AND sk.deleted_at IS NULL
  JOIN skills.skill_event_type set_t
    ON set_t.id = se.skill_event_type_id
  JOIN skills.source_type sest
    ON sest.id = se.source_type_id
  WHERE sk.category_id = $1::uuid
    AND NOT (se.user_id::text = ANY($3))
    AND (
      LOWER(set_t.name) IN (
        'challenge_win',
        'challenge_2nd_place',
        'challenge_3rd_place',
        'gig_completion'
      )
      OR sest.name = 'engagement'
    )
  GROUP BY se.user_id
)
SELECT
  m.handle,
  m."firstName" AS "firstName",
  m."lastName" AS "lastName",
  m."photoURL" AS "photoUrl",
  COALESCE(m."homeCountryCode", m."competitionCountryCode", m.country, '') AS "countryCode",
  COALESCE(mr.rating, 0) AS rating,
  cw.wins
FROM category_wins cw
JOIN members.member m
  ON m."userId" = cw.user_id
 AND m.status = 'ACTIVE'
LEFT JOIN LATERAL (
  SELECT rating
  FROM members."memberMaxRating" mmr
  WHERE mmr."userId" = m."userId"
  ORDER BY mmr.rating DESC NULLS LAST
  LIMIT 1
) mr ON TRUE
ORDER BY cw.wins DESC, m.handle ASC
LIMIT $2;
