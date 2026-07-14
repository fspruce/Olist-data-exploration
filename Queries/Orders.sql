SELECT TOP(10)
  O.[OrderID]
  ,O.[CustomerID]
  ,P.[ProductID]
  ,[CategoryName] = P.[CategoryNameEnglish]
  ,[Price(BRL)] = OI.[Price]
  ,O.[Status]
  ,O.[PurchaseTimestamp]
  ,O.[ApprovedAtTimestamp]
  ,[EstimatedDeliveryDate] = CAST(O.[EstimatedDeliveryDate] AS DATE)
  ,O.[DeliveredCarrierDate]
  ,O.[DeliveredCustomerDate]
  ,[DaysToDeliver] = DATEDIFF(DAY, O.[PurchaseTimestamp], O.[DeliveredCustomerDate])
  ,[DaysPastEstimated] = 
      CASE
        WHEN O.[DeliveredCustomerDate] > O.[EstimatedDeliveryDate] THEN DATEDIFF(DAY,O.[EstimatedDeliveryDate], O.[DeliveredCustomerDate])
        ELSE 'NA'
      END
FROM [Olist].[Sales].[Orders] O
LEFT JOIN [Olist].[Sales].[OrderItems] OI
  ON O.[OrderID] = OI.[OrderID]
LEFT JOIN [Olist].[Catalog].[TranslatedProducts] P
  ON OI.[ProductID] = P.[ProductID]
WHERE DATEDIFF(DAY,O.[EstimatedDeliveryDate], O.[DeliveredCustomerDate]) >= 7
  AND O.[DeliveredCustomerDate] > O.[EstimatedDeliveryDate]
ORDER BY OI.[Price] DESC, [DaysToDeliver] DESC, [DaysPastEstimated] DESC, O.[PurchaseTimestamp]