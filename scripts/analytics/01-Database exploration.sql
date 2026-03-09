
-- Explore All Objects in the Database
select * from INFORMATION_SCHEMA.TABLES

-- Explore All Columns in the Database
select * from INFORMATION_SCHEMA.COLUMNS

-- Explore Dim_customer 
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'dim_customers'