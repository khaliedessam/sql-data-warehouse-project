======================================================================
DDL Script: Create Bronze Tables
======================================================================
Script Purpose:
This Script creates tables in the 'bronze schema',dropping existing tables 
if they already exist.
Run this script to re-define the DDL structure of 'bronze' Tables 
======================================================================




------Create Datebase-------
use master
create database DataWarehouse;
use DataWarehouse;

create schema bronze;
go
create schema silver;
go
create schema gold;
go

-------Table Creations----------------
CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_material_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE
);

CREATE TABLE bronze.crm_prd_info (
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

CREATE TABLE bronze.erp_cust_az12 (
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50)
);

CREATE TABLE bronze.erp_loc_a101 (
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
);

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
);

-----------------------load data from source to datawarehouse-----------------
-----First table------------
truncate table bronze.crm_cust_info
bulk insert bronze.crm_cust_info
from 'D:\SQL ITI\Data With Baraa\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
----check data insertion-----
select * from bronze.crm_cust_info
select count(*) from bronze.crm_cust_info

-------------second table-------
truncate table bronze.crm_prd_info
bulk insert bronze.crm_prd_info
from 'D:\SQL ITI\Data With Baraa\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
----check data insertion-----
select * from bronze.crm_prd_info
select count(*) from bronze.crm_prd_info

--------------third table--------------
truncate table bronze.crm_sales_details
bulk insert bronze.crm_sales_details
from 'D:\SQL ITI\Data With Baraa\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
----check data insertion-----
select * from bronze.crm_sales_details
select count(*) from bronze.crm_sales_details

----------------fourth table----------------
truncate table bronze.erp_cust_az12
bulk insert bronze.erp_cust_az12
from 'D:\SQL ITI\Data With Baraa\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
----check data insertion-----
select * from bronze.erp_cust_az12
select count(*) from bronze.erp_cust_az12

--------------------------fifth table--------------------------
truncate table bronze.erp_loc_a101
bulk insert bronze.erp_loc_a101
from 'D:\SQL ITI\Data With Baraa\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
----check data insertion-----
select * from bronze.erp_loc_a101
select count(*) from bronze.erp_loc_a101

----------------------sixth table------------------------------------
truncate table bronze.erp_px_cat_g1v2
bulk insert bronze.erp_px_cat_g1v2
from 'D:\SQL ITI\Data With Baraa\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
----check data insertion-----
select * from bronze.erp_px_cat_g1v2
select count(*) from bronze.erp_px_cat_g1v2

---------------------------creation of stored procedure for bronze layer--------------
create or alter procedure bronze.load_bronze as
begin
     declare @start_time Datetime, @end_time Datetime;
     begin try
print'=============================================';
print'loading bronze layer';
print'=============================================';
print'---------------------------------------------';
print'loading crm tables';
print'---------------------------------------------';

set @start_time = GETDATE();
print'>>truncating table: bronze.crm_cust_info';
truncate table bronze.crm_cust_info
print'>>inserting table: bronze.crm_cust_info';

bulk insert bronze.crm_cust_info
from 'D:\SQL ITI\Data With Baraa\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time = GETDATE();
print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar) +  'seconds';
print'---------------------------------------'

set @start_time = GETDATE();
print'>>truncating table: bronze.crm_prd_info';
truncate table bronze.crm_prd_info
print'>>inserting table: bronze.crm_prd_info';

bulk insert bronze.crm_prd_info
from 'D:\SQL ITI\Data With Baraa\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time = GETDATE();
print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar) +  'seconds';
print'---------------------------------------'


set @start_time = GETDATE();
print'>>truncating table: bronze.crm_sales_details';
truncate table bronze.crm_sales_details
print'>>inserting table: bronze.crm_sales_details';

bulk insert bronze.crm_sales_details
from 'D:\SQL ITI\Data With Baraa\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time = GETDATE();
print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar) +  'seconds';
print'---------------------------------------'



print'---------------------------------------------';
print'loading erb tables';
print'---------------------------------------------';

set @start_time = GETDATE();
print'>>truncating table: bronze.erp_cust_az12';
truncate table bronze.erp_cust_az12

print'>>inserting table: bronze.erp_cust_az12';

bulk insert bronze.erp_cust_az12
from 'D:\SQL ITI\Data With Baraa\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time = GETDATE();
print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar) +  'seconds';
print'---------------------------------------'


set @start_time = GETDATE();
print'>>truncating table: bronze.erp_loc_a101';
truncate table bronze.erp_loc_a101

print'>>inserting table: bronze.erp_loc_a101';

bulk insert bronze.erp_loc_a101
from 'D:\SQL ITI\Data With Baraa\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time = GETDATE();
print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar) +  'seconds';
print'---------------------------------------'


set @start_time = GETDATE();
print'>>truncating table: bronze.erp_px_cat_g1v2';
truncate table bronze.erp_px_cat_g1v2

print'>>inserting table: bronze.erp_px_cat_g1v2';

bulk insert bronze.erp_px_cat_g1v2
from 'D:\SQL ITI\Data With Baraa\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time = GETDATE();
print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar) +  'seconds';
print'---------------------------------------'

     end try
     begin catch
     
     print'=================================';
     print'Error occured during loading bronze layer';
     print'Error Message'+ Error_message() ;


     end catch
end 

--------------------checking procedure------------
exec bronze.load_bronze

----------------------------------------------------------
