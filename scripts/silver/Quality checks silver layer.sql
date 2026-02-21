/*
=======================================================================================
Qualtiy Checks
=======================================================================================
Script Purpose:
       This script performs various quality checks for data consistency, accuracy,
       and standardization across the 'silver' schemas.

Actions Performed:
       It includes checks for:
       -Null or duplicate primary keys.
       -Unwanted spaces in string fields.
       -Data standardization and consistency.
       -Invalid date ranges and orders.
       -Data consistency between related fields.

Usage Notes:
      -Run these checks after data loading silver layer.
      -Investigate and resolve any issues found during the checks.
      -Replace silver by bronze,if you need show issues before transformation

======================================================================================
*/



/*
=======================
crm_cust_info Table
=======================
*/


---------we have primary keys duplicated as shown by belw query
select cst_id,count(*)
from silver.crm_cust_info
GROUP BY cst_id
HAVING count(*)  > 1 

---checking the repeated values by row_number window function
select *,ROW_NUMBER() OVER(partition by cst_id order by cst_create_date desc ) as flag_last
from silver.crm_cust_info
where cst_id = 29466     

select * from(
select *,ROW_NUMBER() OVER(partition by cst_id order by cst_create_date desc ) as flag_last
from silver.crm_cust_info )t 
where flag_last !=1

-------------checking unqiue values for cst_id (primary key)---------
select * from(
select *,ROW_NUMBER() OVER(partition by cst_id order by cst_create_date desc ) as flag_last
from silver.crm_cust_info
where cst_id is not null )t 
where flag_last =1    

-------Check For Unwanted Spaces in String Values

select cst_firstname 
from silver.crm_cust_info
where cst_firstname != TRIM(cst_firstname)

select cst_lastname
from  silver.crm_cust_info
where cst_lastname !=  TRIM(cst_lastname)

SELECT cst_gndr
FROM silver.crm_cust_info
where cst_gndr != TRIM(cst_gndr)

------------Check Data Standardization & Consistency 

select DISTINCT cst_gndr
from silver.crm_cust_info

select DISTINCT cst_material_status
from silver.crm_cust_info


/*
=======================
crm_prd_info Table
=======================
*/

select prd_id , count(*)
from silver.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null

select prd_cost 
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null

SELECT DISTINCT prd_line 
from  silver.crm_prd_info

select * from 
silver .crm_prd_info
where prd_end_dt < prd_start_dt

select * from silver.crm_prd_info

/*
=========================
crm_sales_details Table
=========================
*/

select 
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from silver.crm_sales_details

----------------Checking First Column 
select 
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from silver.crm_sales_details
where sls_ord_num != trim(sls_ord_num)

-------------------Checking sls_prd_key with other table joining
select 
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from silver.crm_sales_details 
where sls_prd_key not in (select prd_key from silver.crm_prd_info)

-------------------Checking sls_cust_id with other table joinig
select 
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from silver.crm_sales_details 
where sls_cust_id not in (select cst_id from silver.crm_cust_info)

-------------there are no issues in first 3 columns--------------

-------------check for invalid dates (3 Columns for date)
-------------negative numbers or zeroes cant be cast to a date
-------------replace zero values with null using (NULLIF Function)
--------------to cast from intger to date we should convert first to varchar then to date
select 
NULLIF(sls_order_dt,0) as sls_order_dt
from bronze.crm_sales_details 
where sls_order_dt <= 0 
or len(sls_order_dt) !=8
or sls_order_dt > 20500101
or sls_order_dt > 19000101

select 
NULLIF(sls_ship_dt,0) as sls_ship_dt
from bronze.crm_sales_details 
where sls_ship_dt <= 0 
or len(sls_ship_dt) !=8
or sls_ship_dt > 20500101
or sls_ship_dt > 19000101

select 
NULLIF(sls_due_dt,0) as sls_due_dt
from bronze.crm_sales_details 
where sls_due_dt <= 0 
or len(sls_due_dt) !=8
or sls_due_dt > 20500101
or sls_due_dt > 19000101

----------Checking for Invalid Date Orders (order date must be eariler than the shipping date or due date)
select * from silver.crm_sales_details
where
sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt

