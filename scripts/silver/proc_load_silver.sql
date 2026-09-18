/*
SQL - 15.SQL - 17.S_StrdPrcdre.sql
==============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
==============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.

Actions Performed:
    - Truncates Silver tables.
    - Inserts transformed and cleaned data from Bronze into Silver tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
==============================================================================
*/

create or alter procedure silver.load_silver as
	begin
		PRINT 'Truncating silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info
		PRINT 'Insertig silver.crm_cust_info '
		INSERT INTO silver.crm_cust_info (
		[cst_id]
			  ,[cst_key]
			  ,[cst_firstname]
			  ,[cst_lastname]
			  ,[cst_material_status]
			  ,[cst_gndr]
			  ,[cst_create_date]
		)

		select              --combine all solns we did above
			   [cst_id]
			  ,[cst_key]
			  ,TRIM([cst_firstname])
			  ,TRIM([cst_lastname])
			  ,case when upper(TRIm(cst_material_status ))= 'S' then 'Single'  
					when upper(TRIm(cst_material_status ))= 'M' then 'Married'
			   else 'N/A'
			   END as cst_material_status
			  ,case when upper(TRIm(cst_gndr ))= 'M' then 'Male'  
					when upper(TRIm(cst_gndr ))= 'F' then 'Female'
			   else 'N/A'
			   END as cst_gndr

			  ,[cst_create_date]
    
		from(
		select*,
		ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) as flag_last
		from bronze.crm_cust_info
		where cst_id is not null) as x 
		where x.flag_last = 1 ;



		PRINT 'Truncating silver.crm_prd_info'
		TRUNCATE TABLE silver.crm_prd_info
		PRINT 'Insertig silver.crm_prd_info '
		INSERT into silver.crm_prd_info (
		[prd_id]
			  ,[cat_id]
			  ,[prd_key]
			  ,[prd_nm]
			  ,[prd_cost]
			  ,[prd_line]
			  ,[prd_start_dt]
			  ,[prd_end_dt]
		)
		select 
		prd_id,
		REPLACE(SUBSTRING(prd_key,1,5), '-','_') as cat_id,
		SUBSTRING(prd_key,7,len(prd_key)) as prd_key_these_name_is_just_for_readiblity,
		prd_nm,
		ISNULL(prd_cost,0) as pdt_cost_no_need_for_proper_naming,
		case upper(TRIm(prd_line))
			when  'M' then 'Mountain'  
			when 'R' then 'Road'
			when'S' then 'OtherSales'
			when 'T' then 'Touring'
			else 'N/A'
		END as prd_line,
		CAST(prd_start_dt as DATE) prd_start_dt,
		CAST(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as DATE ) as end_dte_test
		from bronze.crm_prd_info



		PRINT 'Truncating silver.crm_sales_details'
		TRUNCATE TABLE silver.crm_sales_details
		PRINT 'Insertig silver.crm_sales_details '
		INSERT into silver.crm_sales_details(
		[sls_ord_num]
			  ,[sls_prd_key]
			  ,[sls_cust_id]
			  ,[sls_order_dt]
			  ,[sls_ship_dt]
			  ,[sls_due_dt]
			  ,[sls_sales]
			  ,[sls_quantity]
			  ,[sls_price])

		select
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		case when len(cast(sls_order_dt as VARCHAR(10))) = 8 then cast(cast(sls_order_dt as VARCHAR(10)) as date)  --thsi chekcs 0/ nulls, there are no negative or digits >8 we must chek
				  else NULL 
				  END as sls_order_dt,

		 case when len(cast(sls_ship_dt as VARCHAR(10))) = 8 then cast(cast(sls_ship_dt as VARCHAR(10)) as date)  --thsi chekcs 0 nulls, there are no negative or digits >8 we must chek
				  else NULL 
				  END as sls_ship_dt,

		 case when len(cast(sls_due_dt as VARCHAR(10))) = 8 then cast(cast(sls_due_dt as VARCHAR(10)) as date)  --thsi chekcs 0 nulls, there are no negative or digits >8 we must chek
				  else NULL 
				  END as sls_due_dt,
		case
				when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price) then sls_quantity * ABS(sls_price)
				else sls_sales
			end as sls_sales,

		sls_quantity,

		case 
				when sls_price is null or sls_price <=0 then sls_sales / NULLIF(sls_quantity,0)  --if its 0 make it NULl 
				else sls_price
			end as sls_price
		from bronze.crm_sales_details


		PRINT 'Truncating silver.erp_cust_az12'
		TRUNCATE TABLE silver.erp_cust_az12
		PRINT 'Insertig into silver.erp_cust_az12'
		INSERT into silver.erp_cust_az12
		 ([cid]
			  ,[bdate]
			  ,[gen])
		 select
		REPLACE(cid, 'NAS', '') as cid_new,
		case when bdate > GETDATE() then null
			else bdate 
		end as dob,
		case
			when gen in ('F','Female') then 'Female'
			when gen in ('M','Male') then 'Male'
			else 'N/A'
		end as Gndr
		from bronze.erp_cust_az12


		PRINT 'Truncating silver.erp_loc_a101'
		TRUNCATE TABLE silver.erp_loc_a101
		PRINT 'Insertig into silver.erp_loc_a101'
				INSERT into silver.erp_loc_a101 ( [cid]
			  ,[cntry]
		)
		select 
		replace(cid,'-','') as right_cid,
		case 
			when upper(TRIM (cntry)) IN ('DE','GERMANY') then 'Germany'
			when upper(TRIM (cntry)) in ('US','USA','UNITED STATES') then 'USA'
			when upper(TRIM (cntry)) = 'AUSTRALIA' then 'Australia'
			when upper(TRIM (cntry)) = 'UNITED KINGDOM' then 'United Kingdom'
			when upper(TRIM (cntry)) = 'CANADA' then 'Canada'
			when upper(TRIM (cntry)) = 'FRANCE' then 'France'
			else 'N/A'
		end as cntry_right
		from bronze.erp_loc_a101

		PRINT 'Truncating silver.erp_px_cat_g1v2'
		TRUNCATE TABLE silver.erp_px_cat_g1v2
		PRINT 'Insertig into silver.erp_px_cat_g1v2'
		INSERT into silver.erp_px_cat_g1v2 ([id]
			  ,[cat]
			  ,[subcat],maintenance
		)
		select 
		[id]
			  ,[cat]
			  ,[subcat]
			  ,[maintenance]
		from bronze.erp_px_cat_g1v2

	end
	
exec silver.load_silver
