                --Total sell product per categories--
SELECT 
    CASE 
        WHEN op.name ILIKE 'WD%' THEN 'Wood Boxes'
        WHEN op.name ILIKE '%Wooden%box%' THEN 'Wood Boxes'
        WHEN op.name ILIKE '%Wood%box%' THEN 'Wood Boxes'
        WHEN op.name ILIKE '%glass%photo%' THEN 'Glass Boxes'
        WHEN op.name ILIKE 'PL%' THEN 'Playwood Boxes'
        WHEN op.name ILIKE 'TX%' THEN 'Textile Boxes'
        WHEN op.name ILIKE '%Textile%' THEN 'Textile Boxes'
        WHEN op.name ILIKE '%set%of%box' THEN 'Set of Boxes'
        WHEN op.name ILIKE '%Set%of%' THEN 'Set of Boxes'
        WHEN op.name ILIKE '%Set%of%usb%' THEN 'Set of USB'
        WHEN op.name ILIKE '%Leather%' THEN 'Leather Boxes'
        WHEN op.name ILIKE 'LT%' THEN 'Leather Boxes'
        WHEN op.name ILIKE '%Glass%wood%usb%' THEN 'USB Flash'
        WHEN op.name ILIKE '%wood%glass%USB' THEN 'USB Flash'
        WHEN op.name ILIKE '%glass%wood%usb%' THEN 'USB Flash'
        WHEN op.name ILIKE '%Glass%Metal%USB%' THEN 'USB Flash'
        WHEN op.name ILIKE 'USB%' THEN 'USB Flash'
        WHEN op.name ILIKE 'crystal%USB%' THEN 'USB Flash'
        WHEN op.name ILIKE 'Wood%USB%' THEN 'USB Flash'
        WHEN op.name ILIKE 'wood%USB%' THEN 'USB Flash'
        WHEN op.name ILIKE 'J%' THEN 'Jewerly Boxes'
        WHEN op.name ILIKE 'Kraft%Paper%Bag' THEN 'Paper Bag'
        ELSE 'Others'
    END AS product_group,
    COALESCE(p.actual_currency, 'UAH') AS currency,
    SUM(op.price_sold * op.quantity - op.total_discount) AS total_sell_per_group
FROM order_products op
LEFT JOIN payments p 
    ON op.order_id = p.order_id
GROUP BY product_group, currency
ORDER BY total_sell_per_group DESC;
--Answer: product_group  currency  total_sell_per_group
--1	    Wood Boxes	    USD	        1136573.08
--2	    Playwood Boxes	UAH	        872544.96
--3	    Wood Boxes	    UAH	        787199.67
--4	    USB Flash	    UAH	        550772.42
--5	    USB Flash	    USD	        195569.22
--6	    Textile Boxes	UAH     	89505.00
--7	    Set of Boxes	USD	        52517.68
--8	    Glass Boxes	    USD	        43567.01
--9	    Others	        USD	        32834.15
--10	Others	        UAH	        25214.00
--11	Leather Boxes	USD	        4897.40
--12	Set of Boxes	UAH	        651.00
--13	Leather Boxes	UAH	        558.00
--14	Glass Boxes	    UAH	        355.15
--15	Textile Boxes	USD	        184.00
--16	Paper Bag	    USD	        20.90
--17	Jewerly Boxes	UAH	        0.00
--18	Playwood Boxes	USD	        0.00

                --Average price per categories--
SELECT 
    CASE 
        WHEN op.name ILIKE 'WD%' THEN 'Wood Boxes'
        WHEN op.name ILIKE '%Wooden%box%' THEN 'Wood Boxes'
        WHEN op.name ILIKE '%Wood%box%' THEN 'Wood Boxes'
        WHEN op.name ILIKE '%glass%photo%' THEN 'Glass Boxes'
        WHEN op.name ILIKE 'PL%' THEN 'Playwood Boxes'
        WHEN op.name ILIKE 'TX%' THEN 'Textile Boxes'
        WHEN op.name ILIKE '%Textile%' THEN 'Textile Boxes'
        WHEN op.name ILIKE '%set%of%box' THEN 'Set of Boxes'
        WHEN op.name ILIKE '%Set%of%' THEN 'Set of Boxes'
        WHEN op.name ILIKE '%Set%of%usb%' THEN 'Set of USB'
        WHEN op.name ILIKE '%Leather%' THEN 'Leather Boxes'
        WHEN op.name ILIKE 'LT%' THEN 'Leather Boxes'
        WHEN op.name ILIKE '%Glass%wood%usb%' THEN 'USB Flash'
        WHEN op.name ILIKE '%wood%glass%USB' THEN 'USB Flash'
        WHEN op.name ILIKE '%glass%wood%usb%' THEN 'USB Flash'
        WHEN op.name ILIKE '%Glass%Metal%USB%' THEN 'USB Flash'
        WHEN op.name ILIKE 'USB%' THEN 'USB Flash'
        WHEN op.name ILIKE 'crystal%USB%' THEN 'USB Flash'
        WHEN op.name ILIKE 'Wood%USB%' THEN 'USB Flash'
        WHEN op.name ILIKE 'wood%USB%' THEN 'USB Flash'
        WHEN op.name ILIKE 'J%' THEN 'Jewerly Boxes'
        WHEN op.name ILIKE 'Kraft%Paper%Bag' THEN 'Paper Bag'
        ELSE 'Others'
    END AS product_group,
    COALESCE(p.actual_currency, 'UAH') AS currency,
    ROUND(AVG(op.price), 2) AS avg_price_per_categories
FROM order_products op
LEFT JOIN payments p 
    ON op.order_id = p.order_id
GROUP BY product_group, currency
ORDER BY avg_price_per_categories DESC;
--Answer:
-- product_group         currency  avg_price_per_categories
--1	    Textile Boxes	    UAH	    396.33
--2	    Playwood Boxes	    UAH	    309.82
--3	    USB Flash	        UAH	    252.13
--4	    Wood Boxes	        UAH	    185.65
--5	    Others	            UAH	    167.29
--6	    Set of Boxes	    USD 	133.67
--7	    Leather Boxes	    UAH	    93.00
--8	    Set of Boxes	    UAH	    76.57
-- 9	Glass Boxes	        USD	    60.96
-- 10	Glass Boxes	        UAH 	59.19
-- 11	Textile Boxes	    USD	    46.00
-- 12	Wood Boxes	        USD	    34.12
-- 13	Leather Boxes	    USD	    29.58
-- 14	Others	            USD	    17.32
-- 15	USB Flash	        USD 	15.28
-- 16	Paper Bag	        USD	    1.90
-- 17	Playwood Boxes	    USD	    0.00
-- 18	Jewerly Boxes	    UAH 	0.00
