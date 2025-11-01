SELECT
    COUNT(*) AS "user.count"
FROM identity.user AS "user"
WHERE ("user".status) ILIKE 'A';
