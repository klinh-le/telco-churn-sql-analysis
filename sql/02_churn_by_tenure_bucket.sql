SELECT COUNT(*) AS customers_count, COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churn_count, ROUND(COUNT(CASE WHEN churn = 'Yes' THEN 1 END)::NUMERIC/COUNT(churn)*100,2) AS churn_percent, tenure_buckets.bucket_label 
FROM customers
INNER JOIN tenure_buckets
ON customers.tenure BETWEEN tenure_buckets.min_tenure AND tenure_buckets.max_tenure
GROUP BY tenure_buckets.bucket_label, tenure_buckets.min_tenure
ORDER BY tenure_buckets.min_tenure;