SELECT COALESCE(SUM(p.total_amount), 0)::numeric(20,2) AS total
FROM finance.payment p;

