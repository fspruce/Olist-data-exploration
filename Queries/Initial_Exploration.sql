-- Status Count
SELECT
    O.[Status]
    ,[No. Entries] = COUNT(O.[Status])
FROM [Olist].[Sales].[Orders] O
GROUP BY O.[Status]