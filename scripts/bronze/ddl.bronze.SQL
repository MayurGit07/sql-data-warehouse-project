/*

SQL - 15.SQL - 02.Bronze_ddl
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================

Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
if object_id ('bronze.crm_cust_info', 'u') is not null
    DRop table bronze.crm_cust_info
create table bronze.crm_cust_info(  --followed the naming convnetion
	cst_id					INT,
	cst_key					NVARCHAR(50),
	cst_firstname			NVARCHAR(50),
	cst_lastname			NVARCHAR(50),
	cst_material_status		NVARCHAR(50),
	cst_gndr				NVARCHAR(50),
	cst_create_date			DATE
);

if object_id ('bronze.crm_prd_info', 'u') is not null
    DRop table bronze.crm_prd_info
CREATE TABLE bronze.crm_prd_info(
    prd_id			INT,
    prd_key			NVARCHAR(50),
    prd_nm			NVARCHAR(100),
    prd_cost		INT,
    prd_line		NVARCHAR(10),
    prd_start_dt	DATETIME,
    prd_end_dt		DATEtime
);

if object_id ('bronze.crm_sales_details', 'u') is not null
    DRop table bronze.crm_sales_details
CREATE TABLE bronze.crm_sales_details(
sls_ord_num				NVARCHAR(20),
sls_prd_key				NVARCHAR(10),
sls_cust_id				INT,
sls_order_dt			INT,
sls_ship_dt				INT,
sls_due_dt				INT,
sls_sales				INT,
sls_quantity			INT,
sls_price				INT
);

if object_id ('bronze.erp_cust_az12', 'u') is not null
    DRop table bronze.erp_cust_az12
CREATE TABLE bronze.erp_cust_az12(
    cid NVARCHAR(30),
    bdate DATE,
    --gen NVARCHAR(5)
    --it shows eoor while BULK insert as FEMALE is more than 5 characters
    gen NVARCHAR(10)
);


if object_id ('bronze.erp_loc_a101', 'u') is not null
    DRop table bronze.erp_loc_a101
CREATE TABLE bronze.erp_loc_a101(
    cid NVARCHAR(30),
    cntry NVARCHAR(20)
);


if object_id ('bronze.erp_px_cat_g1v2', 'u') is not null
    DRop table bronze.erp_px_cat_g1v2
CREATE TABLE bronze.erp_px_cat_g1v2(
    id NVARCHAR(10),
    cat NVARCHAR(20),
    subcat NVARCHAR(30),
    maintenance NVARCHAR(5)
);
