
-- Performance Analysis (Comparing the current value to a targte value).
-- It's formula Current[measure] - Target[measure].


/* Analyze the yearly performance of products by comparing each product sales to both
 its average sales performance and the previous year's sales. */

 with  yearly_product_sales as (
 select 
 year(f.order_date) as order_year ,
 p.product_name,
 sum(f.sales_amount) as current_sales
 from gold.fact_sales f
 left join gold.dim_products p
 on f.product_key = p.product_key
 where f.order_date is not null
 group by year(f.order_date) , p.product_name 
 )
 select 
 order_year,
 product_name,
 current_sales,
 avg(current_sales) over(partition by product_name) as avg_sales,
 current_sales - avg(current_sales) over(partition by product_name) as diff_avg,
 CASE WHEN current_sales - avg(current_sales) over(partition by product_name) > 0 THEN 'Above Avg'
      WHEN current_sales - avg(current_sales) over(partition by product_name) < 0 THEN 'Below Avg'
      ELSE 'Avg'
END avg_change,
-- year-over-year Analysis
LAG(current_sales) over (partition by product_name order by order_year) as previous_year_sales,
current_sales - LAG(current_sales) over (partition by product_name order by order_year) as diff_previous,
CASE WHEN current_sales - LAG(current_sales) over (partition by product_name order by order_year) > 0 THEN 'Increase'
     WHEN current_sales - LAG(current_sales) over (partition by product_name order by order_year) < 0 THEN 'Decrease'
     ELSE 'No Change'
END previous_change

 from yearly_product_sales
order by product_name, order_year