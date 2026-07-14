USE Olist;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE NAME = 'Sellers')
BEGIN
  EXEC('CREATE SCHEMA Sellers');
END
GO

-- CREATE Sellers.Sellers
CREATE TABLE [Olist].[Sellers].[Sellers] (
  [SellerID] VARCHAR(50) PRIMARY KEY
  ,[SellerZipCodePrefix] VARCHAR(50)
  ,[SellerCity] VARCHAR(100)
  ,[SellerState] VARCHAR(50)
);

CREATE TABLE [Olist].[Sellers].[Staging_Sellers] (
  [seller_id] VARCHAR(50)
  ,[seller_zip_code_prefix] VARCHAR(50)
  ,[seller_city] VARCHAR(100)
  ,[seller_state] VARCHAR(50)
);

BULK INSERT [Olist].[Sellers].[Staging_Sellers]
FROM 'C:\Users\Fintan Spruce\Desktop\Coding\SQL\OList\CSVs\olist_sellers_dataset.csv'
WITH (
  FORMAT = 'CSV',
  FIRSTROW = 2,
  CODEPAGE = '65001',
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '0x0a'
);

INSERT INTO [Olist].[Sellers].[Sellers]
(
  [SellerID]
  ,[SellerZipCodePrefix]
  ,[SellerCity]
  ,[SellerState]
)
SELECT
  [seller_id]
  ,[seller_zip_code_prefix]
  ,[seller_city]
  ,[seller_state]
FROM [Olist].[Sellers].[Staging_Sellers];

DROP TABLE [Olist].[Sellers].[Staging_Sellers];
GO

-- DROP TABLE [Olist].[Sellers].[Sellers]