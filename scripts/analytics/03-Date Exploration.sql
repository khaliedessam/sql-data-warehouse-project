
-- Date Exploration
-- Identify the earliest and latest dates (boundaries) and years between them (time span of business).

-- Find the date of the first and last order.
-- How many years of sales are available.

 select min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        DATEDIFF(year,min(order_date),max(order_date)) as order_range_years
 from gold.fact_sales

 -- Find the youngest and oldest customer

    select  min(birthdate) as oldest_birthdate,
            DATEDIFF(year,min(birthdate),GETDATE()) as oldes_age,
            max(birthdate) as youngest_birthdate,
            DATEDIFF(year,max(birthdate),GETDATE()) as youngest_age
    from gold.dim_customers