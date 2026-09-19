/*
============================================================================
DDL Script: Create Gold Views
============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema).

    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
============================================================================
*/







create view gold.dim_customers as 
select 
        ROW_number() over(order by ci.[cst_id]) as customer_key  --not same as cust_key   --we can choose any clmn to ord by cust key
       ,ci.[cst_id] as customer_id
      ,ci.[cst_key] as customer_number
      ,ci.[cst_firstname] as first_name
      ,ci.[cst_lastname] last_name
      ,ca.bdate as brithdate
      ,la.cntry as country
      ,ci.[cst_material_status] as material_status
      ,case when ci.[cst_gndr] != 'N/A' then ci.cst_gndr  --CRM is master(main)
            else coalesce(ca.gen,'N/A')
            end as gender
      ,ci.[cst_create_date] as create_date
      
from silver.crm_cust_info as ci
left join silver.erp_cust_az12 as ca
on ci.cst_key  = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid


create view gold.dim_products as 
select
        row_number() over(order by prd_start_dt, [prd_key]) as product_key
       ,[prd_id] product_id
      ,[prd_key] product_number
      ,[prd_nm] product_name
      ,[cat_id] catagry_id
      ,[prd_cost] product_cost
      ,pc.cat   product_catagory
      ,pc.subcat product_subcatagory
      ,pn.prd_line  product_line
      ,pc.maintenance maintenance
      ,[prd_start_dt] start_dt              --removesd end date as all null
from silver.crm_prd_info as pn
left join silver.erp_px_cat_g1v2 as pc
on pn.cat_id = pc.id
where pn.prd_end_dt is null


create view gold.fact_sales as
select
       [sls_ord_num] as order_number
       ,pr.product_key    --the surrgate key we made, it acts like a loaction of books in library       
       ,cu.customer_key  --the surrgate key we made
      ,[sls_order_dt] order_date
      ,[sls_ship_dt] ship_date
      ,[sls_due_dt]  due_date
      ,[sls_sales]     sales
      ,[sls_quantity]   quantity
      ,[sls_price]  price
    from silver.crm_sales_details as sd
left join gold.dim_products as pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers as cu
on sd.sls_cust_id = cu.customer_id


