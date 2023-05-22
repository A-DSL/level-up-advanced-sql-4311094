SELECT
  [s].[employeeId],
  [e].[firstName],
  [e].[lastName],
  COUNT([salesAmount]) AS [Number of Sales Made]
FROM sales AS s
LEFT JOIN employee AS e on [s].[employeeId] = [e].[employeeId]
GROUP BY [s].[employeeId], [e].[firstName], [e].[lastName]
/*the fact that custom column order refs work in MySQL but not SQLServer is messed up*/
ORDER BY [Number of Sales Made] DESC;

SELECT
  [s].[employeeId],
  [e].[firstName],
  [e].[lastName],
  MAX([salesAmount]) AS [Most Expensive Sale],
  MIN([salesAmount]) AS [Least Expensive Sale]
FROM sales AS s
LEFT JOIN employee AS e on [s].[employeeId] = [e].[employeeId]
/*non-hardcoded date using a date function that tracks your computer's datetime and takes generic arguments.
note that in this case, the engine's 'present year' is preset to 2022.*/
WHERE [s].soldDate >= date('now', 'start of year')
/*WHERE [s].[soldDate] >= '2022-01-01' AND [s].[soldDate] <= '2022-12-31'*/
GROUP BY [s].[employeeId], [e].[firstName], [e].[lastName];

SELECT
  [s].[employeeId],
  [e].[firstName] AS [First Name],
  [e].[lastName] AS [Last Name],
  COUNT([salesAmount]) AS [Number of Sales Made]
FROM sales AS s
LEFT JOIN employee AS e on [s].[employeeId] = [e].[employeeId]
WHERE [s].[soldDate] >= DATE('now', 'start of year') 
GROUP BY [s].[employeeId], [e].[firstName], [e].[lastName]
/*HAVING is a specialized WHERE clause that allows you to filter based on aggregate data.
note that it must be used after GROUP BY.
this saves you the trouble of subquerying, but won't help if you need to ORDER BY the aggregate data.*/
HAVING COUNT([salesAmount]) >= 5