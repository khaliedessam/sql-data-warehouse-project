-- Change over time analsyis (Trends) it's Formula Agg[mesarue] by [Date Dimension]
-- Analyze how a measure evolves over time.
-- Help track trends and identify seasonality in your data.

-- Analyze Sale Performance Over Time
select year(order_date) as order_year,
sum(sales_amount) as total_sales,
count(distinct(customer_key)) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date IS NOT NULL
group by year(order_date)
order by year(order_date)

select 
FORMAT(order_date,'yyyy-MMM') as order_date,
sum(sales_amount) as total_sales,
count(distinct(customer_key)) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date IS NOT NULL
group by FORMAT(order_date,'yyyy-MMM')
order by FORMAT(order_date,'yyyy-MMM') 
