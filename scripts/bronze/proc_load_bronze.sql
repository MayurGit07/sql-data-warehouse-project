/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================

Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
        - Truncates the bronze tables before loading data.
        - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.
*/



create or alter procedure bronze.load_bronze as   --chage (alter) if the procedure already exists
begin
	declare @srt_time datetime , @end_time datetime ,@srt_all_batch datetime, @end_all_batch datetime  --give 2 variables
	

	begin TRY
		SET @srt_all_batch = GETDATE()   --for all process time

		SET @srt_time = GETDATE()  --similarly we can do it for every loadtable

		PRINT 'we LOAD "crm" source tables in bronze layer in this part of procedure'
		TRUNCATE TABLE bronze.crm_cust_info;  --empy  tbl 

		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\MAYUR CHAVAN\Downloads\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2 ,   --IN 'CSV' THE REAL DATTA START FROM 2ND ROW, 1ST ROW IS CLMN NAME
			FIELDTERMINATOR = ',' , --as it is CSV file
			TABLOCK  --from now till tbl fully loaded lock the tbl (no changes in source will be affteef on the tbl)
		);

		select count(*)
		from bronze.crm_cust_info

		SET @end_time = GETDATE()

		print 'load_time "cust_info" tbl: ' + cast(datediff(second, @srt_time, @end_time) as Nvarchar(10)) + ' s'

		/*TO CHECK
		correct datat in correct clmn
		count rows and cross check by csv

		--doig same for all other 5 files
		*/

		SET @srt_time = GETDATE()

		TRUNCATE TABLE bronze.crm_prd_info; 
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\MAYUR CHAVAN\Downloads\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2 ,   
			FIELDTERMINATOR = ',' , 
			TABLOCK  
		);
		select count(*)
		from bronze.crm_prd_info

		
		SET @end_time = GETDATE()

		print 'load_time "prd_info" tbl: ' + cast(datediff(second, @srt_time, @end_time) as Nvarchar(10)) + ' s'


		TRUNCATE TABLE bronze.crm_sales_details; 
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\MAYUR CHAVAN\Downloads\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2 ,   
			FIELDTERMINATOR = ',' , 
			TABLOCK  
		);
		select count(*)
		from bronze.crm_sales_details


		PRINT 'we LOAD "erp" source tables in bronze layer in this part of procedure'

		TRUNCATE TABLE bronze.erp_cust_az12; 
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\MAYUR CHAVAN\Downloads\sql-data-warehouse-project-main\datasets\source_erp\cust_az12.csv'  --windows is NOT case-sens when it comes to giving location
		--the og name of file is 'CUST_AZ12.csv' but we wrote 'cust_az12.csv' so its ok
		WITH (
			FIRSTROW = 2 ,   
			FIELDTERMINATOR = ',' , 
			TABLOCK  
		);
		select count(*)
		from bronze.erp_cust_az12



		TRUNCATE TABLE bronze.erp_loc_a101; 
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\MAYUR CHAVAN\Downloads\sql-data-warehouse-project-main\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2 ,   
			FIELDTERMINATOR = ',' , 
			TABLOCK  
		);
		select count(*)
		from bronze.erp_loc_a101


		TRUNCATE TABLE bronze.erp_px_cat_g1v2; 
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\MAYUR CHAVAN\Downloads\sql-data-warehouse-project-main\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2 ,   
			FIELDTERMINATOR = ',' , 
			TABLOCK  
		);
		select count(*)
		from bronze.erp_px_cat_g1v2

		SET @end_all_batch = GETDATE()
	
		print 'total load_time bronze: ' + cast(datediff(second, @srt_all_batch, @end_all_batch) as Nvarchar(10)) + ' s'


	end TRY
	
	begin CATCH
		print 'THERE WAS SOME ERROR occusred during bronze layer LOADING'
		print 'the eroor messsage was' + error_message()
	end CATCH
end


--first excecute the all above things (to storre the procedure)

--execute bronze.load_bronze  then all this code an be exceutsed with htis sinlge code

