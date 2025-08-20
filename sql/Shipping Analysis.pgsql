            --Average Days of Delivery--
SELECT 
    AVG(EXTRACT(EPOCH FROM (shipping_date_actual - o.created_at)) / 86400)::numeric(10,2) AS avg_delivery_days
FROM shipping sh
LEFT JOIN orders o
ON sh.order_id = o.order_id
WHERE shipping_date_actual IS NOT NULL;
--Answer: 5.41--


            --Average Delivery Days of Country (Top 20 on total_orders)--
SELECT 
    sh.shipping_address_country AS shipping_country,
    COUNT(*) AS total_orders,
    ROUND(AVG(EXTRACT(EPOCH FROM (sh.shipping_date_actual - o.created_at)) / 86400)::numeric(10,2), 0) AS avg_delivery_days
FROM shipping sh
JOIN orders o ON sh.order_id = o.order_id
WHERE sh.shipping_date_actual IS NOT NULL
  AND o.created_at IS NOT NULL
  AND sh.shipping_date_actual >= o.created_at
GROUP BY sh.shipping_address_country
ORDER BY total_orders DESC
limit 20;
--Answer: shipping_country total_orders avg_delivery_days
--1	    United States	9683	7
--2	    United Kingdom	2387	7
--3	    Germany	        2174	8
--4	    France	        1444	7
--5	    Canada	        1307	7
--6	    Italy	        979	    7
--7	    Australia	    872	    7
--8	    Spain	        210	    7
--9	    Ireland	        189	    7
--10	Switzerland	    183	    8
--11	Belgium	        164	    8
--12	Singapore	    144	    9
--13	Netherlands	    139	    5
--14	Austria	        122	    7
--15	The Netherlands	87	    12
--16	South Korea	    85	    7
--17	Sweden	        53	    10
--18	Norway	        38	    5
--19	New Zealand	    27	    6
--20	Malta	        27	    5

            --Top 10 states on USA to shipping orders--
SELECT
    sh.shipping_address_city as shipping_city,
    sh.shipping_address_country AS shipping_country,
    COUNT(*) AS total_orders
FROM shipping sh
JOIN orders o ON sh.order_id = o.order_id
WHERE shipping_address_country = 'United States'
    AND o.created_at IS NOT NULL
GROUP BY sh.shipping_address_city, shipping_address_country
ORDER BY total_orders DESC
limit 10;
--Answer: 
--1	Fayetteville	    United States	52
--2	Austin	            United States	50
--3	Canyon Lake	        United States	45
--4	Lancaster	        United States	43
--5	Denver	            United States	42
--6	New Harmony	        United States	38
--7	Clovis	            United States	36
--8	Houston	            United States	35
--9	Abilene	            United States	34
--10 Charlotte	        United States	33