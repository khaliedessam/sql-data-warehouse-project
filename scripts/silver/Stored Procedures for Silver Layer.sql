/*
==========================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
==========================================================
Script Purpose:
       This stored procedure performs the ETL (Extract, Transform, Load) process to
       populate the 'silver' schema tables from the 'bronze' schema.

Actoins Performed:
       -Truncate Silver Tables.
	   -Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
	   None.
	   This stored procedure does not accept any parameters or return values.
	
Usage Example:
       EXEC Silver.load_silver;
============================================================
*/

create or alter procedure silver.load_silver as
begin
      declare @start_time Datetime, @end_time Datetime
     begin try
print 'Loading Silver Layer'
print '===================='
print 'Loading Crm Tables'
print'====================='
print '>> Truncating TABLE: silver.crm_cust_info';

set @start_time = getdate();
TRUNCATE TABLE silver.crm_cust_info;
print '>> Inserting Data Into: silver.crm_cust_info';
INSERT INTO silver.crm_cust_info (
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_material_status,
cst_gndr,
cst_create_date)

select cst_id , cst_key,
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname) as cst_lasttname,
case when cst_material_status='M' then 'Married'
     when cst_material_status='S' then 'Single'
     else 'n/a'
end cst_material_status,
case when upper(TRIM(cst_gndr))='F' then 'Female'
     when upper(TRIM(cst_gndr))='M' Then 'Male'
     else 'n/a'
end cst_gndr,
cst_create_date 
from (
select *,ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as flag_last
from bronze.crm_cust_info 
where cst_Id is not null )t 
where flag_last = 1

set @end_time = getdate();
print 'Load Duration:'+ cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';

print'==========================================='

set @start_time = getdate();
print '>> Truncating TABLE:  silver.crm_prd_info';
TRUNCATE TABLE  silver.crm_prd_info;
print '>> Inserting Data Into:  silver.crm_prd_info';
   insert into silver.crm_prd_info (
   prd_id,
   cat_id,
   prd_key,
   prd_nm,
   prd_cost,
   prd_line,
   prd_start_dt,
   prd_end_dt
   )    
select 
prd_id,
Replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
prd_nm,
ISNULL(prd_cost,0) as prd_cost,
CASE WHEN Upper(TRIM(prd_line)) = 'M' then 'Mountain'
     WHEN Upper(TRIM(prd_line)) = 'R' then 'Road'
     WHEN Upper(TRIM(prd_line)) = 'S' then 'other Sales'
     WHEN Upper(TRIM(prd_line)) = 'T' then 'Touring'
     else 'n/a'
END as prd_line,
cast(prd_start_dt as date) as prd_start_dt,
cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as date ) as prd_end_dt_test
from bronze.crm_prd_info

set @end_time = getdate();
print'Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds';
print'==========================================='



set @start_time = getdate();

print '>> Truncating TABLE: silver.crm_sales_details';
TRUNCATE TABLE silver.crm_sales_details;
print '>> Inserting Data Into: silver.crm_sales_details';
INSERT INTO silver.crm_sales_details (
 
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)

select 
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
     else CAST(cast(sls_order_dt as varchar) AS date)
END AS sls_order_dt ,
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
     else CAST(cast(sls_ship_dt as varchar) AS date)
END AS sls_ship_dt ,
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
     else CAST(cast(sls_due_dt as varchar) AS date)
END AS sls_due_dt ,
CASE WHEN sls_sales IS NULL OR sls_sales <=0 or sls_sales != sls_quantity*ABS(sls_price)
     THEN sls_quantity*ABS(sls_price)
     ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE WHEN sls_price IS NULL OR sls_price <= 0
     THEN sls_sales / NULLIF(sls_quantity,0)
     ELSE sls_price
END AS sls_price      
from bronze.crm_sales_details
set @end_time = getdate();
print'Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds';
print'==========================================='


print 'Loading erp Tables'
print'====================='

set @start_time = getdate();

print '>> Truncating TABLE: silver.erp_cust_az12';
TRUNCATE TABLE silver.erp_cust_az12;
print '>> Inserting Data Into: silver.erp_cust_az12';
INSERT INTO silver.erp_cust_az12 (cid,bdate,gen )
select
CASE WHEN cid like '%NAS%' THEN SUBSTRING(cid,4,len(cid))
     ELSE cid
END AS cid,
CASE WHEN bdate > GETDATE() THEN NULL
      ELSE bdate
END AS bdate,
CASE WHEN upper(trim(gen)) IN ('f','FEMALE') THEN 'Female'
     WHEN upper(trim(gen)) IN ('M','MALE')   THEN 'Male'
     ELSE 'n/a'
END AS gen
from 
bronze.erp_cust_az12
 set @end_time = getdate();
 print'Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds';

 print'==========================================='


 set @start_time = getdate();

print '>> Truncating TABLE: erp_loc_a101';
TRUNCATE TABLE silver.erp_loc_a101;
print '>> Inserting Data Into: erp_loc_a101';
INSERT INTO silver.erp_loc_a101 (
cid,
cntry )
select
REPLACE(cid,'-','') as cid,
CASE WHEN upper(trim(cntry)) IN ('USA','US') THEN 'USA'
     WHEN upper(trim(cntry)) = 'DE' THEN 'Germany'
     WHEN upper(trim(cntry)) = ' ' or cntry IS NULL then 'n/a'
     ELSE trim(cntry)
END AS cntry
from bronze.erp_loc_a101
set @end_time = getdate();
print'Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds';
print'==========================================='


set @start_time = getdate();

print '>> Truncating TABLE: erp_px_cat_g1v2';
TRUNCATE TABLE silver.erp_px_cat_g1v2;
print '>> Inserting Data Into: erp_px_cat_g1v2';
insert into silver.erp_px_cat_g1v2 (
id,
cat,
subcat,
maintenance )

select 
id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2
 set @end_time = getdate();
print'Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds';
print'==========================================='

     end try

    begin catch
print'=================================';
     print'Error occured during loading silver layer';
     print'Error Message'+ Error_message() ;
    end catch
end
--------------------Check Silver Procedures----
execute silver.load_silver


