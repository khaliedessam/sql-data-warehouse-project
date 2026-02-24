/*
===================================================================================================
DDL Script: Create Gold Views
===================================================================================================
Script Purpose:
       This script creates views for the Gold Layer in the data warehouse.
       The Gold Layer represents the final dimension and fact tables (Star Schema)
         
       Each view performs transformations and combines data from the Silver layer 
       to produce a clean,enriched,and business-ready dataset.

Usage:
     - These views can be queried directly for analytics and reporting.
==================================================================================================
*/

------Create Dimension: (gold.dim_customers) (3 tables in relation based on data modeling)
--Rename Columns to friendly,meaningful names.
--Sort the columns into logical groups to improve readability (Column arrangement).
--Create surrogate key (customer_key) to use it to connect the data model 
--Create the object (all the objects in gold layer are going to be a virtual one) by create views 

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
create view gold.dim_customers as
select 
  ROW_NUMBER() OVER(order by cst_id) AS customer_key,   --surrogate key
  ci.cst_id as customer_id,
  ci.cst_key as customer_number,
  ci.cst_firstname as first_name,
  ci.cst_lastname as last_name,
  la.cntry as country,
  ci.cst_material_status as marital_status,
  case when ci.cst_gndr != 'n/a' then ci.cst_gndr   -- CRM is the primary source for gender
     else coalesce(ca.gen,'n/a')                    -- Fallback to ERP data
end as gender,
  ca.bdate as birthdate,
  ci.cst_create_date as create_date
from silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
on        ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
on        ci.cst_key = la.cid

Go


-----Create Dimension: (gold.dim_products) (2 tables in relation based on data modeling)
--filter historical data (need current data only)
--Collected all the product informations from the two source systems
--Rename Columns to friendly,meaningful names.
--Sort the columns into logical groups to improve readability (Column arrangement). 
--Create surrogate key (product_key) to use it to connect the data model 
--Create the object (all the objects in gold layer are going to be a virtual one) by create views 

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO
create view gold.dim_products as
select
   ROW_NUMBER() OVER(order by prd_key,prd_start_dt) as product_key,
   pn.prd_id as product_id,
   pn.prd_key as product_number,
   pn.prd_nm as product_name,
   pn.cat_id as category_id,
   pc.cat as category,
   pc.subcat as subcategory,
   pc.maintenance,
   pn.prd_cost as cost,
   pn.prd_line as product_line,
   pn.prd_start_dt
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pc
on    pn.cat_id = pc.id
where prd_end_dt IS NULL 

Go

-------Create Dimension: (gold.fact_sales) that has transactions and events.
--Fact is connecting multiple dimensions
--Use the dimension`s surrogate keys instead of IDs to easily connect facts with dimensions.(Join fact with two dimension tables)
-- and connect the data model to connect the facts with dimensions
--Rename Columns to friendly,meaningful names.

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
create view gold.fact_sales as
select
sd.sls_ord_num as order_number,
pr.product_key,         ---dimension key
cu.customer_key,        ---dimension key
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date ,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amonut,
sd.sls_quantity as quantity,
sd.sls_price as price
from silver.crm_sales_details sd
left join gold.dim_products pr
on    sd.sls_prd_key = pr.product_number
left join gold.dim_customers cu
on    sd.sls_cust_id = cu.customer_id

Go