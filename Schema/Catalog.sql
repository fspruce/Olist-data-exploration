USE Olist;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE NAME = 'Catalog')
BEGIN
  EXEC('CREATE SCHEMA Catalog');
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE NAME = 'Translation')
BEGIN
  EXEC('CREATE SCHEMA Translation');
END
GO

-- CREATE Catalog.Products
CREATE TABLE [Olist].[Catalog].[Products] (
  [ProductID] VARCHAR(50) PRIMARY KEY
  ,[ProductCategoryName] VARCHAR(100)
  ,[ProductNameLength] INT
  ,[ProductDescriptionLength] INT
  ,[ProductPhotosQty] INT
  ,[ProductWeightG] INT
  ,[ProductLengthCm] INT
  ,[ProductHeightCm] INT
  ,[ProductWidthCm] INT
);

CREATE TABLE [Olist].[Catalog].[Staging_Products] (
  [product_id] VARCHAR(50)
  ,[product_category_name] VARCHAR(100)
  ,[product_name_lenght] VARCHAR(50)
  ,[product_description_lenght] VARCHAR(50)
  ,[product_photos_qty] VARCHAR(50)
  ,[product_weight_g] VARCHAR(50)
  ,[product_length_cm] VARCHAR(50)
  ,[product_height_cm] VARCHAR(50)
  ,[product_width_cm] VARCHAR(50)
);

BULK INSERT [Olist].[Catalog].[Staging_Products]
FROM 'C:\Users\Fintan Spruce\Desktop\Coding\SQL\OList\CSVs\olist_products_dataset.csv'
WITH (
  FORMAT = 'CSV',
  FIRSTROW = 2,
  CODEPAGE = '65001',
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '0x0a'
);

INSERT INTO [Olist].[Catalog].[Products]
(
  [ProductID]
  ,[ProductCategoryName]
  ,[ProductNameLength]
  ,[ProductDescriptionLength]
  ,[ProductPhotosQty]
  ,[ProductWeightG]
  ,[ProductLengthCm]
  ,[ProductHeightCm]
  ,[ProductWidthCm]
)
SELECT
  [product_id]
  ,[product_category_name]
  ,TRY_CONVERT(INT, NULLIF([product_name_lenght], ''))
  ,TRY_CONVERT(INT, NULLIF([product_description_lenght], ''))
  ,TRY_CONVERT(INT, NULLIF([product_photos_qty], ''))
  ,TRY_CONVERT(INT, NULLIF([product_weight_g], ''))
  ,TRY_CONVERT(INT, NULLIF([product_length_cm], ''))
  ,TRY_CONVERT(INT, NULLIF([product_height_cm], ''))
  ,TRY_CONVERT(INT, NULLIF([product_width_cm], ''))
FROM [Olist].[Catalog].[Staging_Products];

DROP TABLE [Olist].[Catalog].[Staging_Products];
GO

-- DROP TABLE [Olist].[Catalog].[Products]

-- CREATE Translation.ProductCategoryNameTranslations
CREATE TABLE [Olist].[Catalog].[Translations] (
  [ProductCategoryName] VARCHAR(100) PRIMARY KEY
  ,[ProductCategoryNameEnglish] VARCHAR(100)
);

CREATE TABLE [Olist].[Catalog].[Staging_Translations] (
  [product_category_name] VARCHAR(100)
  ,[product_category_name_english] VARCHAR(100)
);

BULK INSERT [Olist].[Catalog].[Staging_Translations]
FROM 'C:\Users\Fintan Spruce\Desktop\Coding\SQL\OList\CSVs\product_category_name_translation.csv'
WITH (
  FORMAT = 'CSV',
  FIRSTROW = 2,
  CODEPAGE = '65001',
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '0x0a'
);

INSERT INTO [Olist].[Catalog].[Translations]
(
  [ProductCategoryName]
  ,[ProductCategoryNameEnglish]
)
SELECT
  [product_category_name]
  ,[product_category_name_english]
FROM [Olist].[Catalog].[Staging_Translations];

DROP TABLE [Olist].[Catalog].[Staging_Translations];
GO

UPDATE [Olist].[Catalog].[Translations]
SET [ProductCategoryNameEnglish]= REPLACE(REPLACE([ProductCategoryNameEnglish], CHAR(13), ''), CHAR(10), '');
GO

-- DROP TABLE [Olist].[Catalog].[Translations]