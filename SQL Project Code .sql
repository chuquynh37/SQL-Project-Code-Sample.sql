-- Show sale data table & order by date

SELECT * FROM sales_2016
ORDER BY 1,2;

-- Union with sales_2017

SELECT * FROM sales_2016
UNION
SELECT * FROM sales_2017
ORDER BY 1 DESC;

-- Looking at number of order by productkey

SELECT sales.ProductKey, sales.TerritoryKey, SUM(sales.OrderQuantity) as order_number
FROM (SELECT * FROM sales_2016
UNION
SELECT * FROM sales_2017) as sales
GROUP BY sales.ProductKey, sales.TerritoryKey
ORDER BY 1,2;

-- Join return_table

SELECT sa.ProductKey, sa.OrderDate, sa.StockDate,sa.OrderQuantity, sa.Territorykey,
re.ReturnDate, re.ReturnQuantity
FROM sales_2016 sa
JOIN return_table re USING(ProductKey);


-- Calculate return rate by productkey


DROP TABLE IF EXISTS order_return ;
CREATE TABLE order_return AS 

SELECT oder_groupby.ProductKey,oder_groupby.TerritoryKey,oder_groupby.order_quant ,
CASE WHEN return_groupby.return_number > 0 THEN return_groupby.return_number
     ELSE 0 
     END AS return_quant
FROM (
SELECT ProductKey, TerritoryKey, SUM(OrderQuantity) as order_quant 
FROM (SELECT * FROM sales_2016 
UNION
SELECT * FROM sales_2017) AS sales
GROUP BY ProductKey, TerritoryKey) AS oder_groupby 

LEFT JOIN (
SELECT ProductKey, TerritoryKey, SUM(ReturnQuantity) as return_number FROM return_table
GROUP BY ProductKey, TerritoryKey) AS return_groupby
ON return_groupby.ProductKey = oder_groupby.ProductKey
   AND return_groupby.TerritoryKey= oder_groupby.TerritoryKey;
   
-- After create table return_order:
   
SELECT ProductKey, TerritoryKey,(return_quant/order_quant)*100 AS return_rate
FROM order_return
ORDER BY 3 DESC;

-- CREATE VIEWS
CREATE VIEW orer_return AS
SELECT oder_groupby.ProductKey,oder_groupby.TerritoryKey,oder_groupby.order_quant ,
CASE WHEN return_groupby.return_number > 0 THEN return_groupby.return_number
     ELSE 0 
     END AS return_quant
FROM (
SELECT ProductKey, TerritoryKey, SUM(OrderQuantity) as order_quant 
FROM (SELECT * FROM sales_2016 
UNION
SELECT * FROM sales_2017) AS sales
GROUP BY ProductKey, TerritoryKey) AS oder_groupby 

LEFT JOIN (
SELECT ProductKey, TerritoryKey, SUM(ReturnQuantity) as return_number FROM return_table
GROUP BY ProductKey, TerritoryKey) AS return_groupby
ON return_groupby.ProductKey = oder_groupby.ProductKey
   AND return_groupby.TerritoryKey= oder_groupby.TerritoryKey;




























