SELECT 
    p.payment_id as "paymentId",
    p.created_at as "paymentDate",
    p.billing_account as "billingAccountId",
    p.payment_status as "paymentStatus",
    p.challenge_fee as "challengeFee",
    p.total_amount as "paymentAmount",
    w.external_id as "challengeId",
    w.category,
    (w.category = 'TASK_PAYMENT') AS "isTask",
    c.name AS "challengeName",
    m.handle AS "winnerHandle",
    m."userId" as "winnerId",
    m."firstName" as "winnerFirstName",
    m."lastName" as "winnerLastName"
FROM finance.payment p
LEFT JOIN finance.winnings w 
    ON w.winning_id = p.winnings_id
LEFT JOIN challenges."Challenge" c 
    ON c.id = w.external_id
LEFT JOIN members.member m 
    ON m."userId" = w.winner_id::bigint
WHERE 
    ($1::text[] IS NULL OR p.billing_account = ANY($1::text[]))
    AND ($2::text[] IS NULL OR c.id = ANY($2::text[]))
    AND ($3::text[] IS NULL OR w.winner_id::text IN (
        SELECT m2."userId"::text
        FROM members.member m2
        WHERE m2.handle = ANY($3::text[])
    ))
    AND ($4::text IS NULL OR w.external_id IN (
        SELECT c2.id
        FROM challenges."Challenge" c2
        WHERE c2.name ILIKE '%' || $4 || '%'
    ))
    AND ($5::timestamptz IS NULL OR p.created_at >= $5::timestamptz)
    AND ($6::timestamptz IS NULL OR p.created_at <= $6::timestamptz)
    AND ($7::numeric IS NULL OR p.total_amount >= $7::numeric)
    AND ($8::numeric IS NULL OR p.total_amount <= $8::numeric)
ORDER BY p.created_at DESC
LIMIT 1000;
