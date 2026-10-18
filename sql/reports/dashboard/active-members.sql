-- Dated payouts and challenge registrations for the active-members dashboard.
-- $1/$2: inclusive/exclusive timestamptz bounds. Stored timestamps are UTC.
-- Match Recent Member Data's latest-payment and paid-date fallback semantics.
-- All payment categories qualify, including Topgear; owed/on-hold do not.
WITH bounds AS (
  SELECT $1::timestamptz AT TIME ZONE 'UTC' AS start_at,
         $2::timestamptz AT TIME ZONE 'UTC' AS end_at
), latest_payment AS (
  SELECT winnings_id, MAX(version) AS max_version
  FROM finance.payment
  GROUP BY winnings_id
), events AS (
  SELECT 'payment:' || p.payment_id::text AS id,
         BTRIM(w.winner_id) AS member_id,
         NULL::text AS fallback_handle,
         'payment' AS activity,
         COALESCE(p.date_paid, p.created_at) AS activity_at,
         COALESCE(NULLIF(w.title, ''), w.category::text, 'Payment') AS description
  FROM finance.payment p
  JOIN latest_payment lp ON lp.winnings_id = p.winnings_id AND lp.max_version = p.version
  JOIN finance.winnings w ON w.winning_id = p.winnings_id
  CROSS JOIN bounds b
  WHERE p.payment_status = 'PAID' AND w.type = 'PAYMENT'
    AND COALESCE(p.date_paid, p.created_at) >= b.start_at
    AND COALESCE(p.date_paid, p.created_at) < b.end_at
  UNION ALL
  SELECT 'registration:' || r.id, BTRIM(r."memberId"), r."memberHandle",
         'challenge-registration', r."createdAt", c.name
  FROM resources."Resource" r
  JOIN resources."ResourceRole" rr ON rr.id = r."roleId"
  JOIN challenges."Challenge" c ON c.id = r."challengeId"
  CROSS JOIN bounds b
  WHERE COALESCE(NULLIF(BTRIM(rr."nameLower"), ''), LOWER(rr.name)) IN ('submitter', 'registrant')
    AND r."createdAt" >= b.start_at AND r."createdAt" < b.end_at
)
SELECT e.id, e.member_id AS "memberId",
       COALESCE(NULLIF(m.handle, ''), NULLIF(e.fallback_handle, ''), e.member_id) AS handle,
       e.activity, TO_CHAR(e.activity_at, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"') AS date,
       e.description
FROM events e
LEFT JOIN members.member m ON m."userId"::text = e.member_id
WHERE NULLIF(e.member_id, '') IS NOT NULL
ORDER BY e.activity_at DESC, e.id;
