USE Olist;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE NAME = 'Sales')
BEGIN
  EXEC('CREATE SCHEMA Sales');
END
GO

-- CREATE Sales.Orders
CREATE TABLE [Olist].[Sales].[Orders] (
  [OrderID] VARCHAR(50) PRIMARY KEY
  ,[CustomerID] VARCHAR(50)
  ,[Status] VARCHAR(50)
  ,[PurchaseTimestamp] DATETIME
  ,[ApprovedAtTimestamp] DATETIME
  ,[DeliveredCarrierDate] DATETIME
  ,[DeliveredCustomerDate] DATETIME
  ,[EstimatedDeliveryDate] DATETIME
);

CREATE TABLE [Olist].[Sales].[Staging_Orders] (
  [order_id] VARCHAR(50)
  ,[customer_id] VARCHAR(50)
  ,[order_status] VARCHAR(50)
  ,[order_purchase_timestamp] VARCHAR(50)
  ,[order_approved_at] VARCHAR(50)
  ,[order_delivered_carrier_date] VARCHAR(50)
  ,[order_delivered_customer_date] VARCHAR(50)
  ,[order_estimated_delivery_date] VARCHAR(50)
);

BULK INSERT [Olist].[Sales].[Staging_Orders]
FROM 'C:\Users\Fintan Spruce\Desktop\Coding\SQL\OList\CSVs\olist_orders_dataset.csv'
WITH (
  FORMAT = 'CSV',
  FIRSTROW = 2,
  CODEPAGE = '65001',
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '0x0a'
);

INSERT INTO [Olist].[Sales].[Orders]
(
  [OrderID]
  ,[CustomerID]
  ,[Status]
  ,[PurchaseTimestamp]
  ,[ApprovedAtTimestamp]
  ,[DeliveredCarrierDate]
  ,[DeliveredCustomerDate]
  ,[EstimatedDeliveryDate]
)
SELECT
  [order_id]
  ,[customer_id]
  ,[order_status]
  ,TRY_CONVERT(DATETIME, NULLIF([order_purchase_timestamp], ''), 120)
  ,TRY_CONVERT(DATETIME, NULLIF([order_approved_at], ''), 120)
  ,TRY_CONVERT(DATETIME, NULLIF([order_delivered_carrier_date], ''), 120)
  ,TRY_CONVERT(DATETIME, NULLIF([order_delivered_customer_date], ''), 120)
  ,TRY_CONVERT(DATETIME, NULLIF([order_estimated_delivery_date], ''), 120)
FROM [Olist].[Sales].[Staging_Orders];

DROP TABLE [Olist].[Sales].[Staging_Orders];
GO

-- DROP TABLE [Olist].[Sales].[Orders]