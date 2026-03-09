-- Part_To_Whole Analysis
-- Analyze how an individual part is performing compared to the overall
-- It's formula ([Measure/Total Measure])*100 By [Dimension]

-- which categories contribute the most to over sales?

WITH category_sales as (
select 
p.category,
sum(f.sales_amount) as total_sales
from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key
group by p.category
)
select 
category, 
total_sales,
sum(total_sales) over () as overall_sales,
concat(round((cast(total_sales as float)/sum(total_sales) over ())*100,2),'%') as percentage_of_total
from category_sales
order by total_sales desc