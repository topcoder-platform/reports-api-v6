SELECT 
    c.id as "challengeId",
    c.name AS "challengeName",
    p.billing_account as "billingAccountId",
    c.status as "challengeStatus",
    c."endDate" as "completeDate",
    p.created_at as "paymentDate",
    c."taskIsTask" AS "isTask",
    p.challenge_fee as "challengeFee",
    p.total_amount as "memberPayments",
    p.total_amount + p.challenge_fee as "lineItemAmount",
    m.handle AS "memberHandle",
    m."firstName" as "memberFirstName",
    m."lastName" as "memberLastName"
FROM finance.payment p
LEFT JOIN finance.winnings w 
    ON w.winning_id = p.winnings_id
LEFT JOIN challenges."Challenge" c 
    ON c.id = w.external_id
LEFT JOIN members.member m 
    ON m."userId" = w.winner_id::bigint
WHERE 
    ($1::text[] IS NULL OR p.billing_account = ANY($1::text[]))
    AND ($2::text[] IS NULL OR p.billing_account <> ANY($2::text[]))
    AND ($3::text[] IS NULL OR c.id = ANY($3::text[]))
    AND ($4::text IS NULL OR c.name ILIKE '%' || $4 || '%')
    AND ($5::text[] IS NULL OR c.status::text = ANY($5::text[]))
    AND ($6::timestamptz IS NULL OR c."endDate" >= $6::timestamptz)
    AND ($7::timestamptz IS NULL OR c."endDate" <= $7::timestamptz)
    AND ($8::boolean IS NULL OR c."taskIsTask" = $8::boolean)
    AND ($9::text[] IS NULL OR m.handle = ANY($9::text[]))
    AND ($10::numeric IS NULL OR (p.total_amount + p.challenge_fee) >= $10::numeric)
    AND ($11::numeric IS NULL OR (p.total_amount + p.challenge_fee) <= $11::numeric)
ORDER BY c."endDate" DESC, p.created_at DESC
LIMIT 1000;
