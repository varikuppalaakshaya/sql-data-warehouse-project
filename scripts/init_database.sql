use master;
go

  ----Drop and recreate the 'DataWarehouse'  database
  IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse'
  BEGIN
     ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
     DROP DATABASE DataWarehouse;
END;
GO

create database DataWarehouse; 

use DataWarehouse; 
create schema bronze;
create schema silver;
go
create schema gold;
go
