
-- Comulative Analsyis (Aggregate the data progressivly over time).. Σ[comulative measure] by [Date Dimension]
-- Helps to understand whether our business is growing or declining


-- Calculate the total sales per month and the running total of sales overtime.

select
DATEFROMPARTS(year(order_date),month(order_date),1) as order_date,
sum(sales_amount) as total_sales
from gold.fact_sales
where order_date IS NOT NULL
group by DATEFROMPARTS(year(order_date),month(order_date),1)
order by DATEFROMPARTS(year(order_date),month(order_date),1)

-- Calculate the running total of sales overtime.
-- we use window function for adding each row's value to the sum of all previous row's values.

select 
order_date,
total_sales,
sum(total_sales) over(order by order_date) as running_total_sales,
avg(avg_price) over(order by order_date) as moving_average_price
from
(select
DATEFROMPARTS(year(order_date),1,1) as order_date,
sum(sales_amount) as total_sales,
avg(price) as avg_price
from gold.fact_sales
where order_date IS NOT NULL
group by DATEFROMPARTS(year(order_date),1,1)
)t


