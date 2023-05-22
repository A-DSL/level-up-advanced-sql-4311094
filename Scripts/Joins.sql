SELECT
  [e1].[firstName] AS [First Name],
  [e1].[lastName] AS [Last Name],
  [e2].[firstName] AS [Manager First Name],
  [e2].[lastName] AS [Manager Last Name] 
FROM employee AS e1
LEFT JOIN employee AS e2 ON [e1].[managerId] = [e2].[employeeId];

SELECT [employeeId],
  [firstName],
  [lastName],
  CASE 
    WHEN [Total Sales] IS NULL THEN 0
    ELSE [Total Sales]
  END AS [Total Sales]
FROM (
  SELECT
    [e].[employeeId],
    [e].[firstName],
    [e].[lastName],
    SUM(salesAmount) AS [Total Sales]
  FROM employee AS e
  LEFT JOIN sales AS s ON [e].[employeeId] = [s].[employeeId]
  GROUP BY [e].[employeeId], [e].[firstName], [e].[lastName]
) AS q1
WHERE [Total Sales] IS NULL;

SELECT
  [c].[customerId],
  [c].[firstName],
  [c].[lastName],
  [c].[email],
  [s].[salesId],
  [s].[inventoryId],
  [s].[salesAmount],
  [s].[soldDate]
FROM sales AS s
FULL JOIN customer AS c ON [s].[customerId] = [c].[customerId];