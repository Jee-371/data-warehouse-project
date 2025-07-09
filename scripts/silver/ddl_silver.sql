/*
Purpose: Create Silver Layer Tables for Cleansed and Structured Data

Overview:
- Silver layer serves as the cleansed and semi-transformed staging area in the Data Warehouse.
- These tables are enhanced versions of Bronze layer data with standardized formats and derived fields.
- A column `dwh_create_date` is added to each table to track data load timestamp.

Warning:
- Existing Silver layer tables will be dropped and recreated.
- Ensure downstream dependencies are managed before executing.

Tables:
1. silver.crm_cust_info         -- Cleansed CRM customer information with ingestion timestamp
2. silver.crm_prd_info          -- CRM product data with product category reference
3. silver.crm_sales_details     -- CRM sales transactions with corrected date types
4. silver.erp_cust_az12         -- ERP customer demographic data
5. silver.erp_loc_a101          -- ERP customer location details
6. silver.erp_px_cat_g1v2       -- ERP product category hierarchy
*/

IF OBJECT_ID ('silver.crm_cust_info','U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_prd_info','U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
prd_id INT,
cat_id NVARCHAR(50),
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_sales_details','U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_cust_az12','U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12 (
cid NVARCHAR(50),
bdate DATE,
gen NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_loc_a101','U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101 (
cid NVARCHAR(50),
cntry NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;

CREATE TABLE silver.erp_px_cat_g1v2 (
id NVARCHAR(50),
cat NVARCHAR(50),
subcat NVARCHAR(50),
maintenance NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
