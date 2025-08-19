
            --Total Sales--
SELECT 
COALESCE(p.actual_currency, 'UAH') AS currency,
SUM(o.grand_total) AS total_by_currency
FROM orders o
LEFT JOIN payments p 
ON o.order_id = p.order_id
GROUP BY COALESCE(p.actual_currency, 'UAH')
ORDER BY currency;
--Answer: UAH 2317493.18, USD 1501253.01--


            --Total Orders--
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;
--Answer: total_orders: 22060--


            --Average Order Value (AOV)--
SELECT 
COALESCE(p.actual_currency, 'UAH') AS currency,
ROUND(SUM(o.grand_total) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
LEFT JOIN payments p 
ON o.order_id = p.order_id
GROUP BY COALESCE(p.actual_currency, 'UAH')
ORDER BY currency;
--Answer: UAH 1754.35, USD 72.39--


            --Order Status Breakdown--
SELECT 
s.alias AS status_name,
COUNT(o.order_id) AS orders_count
FROM orders o
LEFT JOIN statuses s
ON o.status_group_id = s.group_id
GROUP BY s.alias
ORDER BY orders_count DESC;
--Answer: 
--1	completed	21922
--2	incorrect_data	114
--3	canceled	114
--4	v_roboti	18
--5	maket_gotovii	18
--6	bez_personalizaciyi	18
--7	maket_na_zatverdzennya	18
--8	peredano_na_graviyuvannya	18
--9	new	5
--10 utocnennya_informaciyi	1--


            --Purchase Frequency--
SELECT 
round(COUNT(DISTINCT o.order_id)::numeric / COUNT(DISTINCT o.buyer_id), 2) AS purchase_frequency
FROM orders o;
--Answer: 1.87--