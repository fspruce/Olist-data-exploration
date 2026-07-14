USE Olist;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE NAME = 'Geography')
BEGIN
  EXEC('CREATE SCHEMA Geography');
END
GO

-- CREATE Geography.Geolocation
CREATE TABLE [Olist].[Geography].[Geolocation] (
  [GeolocationZipCodePrefix] VARCHAR(50)
  ,[GeolocationLat] DECIMAL(18,15)
  ,[GeolocationLng] DECIMAL(18,15)
  ,[GeolocationCity] VARCHAR(100)
  ,[GeolocationState] VARCHAR(50)
);

CREATE TABLE [Olist].[Geography].[Staging_Geolocation] (
  [geolocation_zip_code_prefix] VARCHAR(50)
  ,[geolocation_lat] VARCHAR(50)
  ,[geolocation_lng] VARCHAR(50)
  ,[geolocation_city] VARCHAR(100)
  ,[geolocation_state] VARCHAR(50)
);

BULK INSERT [Olist].[Geography].[Staging_Geolocation]
FROM 'C:\Users\Fintan Spruce\Desktop\Coding\SQL\OList\CSVs\olist_geolocation_dataset.csv'
WITH (
  FORMAT = 'CSV',
  FIRSTROW = 2,
  CODEPAGE = '65001',
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '0x0a'
);

INSERT INTO [Olist].[Geography].[Geolocation]
(
  [GeolocationZipCodePrefix]
  ,[GeolocationLat]
  ,[GeolocationLng]
  ,[GeolocationCity]
  ,[GeolocationState]
)
SELECT
  [geolocation_zip_code_prefix]
  ,TRY_CONVERT(DECIMAL(18,15), NULLIF([geolocation_lat], ''))
  ,TRY_CONVERT(DECIMAL(18,15), NULLIF([geolocation_lng], ''))
  ,[geolocation_city]
  ,[geolocation_state]
FROM [Olist].[Geography].[Staging_Geolocation];

DROP TABLE [Olist].[Geography].[Staging_Geolocation];
GO

-- DROP TABLE [Olist].[Geography].[Geolocation]