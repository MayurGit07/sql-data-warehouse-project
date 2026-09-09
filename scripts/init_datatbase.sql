=======================================================================================================
/*
Create Database and Schemas

Script Purpose:
This script creates a new database named 'DataWarehouse' after checking if it already exists.
If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
within the database: 'bronze', 'silver', and 'gold'.

WARNING:
Running this script will drop the entire 'DataWarehouse' database if it exists.
All data in the database will be permanently deleted. Proceed with caution
and ensure you have proper backups before running this script.
*/
=======================================================================================================
use master  
GO

if exists(  
select 1
from sys.databases
where name = 'DataWarehouse')
begin
	alter database DataWarehouse set single_user with rollback immediate; 
	drop database DataWarehouse
end

GO    --GO; is worng Because GO is not actually a SQL command.

CREATE database DataWarehouse;
GO

use DataWarehouse
GO

create schema bronze;
go   --without GO if we exceute all then it will be error as many CREATE together

create schema silver;
GO --go says 'evevrything above it s spearet batch tahn below  --separator'

create schema gold;
GO
