SELECT contract,
       SUM(monthly_charges) AS total_monthly_revenue_at_risk,
       ROUND(SUM(monthly_charges) / SUM(SUM(monthly_charges)) OVER () * 100, 2) AS pct_of_total_risk
FROM customers
WHERE churn = 'Yes'
GROUP BY contract
ORDER BY total_monthly_revenue_at_risk DESC;