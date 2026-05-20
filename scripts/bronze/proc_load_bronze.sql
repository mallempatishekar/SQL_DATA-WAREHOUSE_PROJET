/*
==============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
==============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
==============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    declare @start_time datetime, @end_time datetime
    BEGIN TRY
        PRINT '=======================================';
        PRINT 'Loading CRM';
        PRINT '=======================================';
        set @start_time = getdate();

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\Shekar\Downloads\sql-data-warehouse-project (1)\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        set @end_time = getdate();
        print'load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\Shekar\Downloads\sql-data-warehouse-project (1)\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\Shekar\Downloads\sql-data-warehouse-project (1)\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        PRINT '=======================================';
        PRINT 'Loading ERP';
        PRINT '=======================================';

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\Shekar\Downloads\sql-data-warehouse-project (1)\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\Shekar\Downloads\sql-data-warehouse-project (1)\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\Shekar\Downloads\sql-data-warehouse-project (1)\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

    END TRY
    BEGIN CATCH
        PRINT '===============================';
        PRINT 'Error during loading Bronze layer';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: '  + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: '   + CAST(ERROR_STATE()  AS NVARCHAR);
        PRINT '===============================';
    END CATCH
END
