
-- Dimensions Exploration
-- Identifying the unique values in each dimension (using DISTINCT)

-- Explore All Countries our customers come from.
select Distinct country 
from gold.dim_customers

-- Explore All Product Categories "The Major Divisions"
select Distinct category,subcategory,product_name
from gold.dim_products
order by 1,2,3
