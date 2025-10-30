SELECT DISTINCT
  res."memberHandle" AS handle,
  mem.email AS email,
  COALESCE(home_code.name, home_id.name, mem."homeCountryCode") AS home_country,
  COALESCE(comp_code.name, comp_id.name, mem."competitionCountryCode") AS competition_country
FROM resources."Resource" AS res
JOIN resources."ResourceRole" AS rr
  ON rr.id = res."roleId"
LEFT JOIN members."member" AS mem
  ON mem."userId"::text = res."memberId"
LEFT JOIN lookups."Country" AS home_code
  ON UPPER(home_code."countryCode") = UPPER(mem."homeCountryCode")
LEFT JOIN lookups."Country" AS home_id
  ON UPPER(home_id.id) = UPPER(mem."homeCountryCode")
LEFT JOIN lookups."Country" AS comp_code
  ON UPPER(comp_code."countryCode") = UPPER(mem."competitionCountryCode")
LEFT JOIN lookups."Country" AS comp_id
  ON UPPER(comp_id.id) = UPPER(mem."competitionCountryCode")
WHERE rr.name = 'Submitter'
  AND res."challengeId" = 'e12ee862-474a-4e40-9d2d-2699ae1dfc2a'
ORDER BY res."memberHandle";
