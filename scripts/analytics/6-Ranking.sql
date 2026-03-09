
-- Ranking analysis (order the values of dimensions by measure in order to identify Top N performance & Bottom N performance)

-- Which 5 products generate the highest revenue?
select top 5 p.product_name, sum(f.sales_amount) as total_revenue
from gold.fact_sales f
left join gold.dim_products p
on 
p.product_key = f.product_key
group by p.product_name
order by total_revenue desc

-- by using window function
select * from (
select  p.product_name, sum(f.sales_amount) as total_revenue,
ROW_NUMBER()over(order by sum(f.sales_amount) desc ) as rank_product
from gold.fact_sales f
left join gold.dim_products p
on 
p.product_key = f.product_key
group by p.product_name ) t
where rank_product <= 5


-- Which 5 subcategory generate the highest revenue?
select top 5 p.subcategory, sum(f.sales_amount) as total_revenue
from gold.fact_sales f
left join gold.dim_products p
on 
p.product_key = f.product_key
group by p.subcategory
order by total_revenue desc

-- What are the 5 worst-performing products in terms of sale?
select top 5 p.product_name, sum(f.sales_amount) as total_revenue
from gold.fact_sales f
left join gold.dim_products p
on 
p.product_key = f.product_key
group by p.product_name
order by total_revenue asc

-- Find the top 10 customers who have generated the highest revenue
select top 10 
c.customer_key , c.first_name, c.last_name ,
sum(f.sales_amount) as total_revenue
from gold.fact_sales f
left join gold.dim_customers c
on
c.customer_key = f.customer_key
group by c.customer_key , c.first_name, c.last_name
order by total_revenue desc 

-- Find the lowest 3 customers with the fewest orders placed
select top 3 
c.customer_key, 
c.first_name, 
c.last_name,
count(distinct(f.order_number)) as total_orders
from gold.fact_sales f
left join gold.dim_customers c
on
c.customer_key = f.customer_key
group by c.customer_key , c.first_name, c.last_name
order by total_orders asc 