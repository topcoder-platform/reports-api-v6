-- Monthly member signups and all-time signup summary.
--
-- Parameters:
--   $1 timestamptz - inclusive reporting range start
--   $2 timestamptz - exclusive reporting range end
--
-- identity.user timestamps are stored without a timezone and represent UTC.
WITH bounds AS (
  SELECT
    $1::timestamptz AT TIME ZONE 'UTC' AS start_at,
    $2::timestamptz AT TIME ZONE 'UTC' AS end_at
),
months AS (
  SELECT GENERATE_SERIES(
    DATE_TRUNC('month', b.start_at),
    DATE_TRUNC('month', b.end_at - INTERVAL '1 microsecond'),
    INTERVAL '1 month'
  ) AS month_start
  FROM bounds b
),
selected_months AS (
  SELECT
    DATE_TRUNC('month', u.create_date) AS month_start,
    COUNT(*) FILTER (WHERE u.status = 'A') AS activated,
    COUNT(*) FILTER (WHERE u.status <> 'A') AS not_activated
  FROM identity."user" u
  CROSS JOIN bounds b
  WHERE u.create_date >= b.start_at
    AND u.create_date < b.end_at
  GROUP BY DATE_TRUNC('month', u.create_date)
),
all_time_months AS (
  SELECT
    DATE_TRUNC('month', u.create_date) AS month_start,
    COUNT(*) AS signup_count
  FROM identity."user" u
  WHERE u.create_date IS NOT NULL
  GROUP BY DATE_TRUNC('month', u.create_date)
),
peak_month AS (
  SELECT
    atm.month_start,
    atm.signup_count
  FROM all_time_months atm
  ORDER BY atm.signup_count DESC, atm.month_start DESC
  LIMIT 1
),
all_time_summary AS (
  SELECT
    COUNT(*) AS total_signups,
    COUNT(*) FILTER (WHERE u.status = 'A') AS activated_members,
    COUNT(*) FILTER (WHERE u.status <> 'A') AS not_activated_members,
    COALESCE(
      ROUND(
        COUNT(*) FILTER (WHERE u.status = 'A') * 100.0
          / NULLIF(COUNT(*), 0),
        1
      ),
      0
    ) AS activation_rate
  FROM identity."user" u
)
SELECT
  TO_CHAR(m.month_start, 'YYYY-MM-01') AS month,
  COALESCE(sm.activated, 0) AS activated,
  COALESCE(sm.not_activated, 0) AS not_activated,
  ats.total_signups,
  ats.activated_members,
  ats.not_activated_members,
  ats.activation_rate,
  TO_CHAR(pm.month_start, 'YYYY-MM-01') AS peak_month,
  COALESCE(pm.signup_count, 0) AS peak_month_signups
FROM months m
LEFT JOIN selected_months sm
  ON sm.month_start = m.month_start
CROSS JOIN all_time_summary ats
LEFT JOIN peak_month pm
  ON TRUE
ORDER BY m.month_start;
