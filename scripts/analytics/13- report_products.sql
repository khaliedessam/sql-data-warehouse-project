/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

/*------------------------------------------------------------------------------
1) Base Query: Gathers essential fields from tables 
-------------------------------------------------------------------------------*/
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL 
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS 
WITH base_query AS (
SELECT 
       f.order_number,
       f.order_date,
       f.customer_key,
       f.sales_amount,
       f.quantity,
       p.product_key,
       p.product_name,
       p.category,
       p.subcategory,
       p.cost

FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE order_date IS NOT NULL ),

/*------------------------------------------------------------------------
2) Product Aggregationn: Summarizes key metrics at the product level
-------------------------------------------------------------------------*/
product_aggregations AS (
SELECT
      product_key,
      product_name,
      category,
      subcategory,
      cost,
      COUNT(DISTINCT(order_number)) AS total_orders,
      COUNT(DISTINCT(customer_key)) AS total_customers,
      SUM(sales_amount) AS total_sales,
      SUM(quantity) AS total_quantity,
      MAX(order_date) AS last_order_date,
      DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query 
GROUP BY 
 product_key,
 product_name,
 category,
 subcategory,
 cost )

/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
         product_key,
         product_name,
         category,
         subcategory,
         cost,
         total_orders,
         total_customers,
         total_sales,
         total_quantity,
         last_order_date,
         lifespan,
 -- recency (months since last order)
         DATEDIFF(MONTH,last_order_date,GETDATE()) AS recency_in_months,
     CASE WHEN total_sales > 50000 THEN 'High-Performer'
          WHEN total_sales >= 1000 THEN 'Mid-Range'
          ELSE 'Low-Range'
     END AS product_segment,
--- Copmute Average order revenue (AOR)
     CASE WHEN total_orders = 0 THEN 0
     ELSE total_sales / total_orders 
     END AS avg_order_revenue,
-- Compute Average monthly revenue
     CASE WHEN lifespan = 0 THEN total_sales
     ELSE total_sales / lifespan
     END AS avg_monthly_revenue
FROM 
product_aggregations

