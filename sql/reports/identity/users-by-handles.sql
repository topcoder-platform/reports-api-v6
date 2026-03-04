WITH input_handles AS (
  SELECT
    handle_input,
    ordinality
  FROM unnest($1::text[]) WITH ORDINALITY AS t(handle_input, ordinality)
)
SELECT
  ih.handle_input AS "handle",
  u.user_id AS "userId",
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
  FROM identity.user_email_xref AS uex
  INNER JOIN identity.email AS e
    ON e.email_id = uex.email_id
  WHERE uex.user_id = u.user_id
  ORDER BY uex.is_primary DESC, e.primary_ind DESC, e.email_id ASC
  LIMIT 1
) AS pe
  ON TRUE
LEFT JOIN members."member" AS mem
  ON mem."userId" = u.user_id
ORDER BY ih.ordinality;
