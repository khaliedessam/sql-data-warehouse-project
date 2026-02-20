/*
==============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)

Script Purpose:
      This stored procedure loads data into the 'bronze' schema from external CSV files.

Actions Perofrmed:
      -Truncate the bronze tables before loading data
      -use the 'Bulk insert' command to load data from csv files to bronze tables.

Parameters:
      None.
      This stored procedure does not accept any parameters or return any values.

Usage Example:
      EXEC bronze.load_bronze;
==============================================================================
*/


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

-----------------Checking Brnzoe Procedure------------

exec bronze.load_bronze