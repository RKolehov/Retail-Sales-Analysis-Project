# Retail Sales Analysis Project

## **Project Description**
Pet project analyzing real-world e-commerce sales and customer behavior using data sourced via keyCRM API. Features optimized SQL queries for PostgreSQL and interactive Tableau dashboards. Covers the full data workflow — from extraction and cleaning to calculating actionable business metrics and visualizing insights for decision-making.

## **Project Goals**
- **Develop SQL skills** with optimized queries for large datasets.
- **Analyze customer behavior** and online store sales.
- **Create interactive dashboards** to visualize key metrics.
- **Integrate SQL data** with visual analytics.

## **Data Structure**
Four main tables are used:  
- **orders** — customer orders (date, customer, total amount).
- **expenses** — seller's expenses (amount, date, type).  
- **payments** — order payments (amount, date, method).  
- **order_products** — order details (products, price, quantity, discount).  
- **shipping** — shipping information (carrier, shipping date, delivery date).  

## **Key Metrics**
1. **Sales Analysis**  
   - Total sales  
   - Total Orders  
   - Average Order Value (AOV) 
   - Order Status Breakdown
   - Purchase Frequency

2. **Product Sales Analysis**  
   - Sales by category and product  
   - Average price  

3. **Customer Analysis**  
   - Lifetime Value (LTV)  
   - Retention Rate  
   - New vs returning customers
   - RFM-analysis

4. **Shipping Analysis**  
   - Average delivery time  
   - Top country by total orders and average delivery time
   - Top states on USA to shipping orders

## **Technologies**
- **Python** — uploading data to PostgreSQL via API keyCRM
- **PostgreSQL** — data storage and processing  
- **SQL** — analytical queries, aggregations, joins  
- **Tableau** — interactive visualizations and dashboards

**View dashboard with visualization: https://public.tableau.com/app/profile/roman.kolegov/viz/Retail_Sales_Analysis_Project/Summary**
