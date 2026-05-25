
/*
===============================================================================
Quality Checks
===============================================================================

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
===============================================================================
*/
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- Data Standardization & Consistency

SELECT DISTINCT
    gen,
    case when upper(trim(gen)) in ('F','Female') then 'Female'
         when upper(trim(gen)) in ('M','Male') then 'Male'
         else 'n/a'
    end as gen
FROM silver.erp_cust_az12;


-----------------------

-- data consistent
select distinct cntry as oldcountry,
case when trim(cntry) = 'DE' then 'Germany'
         when trim(cntry) in ('US','USA') then 'United States'
         when trim(cntry) = '' or cntry is NULL then 'n/a'
         else trim(cntry)
    end as cntry
from bronze.erp_loc_a101
order by cntry

-------------------------
select id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2

--check forspaces
select * from bronze.erp_px_cat_g1v2
where cat!= trim(cat) or subcat!=trim(subcat) or maintenance != trim(maintenance)


-----data standardization and consistency
select distinct 
maintenance
from bronze.erp_px_cat_g1v2




--------------------------------
-- Check for Invalid Dates

SELECT
    NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
   OR LEN(sls_order_dt) != 8
   OR sls_order_dt > 20500101
   OR sls_order_dt < 19000101



   -- Check for Invalid Date Orders

SELECT
    *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt

   -------------------------------------

   SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price as old_sales_price,
    case when sls_sales is NULL or sls_sales < =0 or sls_sales != sls_quantity * abs(sls_price)
    then sls_quantity * abs(sls_price)
    end as sls_sales,
CASE 
    WHEN sls_price IS NULL OR sls_price <= 0
        THEN sls_sales / NULLIF(sls_quantity, 0)
    ELSE sls_price
END AS sls_price

FROM bronze.crm_sales_details

WHERE sls_sales != sls_quantity * sls_price








-----------------------
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
   order by sls_sales,sls_quantity,sls_price
-------------------------
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

--------------------------------------------------------

--check for unwanted spaces
select cst_gndr
from silver.crm_cust_info
where cst_gndr != trim(cst_gndr)

--data standardization and consistency
select distinct cst_gndr
from silver.crm_cust_info

select * from silver.crm_cust_info
DELETE FROM silver.crm_cust_info;

SELECT
    prd_id,
    prd_key,
    prd_nm,
    prd_start_dt,
    prd_end_dt,
    lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)as prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')

select * from bronze.crm_prd_info
