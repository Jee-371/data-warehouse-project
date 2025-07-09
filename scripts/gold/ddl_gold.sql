/*
Purpose: Create Gold Layer Views for Analytical Consumption

Overview:
- Gold layer serves as the presentation/consumption layer in the data warehouse.
- Data is structured into dimensional (dim) and fact views following a star schema model.
- Views consolidate cleansed Silver layer data into business-friendly formats.

Views:

1. gold.dim_customers
   - Customer dimension combining CRM and ERP attributes.
   - Resolves gender using CRM first, and falls back on ERP if needed.
   - Adds surrogate key (customer_key) via ROW_NUMBER for BI tools.

2. gold.dim_products
   - Product dimension enriched with ERP category metadata.
   - Filters only current (active) products by checking for NULL `prd_end_dt`.
   - Adds surrogate key (product_key) via ROW_NUMBER.

3. gold.fact_sales
   - Sales fact table linking to both customer and product dimensions.
   - Joins Silver CRM sales with Gold layer dimensions to support star schema design.
   - Includes order dates, pricing, and quantity for sales analytics.

Warning:
- Ensure Silver layer data is fully loaded and consistent before creating or querying these views.
- These views are read-only abstractions and will always reflect the current state of the underlying Silver data.
*/

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ca.bdate AS birthdate,
	cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid


CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
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
WHERE prd_end_dt IS NULL


CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price

FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id
