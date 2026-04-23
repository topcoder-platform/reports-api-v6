WITH input_handles AS (
  SELECT
    handle_input,
    ordinality
  FROM unnest($1::text[]) WITH ORDINALITY AS t(handle_input, ordinality)
)
SELECT
  ih.handle_input AS "handle",
  u.user_id AS "userId",
  NULLIF(TRIM(mem."firstName"), '') AS "firstName",
  NULLIF(TRIM(mem."lastName"), '') AS "lastName",
  NULLIF(TRIM(ph.phone_number::text), '') AS "contactNumber",
  pe.address AS "email",
  COALESCE(
    NULLIF(BTRIM(mem."competitionCountryCode"), ''),
    NULLIF(BTRIM(mem."homeCountryCode"), '')
  ) AS "country"
FROM input_handles AS ih
LEFT JOIN identity."user" AS u
  ON LOWER(u.handle) = LOWER(ih.handle_input)
LEFT JOIN LATERAL (
  SELECT e.address
  FROM identity.email AS e
  WHERE e.user_id = u.user_id
    AND NULLIF(BTRIM(e.address), '') IS NOT NULL
  ORDER BY COALESCE(e.primary_ind, 0) DESC, e.email_id ASC
  LIMIT 1
) AS pe
  ON TRUE
LEFT JOIN LATERAL (
  SELECT p."number" AS phone_number
  FROM members."memberPhone" AS p
  WHERE p."userId" = u.user_id
    AND NULLIF(TRIM(p."number"::text), '') IS NOT NULL
  ORDER BY
    (p."type" = 'HOME') DESC,
    p."createdAt" DESC NULLS LAST,
    p."id" ASC
  LIMIT 1
) AS ph
  ON TRUE
LEFT JOIN members."member" AS mem
  ON mem."userId" = u.user_id
ORDER BY ih.ordinality;
