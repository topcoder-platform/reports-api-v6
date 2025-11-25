SELECT
  u.handle,
  u.user_id::text AS "userId",
  (v.verification_status = 'ACTIVE') AS verified,
  CASE
    WHEN v.verification_status = 'ACTIVE' THEN 'Verified'
    ELSE 'Unverified'
  END AS "verificationStatus"
FROM identity."user" u
LEFT JOIN LATERAL (
  SELECT verification_status
  FROM finance.user_identity_verification_associations uiva
  WHERE uiva.user_id = u.user_id::text
  ORDER BY uiva.date_filed DESC
  LIMIT 1
) v ON true
WHERE
  LOWER(u.handle) = ANY($1::text[])
ORDER BY u.handle;
