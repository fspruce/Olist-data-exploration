USE Olist;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE NAME = 'Customers')
BEGIN
  EXEC('CREATE SCHEMA Customers');
END
GO

-- CREATE Customers.Customers
CREATE TABLE [Olist].[Customers].[Customers] (
  [CustomerID] VARCHAR(50) PRIMARY KEY
  ,[CustomerUniqueID] VARCHAR(50)
  ,[CustomerZipCodePrefix] VARCHAR(50)
  ,[CustomerCity] VARCHAR(100)
  ,[CustomerState] VARCHAR(50)
);

CREATE TABLE [Olist].[Customers].[Staging_Customers] (
  [customer_id] VARCHAR(50)
  ,[customer_unique_id] VARCHAR(50)
  ,[customer_zip_code_prefix] VARCHAR(50)
  ,[customer_city] VARCHAR(100)
  ,[customer_state] VARCHAR(50)
);

BULK INSERT [Olist].[Customers].[Staging_Customers]
FROM 'C:\Users\Fintan Spruce\Desktop\Coding\SQL\OList\CSVs\olist_customers_dataset.csv'
WITH (
  FORMAT = 'CSV',
  FIRSTROW = 2,
  CODEPAGE = '65001',
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '0x0a'
);

INSERT INTO [Olist].[Customers].[Customers]
(
  [CustomerID]
  ,[CustomerUniqueID]
  ,[CustomerZipCodePrefix]
  ,[CustomerCity]
  ,[CustomerState]
)
SELECT
  [customer_id]
  ,[customer_unique_id]
  ,[customer_zip_code_prefix]
  ,[customer_city]
  ,[customer_state]
FROM [Olist].[Customers].[Staging_Customers];

DROP TABLE [Olist].[Customers].[Staging_Customers];
GO

-- DROP TABLE [Olist].[Customers].[Customers]