-------------------------------------------------------------------------------
---------Checking Last 3 Columns for Sales
---------Business Rule (Sum of Sales = Quantity*Price)
---------Negative,Zeros,Nulls are not Allowed!
---------RULES (IF SALES IS NEGATIVE ,ZERO OR NULL , derive it using Quantity and Price)
---------------(IF Price IS ZERO OR NULL , derive it using Quantity and Sales)
---------------(IF Price IS NEGATIVE,Convert it to a postive value)
select DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,

CASE WHEN sls_sales IS NULL OR sls_sales <=0 or sls_sales != sls_quantity*ABS(sls_price)
     THEN sls_quantity*ABS(sls_price)
     ELSE sls_sales
END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <= 0
     THEN sls_sales / NULLIF(sls_quantity,0)
     ELSE sls_price
END AS sls_price      
from silver.crm_sales_details
where
sls_sales != sls_quantity*sls_price
or sls_sales IS NULL or sls_quantity IS NULL or sls_price IS NULL
or sls_sales <=0 or sls_quantity <=0 or sls_price <=0
order by sls_sales,sls_quantity,sls_price

/*
=========================
crm_sales_details Table
=========================
*/

--Remove NAS From cid to match cst_key in silver.crm_cust_info
select
CASE WHEN cid like '%NAS%' THEN SUBSTRING(cid,4,len(cid))
     ELSE cid
END AS cid,
bdate,
gen
from 
silver.erp_cust_az12

------------------Checking Second Column bdate (Data Type is Date)
------------Identify out of ranges date (Gretaer than 100 and check age in Future)
select DIStINCT 
bdate
From silver.erp_cust_az12
where
bdate < '1924-01-01' or bdate > GETDATE()

-----------Transformation of that
select
CASE WHEN cid like '%NAS%' THEN SUBSTRING(cid,4,len(cid))
     ELSE cid
END AS cid,
CASE WHEN bdate > GETDATE() THEN NULL
      ELSE bdate
END AS bdate,
bdate,
gen
from 
silver.erp_cust_az12

------------------------Checking Last Column
------------------------Data Standardization & Consistency
select DISTINCT 
CASE WHEN upper(trim(gen)) IN ('f','FEMALE') THEN 'FEMALE'
     WHEN upper(trim(gen)) IN ('M','MALE')   THEN 'MALE'
     ELSE 'N/A'
END AS gen
from silver.erp_cust_az12

---------------------------------Final Query After Cleaning---------------
select
CASE WHEN cid like '%NAS%' THEN SUBSTRING(cid,4,len(cid))
     ELSE cid
END AS cid,
CASE WHEN bdate > GETDATE() THEN NULL
      ELSE bdate
END AS bdate,
bdate,
CASE WHEN upper(trim(gen)) IN ('f','FEMALE') THEN 'FEMALE'
     WHEN upper(trim(gen)) IN ('M','MALE')   THEN 'MALE'
     ELSE 'N/A'
END AS gen
from 
silver.erp_cust_az12

/*
=========================
silver.erp_loc_a101 Table
=========================
*/


-----Checking relations between tables by data modeling 
select cid , cntry from bronze.erp_loc_a101
select cst_key from silver.crm_cust_info
------------

select
REPLACE(cid,'-','') as cid,
CASE WHEN upper(trim(cntry)) IN ('USA','US') THEN 'USA'
     WHEN upper(trim(cntry)) = 'DE' THEN 'Germany'
     WHEN upper(trim(cntry)) = ' ' or cntry IS NULL then 'n/a'
     ELSE trim(cntry)
END AS cntry
from silver.erp_loc_a101

--------------------Checking second columns------------
Select DISTINCT cntry 
from
silver.erp_loc_a101
ORDER BY cntry

-------------------------------final query after cleaning---------
select
REPLACE(cid,'-','') as cid,
CASE WHEN upper(trim(cntry)) IN ('USA','US') THEN 'USA'
     WHEN upper(trim(cntry)) = 'DE' THEN 'Germany'
     WHEN upper(trim(cntry)) = ' ' or cntry IS NULL then 'n/a'
     ELSE trim(cntry)
END AS cntry
from silver.erp_loc_a101


/*
=========================
erp_px_cat_g1v2 Table
=========================
*/


select 
id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2

select * from silver.crm_prd_info


----No unwanted spaces

select
*
from bronze.erp_px_cat_g1v2
where  cat != TRIM(cat) or subcat != TRIM(subcat) or maintenance != TRIM(maintenance)

-----------Check Data Standardization and Consistency
select distinct cat , subcat , maintenance
from bronze.erp_px_cat_g1v2
