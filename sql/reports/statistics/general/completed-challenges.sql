SELECT COUNT(*)::bigint AS count
FROM challenges."Challenge" c
WHERE c.status = 'COMPLETED';

