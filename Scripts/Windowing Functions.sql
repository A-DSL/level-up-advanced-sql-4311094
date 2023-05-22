SELECT
  [employeeId],
  [firstName],
  [lastName],
  [model],
  RANK() OVER (
    PARTITION BY [employeeId]
    ORDER BY COUNT([salesAmount]) DESC
  ) AS [Rank],
  COUNT([salesAmount]) AS [Number Sold]
FROM (
  SELECT
    [s].[employeeId],
    [e].[firstName],
    [e].[lastName],
    CASE
      WHEN [m].[model] IS NULL THEN 'Unspecified/Independent'
      ELSE [m].[model]
    END AS [model],
    [s].[salesAmount]
  FROM sales AS s
  LEFT JOIN employee AS e ON [s].[employeeId] = [e].[employeeId]
  LEFT JOIN inventory AS i ON [s].[inventoryId] = [i].[inventoryId]
  LEFT JOIN model AS m ON [i].[modelId] = [m].[modelId]
) AS q1
GROUP BY [employeeId], [firstName], [lastName], [model]

WITH CTE_sales AS ( 
  SELECT
    [salesAmount],
    STRFTIME('%m', [soldDate]) AS [Month],
    STRFTIME('%Y', [soldDate]) AS [Year]
  FROM sales
)
SELECT
  [Month],
  [Year],
  SUM(salesAmount) AS [Total Sales],
  SUM(SUM(salesAmount)) OVER (
    PARTITION BY [Year]
    ORDER BY [Year] ASC, [Month] ASC
  ) AS [Intra-Year Running Total],
  SUM(SUM(salesAmount)) OVER (
    ORDER BY [Year] ASC
  ) AS [Annual Running Total]
FROM CTE_sales
GROUP BY [Year], [Month]
ORDER BY [Year] ASC, [Month] ASC

/*a world where there's actually up-to-date sales data for the last exercise and I can put this
in the CTE instead*/
SELECT
  [salesAmount],
  STRFTIME('%Y%m', [soldDate]) AS [YearMonth]
FROM sales
WHERE 
  STRFTIME('%Y%m', [soldDate]) = STRFTIME('%Y%m', DATE('now')) 
  OR STRFTIME('%Y%m', [soldDate]) = STRFTIME('%Y%m', DATE('now', '-1 month'))
/*world where i use two random months as a sample instead*/
WITH CTE_currentSalesMonths AS ( 
  SELECT
    [salesAmount],
    STRFTIME('%Y-%m', [soldDate]) AS [YearMonth]
  FROM sales
  WHERE STRFTIME('%Y-%m', [soldDate]) = '2022-09' OR STRFTIME('%Y-%m', [soldDate]) = '2022-08'
)
SELECT
  [YearMonth],
  COUNT([salesAmount]) AS [Sales Count]
FROM CTE_currentSalesMonths
GROUP BY [YearMonth]

/*ACTUAL final exercise (it was to show another column with each sales month's PM counterpart)*/
SELECT
  STRFTIME('%Y-%m', [soldDate]) AS [Sales Month],
  COUNT([salesAmount]) AS [Sales Count],
  LAG (COUNT([salesAmount]), 1, 0) OVER (
    ORDER BY STRFTIME('%Y-%m', [soldDate])
  ) AS [Sales Count PM]
  FROM sales
GROUP BY STRFTIME('%Y-%m', [soldDate])