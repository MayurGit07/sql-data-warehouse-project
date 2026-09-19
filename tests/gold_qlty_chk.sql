/*
============================================================================
Quality Checks
============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency,
    and accuracy of the Gold layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
============================================================================
*/

--we can do more types of checks if want
--CUSTOMERS

select [cst_id],count(*) from(
select ci.[cst_id]
      ,ci.[cst_key]
      ,ci.[cst_firstname]
      ,ci.[cst_lastname]
      ,ci.[cst_material_status]
      ,ci.[cst_gndr]
      ,ci.[cst_create_date]
      ,ca.bdate
      ,ca.gen
      ,la.cntry
from silver.crm_cust_info as ci
left join silver.erp_cust_az12 as ca
on ci.cst_key  = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid) as x
group by [cst_id]
having count(*)>1  


--PRODUCTS

select 
prd_key,  --as we use it later to join sales tbls
count(*) from(
select
       [prd_id]
      ,[cat_id]
      ,[prd_key]
      ,[prd_nm]
      ,[prd_cost]
      ,[prd_line]
      ,[prd_start_dt]
      ,[prd_end_dt]
      ,pc.cat
      ,pc.subcat,
      pc.maintenance
from silver.crm_prd_info as pn
left join silver.erp_px_cat_g1v2 as pc
on pn.cat_id = pc.id
where pn.prd_end_dt is null ) as x
group by prd_key
having count(*) >1

--GOLD

--qualoity chek of fact
select* from gold.fact_sales as f
left join gold.dim_customers as c
on f.customer_key= c.customer_key
where c.customer_key is null      --no rsult means evrey things matches


select* from gold.fact_sales as f
left join gold.dim_products as p
on f.product_key= p.product_key
where p.product_key is null         --no rsult means evrey things matches
