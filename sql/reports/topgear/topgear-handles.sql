-- INPUTS:
--   $1 :: timestamptz  -- startDate filter
SELECT
  m.handle AS "Handle",
  m."firstName" AS "First name",
  m."lastName" AS "Last name",
  m.email AS "Email address",
  m."userId" AS "User ID",
  u.create_date AS "User create date",
  sso.sso_user_id AS "SSO user ID",
  sso.sso_user_name AS "SSO user name",
  sso.email AS "SSO email"
FROM members.member m
JOIN identity."user" u
  ON u.user_id = m."userId"::numeric(10, 0)
 AND u.create_date >= $1::timestamptz
LEFT JOIN LATERAL (
  SELECT
    usl.sso_user_id,
    usl.sso_user_name,
    usl.email
  FROM identity.user_sso_login usl
  WHERE usl.user_id = m."userId"::numeric(10, 0)
  ORDER BY
    (usl.email ILIKE '%@wipro.com') DESC,
    usl.provider_id
  LIMIT 1
) sso ON TRUE
WHERE m.email ILIKE '%@wipro.com'
ORDER BY u.create_date DESC NULLS LAST, m.handle;
