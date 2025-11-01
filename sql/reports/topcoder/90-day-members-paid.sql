SELECT
  COUNT(DISTINCT payee.coder_id) AS "payee.count"
FROM tcs_dw.payment AS payment
INNER JOIN tcs_dw.user_payment AS user_payment
  ON payment.payment_id = user_payment.payment_id
INNER JOIN tcs_dw.coder AS payee
  ON user_payment.user_id = payee.coder_id
INNER JOIN topcoder_dw.calendar AS payment_create_date
  ON payment.created_calendar_id = payment_create_date.calendar_id
LEFT JOIN tcs_dw.project AS challenge
  ON payment.challenge_blended_id = challenge.challenge_blended_id
LEFT JOIN looker_pdt."LR$QHMWJ1761538148605_challenge_groups" AS challenge_groups
  ON challenge.challenge_blended_id = challenge_groups.challenge_blended_id
LEFT JOIN tcs_dw.client_project_dim AS client_project_dim
  ON client_project_dim.client_project_id = challenge.client_project_id
WHERE payment_create_date.date >= (DATE_TRUNC('day', CURRENT_TIMESTAMP) - INTERVAL '89 days')
  AND payment_create_date.date < (DATE_TRUNC('day', CURRENT_TIMESTAMP) + INTERVAL '1 day')
  AND (
    challenge_groups.group_name NOT ILIKE 'Wipro%'
    OR challenge_groups.group_name IS NULL
  )
  AND (
    (
      client_project_dim.project_name NOT ILIKE 'Fun & Learning Challenges (Jaipur)'
      AND client_project_dim.project_name NOT ILIKE 'Fun & Learning - 2016 (Jaipur)'
      AND client_project_dim.project_name NOT ILIKE 'TopGear Trial'
    )
    OR client_project_dim.project_name IS NULL
  );
