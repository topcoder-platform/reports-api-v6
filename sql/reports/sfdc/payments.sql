WITH resolved_payment_references AS (
    SELECT
        p.payment_id,
        p.created_at,
        p.billing_account,
        p.payment_status,
        p.challenge_fee,
        p.total_amount,
        w.external_id,
        w.winner_id,
        w.category,
        CASE
            WHEN w.category IS DISTINCT FROM 'ENGAGEMENT_PAYMENT' THEN w.external_id
        END AS challenge_filter_id,
        CASE
            WHEN w.category = 'ENGAGEMENT_PAYMENT' THEN e.title
            ELSE c.name
        END AS challenge_name,
        c.status AS challenge_status,
        m.handle,
        m."userId",
        m."firstName",
        m."lastName"
    FROM finance.payment p
    LEFT JOIN finance.winnings w
        ON w.winning_id = p.winnings_id
    LEFT JOIN challenges."Challenge" c
        ON c.id = w.external_id
        AND w.category IS DISTINCT FROM 'ENGAGEMENT_PAYMENT'
    LEFT JOIN engagements."EngagementAssignment" ea
        ON ea.id = w.external_id
        AND w.category = 'ENGAGEMENT_PAYMENT'
    LEFT JOIN engagements."Engagement" e
        ON e.id = ea."engagementId"
    LEFT JOIN members.member m
        ON m."userId" = w.winner_id::bigint
)
SELECT 
    payment_id as "paymentId",
    created_at AT TIME ZONE 'America/New_York' as "paymentDate",
    billing_account as "billingAccountId",
    payment_status as "paymentStatus",
    challenge_fee as "challengeFee",
    total_amount as "paymentAmount", -- Looker cost_transaction.member_payments
    external_id as "challengeId",
    category,
    (category = 'TASK_PAYMENT') AS "isTask",
    challenge_name AS "challengeName",
    challenge_status AS "challengeStatus",
    handle AS "winnerHandle",
    "userId" as "winnerId",
    "firstName" as "winnerFirstName",
    "lastName" as "winnerLastName"
FROM resolved_payment_references
WHERE 
    ($1::text[] IS NULL OR billing_account = ANY($1::text[]))
    AND ($2::text[] IS NULL OR billing_account <> ANY($2::text[]))
    AND ($3::text[] IS NULL OR challenge_filter_id = ANY($3::text[]))
    AND ($4::text[] IS NULL OR winner_id::text IN (
        SELECT m2."userId"::text
        FROM members.member m2
        WHERE m2.handle = ANY($4::text[])
    ))
    AND ($5::text IS NULL OR challenge_name ILIKE '%' || $5 || '%')
    AND created_at >= COALESCE($6::timestamptz, (NOW() AT TIME ZONE 'UTC') - INTERVAL '45 days')
    AND ($7::timestamptz IS NULL OR created_at <= $7::timestamptz)
    AND ($8::numeric IS NULL OR total_amount >= $8::numeric)
    AND ($9::numeric IS NULL OR total_amount <= $9::numeric)
    AND ($10::text[] IS NULL OR challenge_status::text = ANY($10::text[]))
    AND ($11::text[] IS NULL OR payment_status::text = ANY($11::text[]))
ORDER BY created_at DESC
