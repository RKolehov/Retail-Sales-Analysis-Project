
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
--Retention_Rate: 28.79%--


            --Customer Lifetime Value (LTV)--
WITH customer_revenue AS (
    SELECT 
        o.buyer_id,
        COALESCE(p.actual_currency, 'UAH') AS currency,
        SUM(p.amount) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS order_count,
        MIN(o.created_at) AS first_order_date,
        MAX(o.created_at) AS last_order_date
    FROM orders o
    LEFT JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY o.buyer_id, COALESCE(p.actual_currency, 'UAH')
),
customer_metrics AS (
    SELECT 
        currency,
        AVG(total_revenue) AS avg_revenue_per_customer,
        AVG(order_count) AS avg_orders_per_customer,
        AVG(EXTRACT(YEAR FROM AGE(last_order_date, first_order_date)) + EXTRACT(MONTH FROM AGE(last_order_date, first_order_date)) / 12.0) AS avg_lifespan_years
    FROM customer_revenue
    GROUP BY currency
)
SELECT 
    currency,
    ROUND(avg_revenue_per_customer::numeric, 2) AS ltv,
    ROUND((avg_revenue_per_customer / avg_orders_per_customer)::numeric, 2) AS avg_revenue_per_order,
    ROUND(avg_orders_per_customer::numeric, 2) AS avg_orders_per_customer,
    ROUND(avg_lifespan_years::numeric, 2) AS avg_lifespan_years
FROM customer_metrics
WHERE currency IN ('UAH', 'USD')
ORDER BY currency;
--Answer:
--LTV: UAH - 542.88, USD - 130.11
--Avg_revenue_per_order: UAH - 542.88, USD - 72.30
--Avg_orders_per_customer: UAH - 1.65, USD - 1.80
--Avg_lifespan_years: UAH - 0.21, USD - 0.30