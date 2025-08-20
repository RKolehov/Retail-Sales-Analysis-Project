            -- Total expenses--
SELECT
    COALESCE(actual_currency, 'UAH') AS currency,
    SUM(amount) AS total_expenses
FROM expenses exs
GROUP BY currency;
--Answer: USD - 162893.04, UAH - 322342.89--


            --Average expenses per order--
SELECT
    COALESCE(actual_currency, 'UAH') AS currency,
    ROUND(SUM(amount) / COUNT(DISTINCT order_id), 2) AS average_per_order
FROM expenses exs
GROUP BY currency;
--Answer: UAH - 53.54, USD - 9.04

            --Сhanges in expenses by year--
SELECT
    COALESCE(actual_currency, 'UAH') AS currency,
    DATE_PART('Year', created_at) AS year,
    SUM(amount) AS total_expenses
FROM expenses exs
WHERE created_at IS NOT NULL
GROUP BY DATE_PART('Year', created_at), COALESCE(actual_currency, 'UAH')
ORDER BY year, currency;
--Answer: 
--	UAH	2021	19396.99
--	USD	2021	23398.47
--	UAH	2022	7984.26
--	USD	2022	20094.62
--	UAH	2023	96061.50
--	USD	2023	27182.33
--	UAH	2024	117760.00
--	USD	2024	59144.80
--	UAH	2025	81140.14
--	USD	2025	33072.82