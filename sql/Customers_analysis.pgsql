
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
customers_class AS (
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
FROM customers_class
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


            --RFM-analysis (Recency, Frequency, Monetary). Top 30 customers--
WITH RFM AS (
SELECT
    o.buyer_id,
    MAX(o.created_at) AS last_order_date,
    COUNT(DISTINCT o.order_id) AS frequency,
     COALESCE(p.actual_currency, 'UAH') AS currency,
    SUM(o.grand_total) AS monetary
FROM orders o
LEFT JOIN payments p 
ON o.order_id = p.order_id
GROUP BY o.buyer_id, p.actual_currency
)
SELECT
r.*,
DATE_PART('day', NOW() - r.last_order_date) AS recency_days
FROM RFM r
ORDER BY monetary DESC
limit 30;
--Answer:
--buyer_id | last_order_date | frequency | currency | monetary | recency_days
--1	5812	2025-07-28 10:49:25     53	    UAH	       492659.52	22
--2	null	2025-08-06 11:50:23 	47	    UAH	       338313.84	13
--3	1192	2025-03-31 17:42:24 	9	    UAH	       176700.00	141
--4	4525	2025-04-23 10:50:02	    52	    UAH	       163864.00	118
--5	1412	2025-05-02 07:10:42	    8	    UAH	       123230.96	109
--6	7854	2025-07-17 14:08:26	    7	    UAH	       113291.68	33
--7	10037	2025-07-28 11:52:10	    3	    UAH	       74966.05	    22
--8	11477	2025-06-03 05:17:27	    1	    UAH	       65000.00	    77
--9	1361	2025-04-05 17:29:28	    8	    UAH	       50257.70	    136
--10 906	2025-06-13 12:22:43	    7	    UAH	       43520.95	    67
--11 5812	2024-09-25 15:12:41	    2	    UAH	       28290.00	    328
--12 4018	2023-07-17 13:40:02	    2	    UAH        27000.00	    764
--13 10092	2025-08-05 06:11:19	    5	    UAH	       25894.00	    14
--14 1675	2024-11-11 10:22:46	    11	    UAH	       24150.00	    281
--15 6285	2025-07-28 10:37:49	    7	    UAH	       22688.00	    22
--16 1526	2024-04-16 18:02:48	    4	    UAH	       20824.00	    490
--17 9853	2025-07-08 11:35:28	    2	    UAH	       17250.00	    42
--18 6274	2025-06-03 14:27:31	    18	    UAH	       16847.15	    77
--19 1332	2025-08-01 06:10:18	    81	    USD	       15070.52	    18
--20 8562	2025-07-02 06:45:23	    5	    UAH	       14010.00	    48
--21 1664	2024-11-29 09:51:50	    12	    UAH        12870.00	    263
--22 5527	2025-07-09 11:06:24	    5	    UAH	       12437.50	    41
--23 8882	2025-02-04 13:19:48	    3	    UAH	       12365.00	    196
--24 7812	2023-07-24 04:01:24	    2	    USD	       10671.19	    757
--25 11569	2025-06-16 07:50:17	    1	    UAH	       10000.00	    64
--26 11460	2025-08-04 11:40:58	    2	    UAH	       9986.40	    15
--27 10839	2025-08-01 12:10:45	    3	    UAH	       8325.10	    18
--28 3954	2025-05-30 11:39:33	    10	    UAH	       8294.00	    81
--29 10142	2025-07-08 11:34:18	    6	    UAH	       7954.00	    42
--30 6132	2025-03-05 16:03:04	    6	    UAH        7590.00	    167