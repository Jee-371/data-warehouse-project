/*
Title: Data Warehouse Initialization Script
Purpose: 
- To create a new SQL Server database named 'DataWarehouse'.
- To define layered schemas: bronze, silver, and gold for ETL processing stages.

Warning: 
- This script will **drop** the existing 'DataWarehouse' database if it exists.
- Ensure there is no valuable data before executing.
*/

-- CREATE DATABASE 
USE master;
GO
IF EXISTS (SELECT 1 FROM sys.database WHERE name = 'DataWarehouse'
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

CREATE SCHEMA bronze
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
