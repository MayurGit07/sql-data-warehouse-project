/*
==============================================================================
Quality Checks
==============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schema. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
==============================================================================
*/

--                          CRM_CUST_INFO
--quality check of our inserted tbl in table

select
cst_id,
count(*) as counted
from silver.crm_cust_info
group by cst_id
having count(*) != 1 or cst_id IS NULL  --nothing as expected, so so repeat and NO NULL

select*
from silver.crm_cust_info
where cst_firstname != trim(cst_firstname) or cst_lastname != trim(cst_lastname) --found NO space in frst and last name

select distinct(cst_material_status)   --S M , NO N/A SHOWING, DON'T KNOW WHY.
from silver.crm_cust_info
select distinct(cst_gndr)   --M F and NULL
from silver.crm_cust_info


select*
from bronze.crm_cust_info
where cst_material_status != 'S' and cst_material_status != 'M' 

--                          CRM_PRD_INFO
--quality check of our inserted tbl in table


select
prd_id,
count(*) as counted
from silver.crm_prd_info
group by prd_id
having count(*) != 1 or prd_id IS NULL 

select
*
from silver.crm_prd_info
where prd_cost <0 or prd_cost is null

select distinct prd_line
from silver.crm_prd_info

--chcek invalid date order

select*
from silver.crm_prd_info
where prd_start_dt > prd_end_dt
select*
from silver.crm_prd_info

--                          CRM_SLS_INFO
--quality check of our inserted tbl in table

select*
from silver.crm_sales_details
where (sls_sales != sls_quantity * sls_price) or 
(sls_sales is null) or (sls_quantity is null) or (sls_price is null) or
(sls_sales <= 0) or (sls_quantity <= 0) or (sls_price <= 0)
order by sls_sales

--                     silver.erp_cust_az12
--quality check
select* from silver.erp_cust_az12 where len(cast(bdate as varchar(20))) != 10 --all clear
or bdate > GETDATE() --problem

select distinct gen
from silver.erp_cust_az12


--                          erp_loc_a101
--quality check of our inserted tbl in table



select* from silver.erp_loc_a101 
where cid like ('%-%') 


select distinct cntry from bronze.erp_loc_a101 


--                       erp_px_cat_g1v2
--quality check

select distinct
cat, subcat, maintenance
from silver.erp_px_cat_g1v2


SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat) or maintenance != TRIM(maintenance) ;
