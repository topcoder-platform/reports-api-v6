SELECT
  m."userId"::text AS user_id,
  NULLIF(BTRIM(m.handle), '') AS handle,
  NULLIF(BTRIM(m."firstName"), '') AS first_name,
  NULLIF(BTRIM(m."lastName"), '') AS last_name,
  NULLIF(BTRIM(m.email), '') AS email,
  COALESCE(NULLIF(BTRIM(c.country_name), ''), NULLIF(BTRIM(m.country), ''))
    AS country,
  preferred_address.street_addr_1,
  preferred_address.street_addr_2,
  preferred_address.city,
  preferred_address.state_code,
  preferred_address.zip,
  preferred_phone.phone_number
FROM members.member m
LEFT JOIN identity.country c
  ON c.country_code = m."homeCountryCode"
LEFT JOIN LATERAL (
  SELECT
    NULLIF(BTRIM(a."streetAddr1"), '') AS street_addr_1,
    NULLIF(BTRIM(a."streetAddr2"), '') AS street_addr_2,
    NULLIF(BTRIM(a.city), '') AS city,
    NULLIF(BTRIM(a."stateCode"), '') AS state_code,
    NULLIF(BTRIM(a.zip), '') AS zip
  FROM members."memberAddress" a
  WHERE a."userId" = m."userId"
  ORDER BY
    CASE
      WHEN UPPER(a.type) = 'HOME' THEN 0
      WHEN UPPER(a.type) = 'BILLING' THEN 1
      ELSE 2
    END,
    a."updatedAt" DESC NULLS LAST,
    a."createdAt" DESC NULLS LAST,
    a.id DESC
  LIMIT 1
) preferred_address
  ON TRUE
LEFT JOIN LATERAL (
  SELECT NULLIF(BTRIM(p.number), '') AS phone_number
  FROM members."memberPhone" p
  WHERE p."userId" = m."userId"
    AND NULLIF(BTRIM(p.number), '') IS NOT NULL
  ORDER BY
    CASE
      WHEN POSITION('mobile' IN LOWER(p.type)) > 0 THEN 0
      ELSE 1
    END,
    p."updatedAt" DESC NULLS LAST,
    p."createdAt" DESC NULLS LAST,
    p.id ASC
  LIMIT 1
) preferred_phone
  ON TRUE
WHERE m."userId"::text = ANY($1::text[])
ORDER BY LOWER(m.handle), m."userId";
