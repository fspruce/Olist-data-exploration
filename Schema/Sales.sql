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

-- CREATE Sales.OrderItems
CREATE TABLE [Olist].[Sales].[OrderItems] (
  [OrderID] VARCHAR(50)
  ,[OrderItemID] INT
  ,[ProductID] VARCHAR(50)
  ,[SellerID] VARCHAR(50)
  ,[ShippingLimitDate] DATETIME
  ,[Price] DECIMAL(10,2)
  ,[FreightValue] DECIMAL(10,2)
);

CREATE TABLE [Olist].[Sales].[Staging_OrderItems] (
  [order_id] VARCHAR(50)
  ,[order_item_id] VARCHAR(50)
  ,[product_id] VARCHAR(50)
  ,[seller_id] VARCHAR(50)
  ,[shipping_limit_date] VARCHAR(50)
  ,[price] VARCHAR(50)
  ,[freight_value] VARCHAR(50)
);

BULK INSERT [Olist].[Sales].[Staging_OrderItems]
FROM 'C:\Users\Fintan Spruce\Desktop\Coding\SQL\OList\CSVs\olist_order_items_dataset.csv'
WITH (
  FORMAT = 'CSV',
  FIRSTROW = 2,
  CODEPAGE = '65001',
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '0x0a'
);

INSERT INTO [Olist].[Sales].[OrderItems]
(
  [OrderID]
  ,[OrderItemID]
  ,[ProductID]
  ,[SellerID]
  ,[ShippingLimitDate]
  ,[Price]
  ,[FreightValue]
)
SELECT
  [order_id]
  ,TRY_CONVERT(INT, NULLIF([order_item_id], ''))
  ,[product_id]
  ,[seller_id]
  ,TRY_CONVERT(DATETIME, NULLIF([shipping_limit_date], ''), 120)
  ,TRY_CONVERT(DECIMAL(10,2), NULLIF([price], ''))
  ,TRY_CONVERT(DECIMAL(10,2), NULLIF([freight_value], ''))
FROM [Olist].[Sales].[Staging_OrderItems];

DROP TABLE [Olist].[Sales].[Staging_OrderItems];
GO

-- DROP TABLE [Olist].[Sales].[OrderItems]

-- CREATE Sales.OrderPayments
CREATE TABLE [Olist].[Sales].[OrderPayments] (
  [OrderID] VARCHAR(50)
  ,[PaymentSequential] INT
  ,[PaymentType] VARCHAR(50)
  ,[PaymentInstallments] INT
  ,[PaymentValue] DECIMAL(10,2)
);

CREATE TABLE [Olist].[Sales].[Staging_OrderPayments] (
  [order_id] VARCHAR(50)
  ,[payment_sequential] VARCHAR(50)
  ,[payment_type] VARCHAR(50)
  ,[payment_installments] VARCHAR(50)
  ,[payment_value] VARCHAR(50)
);

BULK INSERT [Olist].[Sales].[Staging_OrderPayments]
FROM 'C:\Users\Fintan Spruce\Desktop\Coding\SQL\OList\CSVs\olist_order_payments_dataset.csv'
WITH (
  FORMAT = 'CSV',
  FIRSTROW = 2,
  CODEPAGE = '65001',
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '0x0a'
);

INSERT INTO [Olist].[Sales].[OrderPayments]
(
  [OrderID]
  ,[PaymentSequential]
  ,[PaymentType]
  ,[PaymentInstallments]
  ,[PaymentValue]
)
SELECT
  [order_id]
  ,TRY_CONVERT(INT, NULLIF([payment_sequential], ''))
  ,[payment_type]
  ,TRY_CONVERT(INT, NULLIF([payment_installments], ''))
  ,TRY_CONVERT(DECIMAL(10,2), NULLIF([payment_value], ''))
FROM [Olist].[Sales].[Staging_OrderPayments];

DROP TABLE [Olist].[Sales].[Staging_OrderPayments];
GO

-- DROP TABLE [Olist].[Sales].[OrderPayments]

-- CREATE Sales.OrderReviews
CREATE TABLE [Olist].[Sales].[OrderReviews] (
  [ReviewID] VARCHAR(50)
  ,[OrderID] VARCHAR(50)
  ,[ReviewScore] INT
  ,[ReviewCommentTitle] VARCHAR(100)
  ,[ReviewCommentMessage] VARCHAR(1000)
  ,[ReviewCreationDate] DATETIME
  ,[ReviewAnswerTimestamp] DATETIME
);

CREATE TABLE [Olist].[Sales].[Staging_OrderReviews] (
  [review_id] VARCHAR(50)
  ,[order_id] VARCHAR(50)
  ,[review_score] VARCHAR(50)
  ,[review_comment_title] VARCHAR(100)
  ,[review_comment_message] VARCHAR(1000)
  ,[review_creation_date] VARCHAR(50)
  ,[review_answer_timestamp] VARCHAR(50)
);

BULK INSERT [Olist].[Sales].[Staging_OrderReviews]
FROM 'C:\Users\Fintan Spruce\Desktop\Coding\SQL\OList\CSVs\olist_order_reviews_dataset.csv'
WITH (
  FORMAT = 'CSV',
  FIRSTROW = 2,
  CODEPAGE = '65001',
  FIELDTERMINATOR = ',',
  FIELDQUOTE = '"',
  ROWTERMINATOR = '0x0d0a'
);

INSERT INTO [Olist].[Sales].[OrderReviews]
(
  [ReviewID]
  ,[OrderID]
  ,[ReviewScore]
  ,[ReviewCommentTitle]
  ,[ReviewCommentMessage]
  ,[ReviewCreationDate]
  ,[ReviewAnswerTimestamp]
)
SELECT
  [review_id]
  ,[order_id]
  ,TRY_CONVERT(INT, NULLIF([review_score], ''))
  ,[review_comment_title]
  ,[review_comment_message]
  ,TRY_CONVERT(DATETIME, NULLIF([review_creation_date], ''), 120)
  ,TRY_CONVERT(DATETIME, NULLIF([review_answer_timestamp], ''), 120)
FROM [Olist].[Sales].[Staging_OrderReviews];

DROP TABLE [Olist].[Sales].[Staging_OrderReviews];
GO

-- DROP TABLE [Olist].[Sales].[OrderReviews]


