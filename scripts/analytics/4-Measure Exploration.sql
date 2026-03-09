
-- Measures Exploration
-- Calculate the key metric of the business(Big Numbers)

-- Find the Total Sales(Total Revenue)
select sum(sales_amount) as total_sales from gold.fact_sales

-- Find how many items are sold
select sum(quantity) as total_quantity from gold.fact_sales

-- Find the average selling price
select avg(price) as avg_price from gold.fact_sales

-- Find the Total number of Orders
select count(order_number) as total_orders from gold.fact_sales
select count(distinct(order_number)) as total_orders from gold.fact_sales


-- Find the Total number of Products
select count(product_name) as total_products from gold.dim_products
select count(distinct(product_name)) as total_products from gold.dim_products

-- Fint the Total number of Customers
select count(customer_key) as total_customers from gold.dim_customers

-- Find the Total number of Customer that has placed an order
select count(distinct(customer_key)) as total_customers from gold.fact_sales

-- Generate a Report that shows all key metrics of the business

select 'total_sales' as measure_name, sum(sales_amount) as measure_value from gold.fact_sales
union all
select 'total_quantity' as measure_name, sum(quantity) as measure_value from gold.fact_sales
union all
select 'average_price' as measure_name,avg(price) as measure_value from gold.fact_sales
union all
select 'Total Nr.Orders' as measure_name,count(distinct(order_number)) as measure_value from gold.fact_sales
union all
select 'Total Nr.Products' as measure_name,count(product_name) as measure_value from gold.dim_products
union all
select 'Total Nr.Customers' as measure_name,count(customer_key) as measure_value from gold.dim_customers
