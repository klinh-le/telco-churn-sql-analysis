WITH internet_breakdown AS (
	SELECT 'internet_service' AS factor, internet_service AS value,
		COUNT (*) AS customer_count,
		COUNT (CASE WHEN churn = 'Yes' THEN 1 END) AS churn_count,
		ROUND(COUNT (CASE WHEN churn = 'Yes' THEN 1 END)::NUMERIC/COUNT(churn)*100,2) AS churn_percent
	FROM customers
	GROUP BY internet_service
),
tech_support_breakdown AS (
	SELECT 'tech_support' AS factor, tech_support AS value,
		COUNT (*) AS customer_count,
		COUNT (CASE WHEN churn = 'Yes' THEN 1 END) AS churn_count,
		ROUND(COUNT (CASE WHEN churn = 'Yes' THEN 1 END)::NUMERIC/COUNT(churn)*100,2) AS churn_percent
	FROM customers
	GROUP BY tech_support
),
online_security_breakdown AS (
	SELECT 'online_security' AS factor, online_security AS value,
		COUNT (*) AS customer_count,
		COUNT (CASE WHEN churn = 'Yes' THEN 1 END) AS churn_count,
		ROUND(COUNT (CASE WHEN churn = 'Yes' THEN 1 END)::NUMERIC/COUNT(churn)*100,2) AS churn_percent
	FROM customers
	GROUP BY online_security
)
SELECT * FROM internet_breakdown
UNION ALL
SELECT * FROM tech_support_breakdown
UNION ALL
SELECT * FROM online_security_breakdown
ORDER BY factor, churn_percent;