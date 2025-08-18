
            --Customer Count--
SELECT count(DISTINCT buyer_id) AS total_buyers
FROM buyers;
--Answer: total_buyers: 11784--


            --New vs Returning Customers (Retention Rate)--
WITH first_orders AS (
    SELECT 
        buyer_id,
        MIN(created_at) AS first_order_date
    FROM orders
    GROUP BY buyer_id
),
customer_classification AS (
    SELECT 
        f.buyer_id,
        CASE 
            WHEN COUNT(o.buyer_id) = 1 THEN 'New'
            ELSE 'Returning'
        END AS customer_type
    FROM first_orders f
    LEFT JOIN orders o
        ON f.buyer_id = o.buyer_id
    GROUP BY f.buyer_id
),
customer_counts AS (
    SELECT 
        customer_type,
        COUNT(*) AS customers_count
    FROM customer_classification
    GROUP BY customer_type
),
total_customers AS (
    SELECT COUNT(DISTINCT buyer_id) AS total_unique_customers
    FROM orders
)
SELECT 
    c.customer_type,
    c.customers_count,
    ROUND((c.customers_count * 100.0 / t.total_unique_customers), 2) AS percentage,
    CASE 
        WHEN c.customer_type = 'Returning' 
        THEN ROUND((c.customers_count * 100.0 / t.total_unique_customers), 2)
        ELSE NULL 
    END AS retention_rate
FROM customer_counts c
CROSS JOIN total_customers t
ORDER BY c.customer_type;
--Answer: 	New	- 8392, Percentage - 71.22. Returning - 3393, Percentage - 28.79. 
--Retention_Rate: 28.79%