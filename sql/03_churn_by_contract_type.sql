SELECT COUNT(*) AS customers_count, COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churn_count, ROUND(COUNT(CASE WHEN churn = 'Yes' THEN 1 END)::NUMERIC/COUNT(churn)*100,2) AS churn_percent, contract
FROM customers
GROUP BY contract
ORDER BY churn_percent;