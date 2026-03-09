/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/


/*Segment products into cost ranges and 
count how many products fall into each segment*/

WITH product_segments as (
 select
     product_key,
     product_name,
     cost,
     CASE WHEN cost < 100 THEN 'Below 100'
          WHEN cost BETWEEN 100 AND 500 THEN '100-500'
          WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
          ELSE 'Above 1000'
     END as cost_range
from gold.dim_products )

select 
     cost_range,
     count(product_key) as total_products
from product_segments
group by cost_range
order by total_products desc

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH customer_spending as (
 SELECT
     c.customer_key,
     sum(f.sales_amount) as total_spending,
     MIN(order_date) as first_order,
     MAX(order_date) as last_order,
     DATEDIFF(month,MIN(order_date),MAX(order_date)) as lifespan
 from
 gold.fact_sales f
 LEFT JOIN gold.dim_customers c
 on f.customer_key = c.customer_key
 group by c.customer_key
 )

 SELECT 
    customer_key,
    total_spending,
    lifespan,
  CASE WHEN total_spending > 5000 AND lifespan >= 12 THEN 'VIP'
       WHEN total_spending <= 5000 AND lifespan >= 12 THEN 'Regular'
       ELSE 'New'
  END AS customers_segment
  from customer_spending

  ---- find the total number of customers by each group

  WITH customer_spending as (
 SELECT
     c.customer_key,
     sum(f.sales_amount) as total_spending,
     MIN(order_date) as first_order,
     MAX(order_date) as last_order,
     DATEDIFF(month,MIN(order_date),MAX(order_date)) as lifespan
 from
 gold.fact_sales f
 LEFT JOIN gold.dim_customers c
 on f.customer_key = c.customer_key
 group by c.customer_key
 )

 SELECT 
   count(customer_key) as total_customers,
  CASE WHEN total_spending > 5000 AND lifespan >= 12 THEN 'VIP'
       WHEN total_spending <= 5000 AND lifespan >= 12 THEN 'Regular'
       ELSE 'New'
  END AS customers_segment
  from customer_spending
GROUP BY
 CASE WHEN total_spending > 5000 AND lifespan >= 12 THEN 'VIP'
       WHEN total_spending <= 5000 AND lifespan >= 12 THEN 'Regular'
       ELSE 'New'
  END ;
    
    
    ---- Using Subquery find the total number of customers by each group

  WITH customer_spending as (
 SELECT
     c.customer_key,
     sum(f.sales_amount) as total_spending,
     MIN(order_date) as first_order,
     MAX(order_date) as last_order,
     DATEDIFF(month,MIN(order_date),MAX(order_date)) as lifespan
 from
 gold.fact_sales f
 LEFT JOIN gold.dim_customers c
 on f.customer_key = c.customer_key
 group by c.customer_key
 )

 SELECT 
    count(customer_key) as total_customers,
    customer_segment 
from (
   select customer_key,
  CASE WHEN total_spending > 5000 AND lifespan >= 12 THEN 'VIP'
       WHEN total_spending <= 5000 AND lifespan >= 12 THEN 'Regular'
       ELSE 'New'
  END AS customer_segment
  from customer_spending ) t
  group by customer_segment
  order by total_customers desc
  



