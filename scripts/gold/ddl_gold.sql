/*
======================================================================
DDL Script: Create Gold Views
======================================================================
Script Purpose:
          This script creates views for the gold layer in the data warehouse.
          The Gold Layer represents the final dimension and final fact tables (Star Schema)

Each view perorms transformations and combines data from the silver layer 
to prooduce a clean, enriched, and business-ready dataset.

Usage:
     -These views can be queried directly for analytics and reporting.
===========================================================================
*/
--========================================================================
-- Create Dimension: gold.dim_customers
--=======================================================================

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
  DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers  AS
select 
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	la.cntry as country,
	ci.cst_material_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr ----CRM is the master for gender info
	     ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ca.bdate as birthdate,
	ci.cst_create_date as create_date
from silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
GO

-- ===================================================================
-- CREATE Fact table; gold.dim_products
-- ===================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
DROP VIEW 'gold.dim_products'

CREATE VIEW gold.dim_products as
SELECT 
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -----Filter out all historical data
GO

--=================================================================
--CRAETE Fact Table: gold.fact_sales
================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
DROP VIEW 'gold.fact_sales'

CREATE VIEW gold.dim_products as
SELECT 
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -----Filter out all historical data










