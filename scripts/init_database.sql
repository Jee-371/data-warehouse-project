/*
Title: 
Purpose:
Warning: 
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

-- Create Schemas

CREATE SCHEMA bronze
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
