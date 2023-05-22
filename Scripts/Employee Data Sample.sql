SELECT *
FROM sales;
SELECT *
FROM inventory;
SELECT *
FROM model;
SELECT *
FROM employee;
SELECT *
FROM customer;

SELECT sql
FROM sqlite_schema
WHERE name = 'employee';
SELECT sql
FROM sqlite_schema
WHERE name = 'model';