USE Olist;
GO

CREATE VIEW [Catalog].[TranslatedProducts] AS
  SELECT
      P.[ProductID],
      P.[ProductCategoryName] AS CategoryNamePortuguese,
      T.[ProductCategoryNameEnglish] AS CategoryNameEnglish,
      P.[ProductNameLength],
      P.[ProductDescriptionLength],
      P.[ProductPhotosQty],
      P.[ProductWeightG],
      P.[ProductLengthCm],
      P.[ProductHeightCm],
      P.[ProductWidthCm]
  FROM [Catalog].[Products] P
  LEFT JOIN [Catalog].[Translations] T
      ON P.[ProductCategoryName] = T.[ProductCategoryName];
GO

-- DROP VIEW [Catalog].[TranslatedProducts]