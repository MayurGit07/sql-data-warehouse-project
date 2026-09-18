/*
==============================================================================
DDL Script: Create Silver Tables
==============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'silver' tables.
==============================================================================
*/

if object_id ('silver.crm_cust_info', 'u') is not null
    DRop table silver.crm_cust_info
create table silver.crm_cust_info( 
	cst_id					INT,
	cst_key					NVARCHAR(50),
	cst_firstname			NVARCHAR(50),
	cst_lastname			NVARCHAR(50),
	cst_material_status		NVARCHAR(50),
	cst_gndr				NVARCHAR(50),
	cst_create_date			DATE,
    dwh_create_date         DATETIME DEFAULT GETDATE()  --METACLMN
);

--we did change a lot of things in 8.T2transform so we make new table
--if object_id ('silver.crm_prd_info', 'u') is not null
--    DRop table silver.crm_prd_info
--CREATE TABLE silver.crm_prd_info(
--    prd_id			INT,
--    prd_key			NVARCHAR(50),
--    prd_nm			NVARCHAR(100),
--    prd_cost		INT,
--    prd_line		NVARCHAR(10),
--    prd_start_dt	DATETIME,
--    prd_end_dt		DATEtime,
--dwh_create_date         DATETIME DEFAULT GETDATE()  --if no vlsue given write the cuurent date time we creatted
--);

--updated DDL aftre 8.Transform.sql
if object_id ('silver.crm_prd_info', 'u') is not null
    DRop table silver.crm_prd_info
CREATE TABLE silver.crm_prd_info(
    prd_id			INT,
    cat_id			NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm			NVARCHAR(100),
    prd_cost		INT,
    prd_line		NVARCHAR(10),
    prd_start_dt	DATE,
    prd_end_dt		DATE,
dwh_create_date         DATETIME DEFAULT GETDATE()  --if no vlsue given write the cuurent date time we creatted
);

--old ddl
/*if object_id ('silver.crm_sales_details', 'u') is not null
    DRop table silver.crm_sales_details
CREATE TABLE silver.crm_sales_details(
sls_ord_num				NVARCHAR(20),
sls_prd_key				NVARCHAR(10),
sls_cust_id				INT,
sls_order_dt			INT,
sls_ship_dt				INT,
sls_due_dt				INT,
sls_sales				INT,
sls_quantity			INT,
sls_price				INT,
dwh_create_date         DATETIME DEFAULT GETDATE()  --METACLMN
);*/

--updated ddl aftre 10.Transform.sql
if object_id ('silver.crm_sales_details', 'u') is not null
    DRop table silver.crm_sales_details
CREATE TABLE silver.crm_sales_details(
sls_ord_num				NVARCHAR(20),
sls_prd_key				NVARCHAR(20),
sls_cust_id				INT,
sls_order_dt			DATE,
sls_ship_dt				DATE,
sls_due_dt				DATE,
sls_sales				INT,
sls_quantity			INT,
sls_price				INT,
dwh_create_date         DATETIME DEFAULT GETDATE()  --METACLMN
);




if object_id ('silver.erp_cust_az12', 'u') is not null
    DRop table silver.erp_cust_az12
CREATE TABLE silver.erp_cust_az12(
    cid NVARCHAR(30),
    bdate DATE,
    gen NVARCHAR(10),
dwh_create_date         DATETIME DEFAULT GETDATE()  --METACLMN
);


if object_id ('silver.erp_loc_a101', 'u') is not null
    DRop table silver.erp_loc_a101
CREATE TABLE silver.erp_loc_a101(
    cid NVARCHAR(30),
    cntry NVARCHAR(20),
dwh_create_date         DATETIME DEFAULT GETDATE()  --METACLMN
);


if object_id ('silver.erp_px_cat_g1v2', 'u') is not null
    DRop table silver.erp_px_cat_g1v2
CREATE TABLE silver.erp_px_cat_g1v2(
    id NVARCHAR(10),
    cat NVARCHAR(20),
    subcat NVARCHAR(30),
    maintenance NVARCHAR(5),
dwh_create_date         DATETIME DEFAULT GETDATE()  --METACLMN
);




