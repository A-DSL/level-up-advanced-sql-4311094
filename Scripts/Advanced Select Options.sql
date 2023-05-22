/*CTEs are basically repeatedly usable subqueries.*/
WITH CTE_salesByYear AS (
  SELECT
    [salesAmount],
    /*we could've used YEAR() if we weren't in SQLite, but alas.*/
    STRFTIME('%Y', [soldDate]) AS [soldYear]
  FROM sales
)
SELECT
  /*SQLite's version of printf. for casted floats as the 2nd argument, % is where it goes
  (decimal config can be added after).*/
  FORMAT('$%.2f', SUM([salesAmount])) AS [Total Sales],
  [soldYear]
FROM CTE_salesByYear
GROUP BY [soldYear]

WITH CTE_salesByMonth2021 AS (
  SELECT
    [s].[employeeId] AS [employeeId],
    [e].[firstName] AS [First Name],
    [e].[lastName] AS [Last Name],
    [s].[salesAmount] AS [salesAmount],
    STRFTIME('%m', [soldDate]) AS [soldMonth]
  FROM sales AS s
  LEFT JOIN employee AS e ON [s].[employeeId] = [e].[employeeId]
  WHERE STRFTIME('%Y', [soldDate]) = '2021'
)
SELECT
  [employeeId],
  [First Name],
  [Last Name],
  /*we're lucky we'll always know there's 12 months in a year lol
  (note that you can use CASE instead of FILTER here too)*/
  COUNT(salesAmount) FILTER (WHERE [soldMonth] = '01') AS [JanSales],
  COUNT(salesAmount) FILTER (WHERE [soldMonth] = '02') AS [FebSales],
  COUNT(salesAmount) FILTER (WHERE [soldMonth] = '03') AS [MarSales],
  COUNT(salesAmount) FILTER (WHERE [soldMonth] = '04') AS [AprSales],
  COUNT(salesAmount) FILTER (WHERE [soldMonth] = '05') AS [MaySales],
  COUNT(salesAmount) FILTER (WHERE [soldMonth] = '06') AS [JunSales],
  COUNT(salesAmount) FILTER (WHERE [soldMonth] = '07') AS [JulSales],
  COUNT(salesAmount) FILTER (WHERE [soldMonth] = '08') AS [AugSales],
  COUNT(salesAmount) FILTER (WHERE [soldMonth] = '09') AS [SepSales],
  COUNT(salesAmount) FILTER (WHERE [soldMonth] = '10') AS [OctSales],
  COUNT(salesAmount) FILTER (WHERE [soldMonth] = '11') AS [NovSales],
  COUNT(salesAmount) FILTER (WHERE [soldMonth] = '12') AS [DecSales]
FROM CTE_salesByMonth2021
GROUP BY [employeeId], [First Name], [Last Name]
ORDER BY [soldMonth] ASC;

/*i wouldve just done a double left join for this but subquerying it is*/
SELECT 
  [q1].[salesId],
  [m].[model],
  [q1].[salesAmount],
  [q1].[soldDate]
FROM (
  SELECT
    [s].[salesId] AS [salesId],
    [s].[inventoryId] AS [inventoryId],
    [i].[modelId] AS [modelId],
    [s].[salesAmount] AS [salesAmount],
    [s].[soldDate] AS [soldDate]
  FROM sales AS s
  LEFT JOIN inventory AS i ON [s].[inventoryId] = [i].[inventoryId]
) AS q1
LEFT JOIN model AS m ON [q1].[modelId] = [m].[modelId]
WHERE [m].[EngineType] = 'Electric';

/*instructor solution; apparently WHERE can literally search an entire column from a subqueried table?
you don't get the model name this way but it's 4 lines shorter*/
SELECT
  [s].[salesId] AS [salesId],
  [s].[inventoryId] AS [inventoryId],
  [i].[modelId] AS [modelId],
  [s].[salesAmount] AS [salesAmount],
  [s].[soldDate] AS [soldDate]
FROM sales AS s
LEFT JOIN inventory AS i ON [s].[inventoryId] = [i].[inventoryId]
WHERE [i].[modelId] IN (
  SELECT
    [modelId]
  FROM model WHERE [EngineType] = 'Electric'
)