/* 

SQL Lab 4

Michael Scott

*/ 

USE Cape_Codd; 

-- 1

SELECT LEFT (OrderMonth, 3) AS 'Order Month' -- Selecting the first three letters of the order month
FROM RETAIL_ORDER; -- from the Retail Order database

/* 
This query is great for formatting a table in a specfic way. 
Many company's databases rely on specific formatting and this will output a table with the order months in a specific way
*/

-- 2

SELECT UPPER(WarehouseCity) AS 'CapitalCity' -- Selecting the cities (in upper case) 
FROM WAREHOUSE -- from the warehouse database
WHERE SquareFeet > 130000; -- where the sqft are over 130,000

/*
Again, this query is great for formatting answers
Managers often have specific formatting guidelines for their projects, and this query allows for a specific formatting option
*/

-- 3 

SELECT COUNT(CatalogPage) AS 'NumOfPages' -- counting the rows where CatalogPage is not NULL and renaming to NumOfPages
FROM CATALOG_SKU_2013; -- from the 2013 catalog

/*
This query is helpful for counting the number of occurences with values. 
This can be used for sales that have actually gone through, etc
*/

-- 4 

SELECT SUM(ExtendedPrice) AS 'Total_EP' -- Summing the Exended Prices in the table
FROM ORDER_ITEM; -- from the orders database


/*
This query is helpful so companies can find the total number of occurences or values
This can help find total sales, total customers, etc
*/

-- 5 

SELECT AVG(ExtendedPrice) AS 'Average_Price' -- returning the average of extended prices
FROM ORDER_ITEM -- from the orders database
WHERE Price > 100; -- when price is over 100

/*
This is helpful since companies often only want to average certain instances with specific criteria
This can take out outliers, take out certain cities of sales, etc. to help narrow the focus for analysis
*/

-- 6 

SELECT
	MAX(Price) -- returning the max price
		AS 'MaxPrice', 
	MIN(Price) -- returning the min price
		AS 'MinPrice'
FROM ORDER_ITEM; -- from the orders database

/*
Knowing your maximum and minimums of certain variables is always helpful to a company to establish ranges and options 
This can give you the range of any numeric variable e.g. salaries, sales, prices, etc.
*/

-- 7 

SELECT WarehouseID, -- returning the warehouse ID
	   CONCAT(TRIM(WarehouseCity), ', ', WarehouseState) AS Location -- returning the City, State in the proper formatting
FROM WAREHOUSE -- from the warehouse database
ORDER BY WarehouseID; -- sorted by the warehouse ID

/*
When reporting queries to management formatting is crucial.
This query helps to format the returned table so the results are more easily read 
*/

-- 8 

SELECT CONCAT('We have ', QuantityOnHand, ' of the ', TRIM(SKU_Description), ' in inventory ') AS 'Quantity On Hand' -- returning the sentence using values from QuantityOnHand and the trimmed SKU description
FROM INVENTORY; -- from the inventory database

/*
This table is easily given to any member of the staff, even with no SQL training, and is able to be read. 
This query is great for formatting and reporting analysis
*/

-- 9 

SELECT DatePart(year, GETDATE()) AS 'Current Year' -- returning the current year

/*
When combined with other queries this simple return of the current date can help put the other queries into perspective
*/

-- 10 

SELECT DATEADD(month, 1, GETDATE()) AS 'One Month from Now'; -- returning the date plus one month

/*
This query, like the previous query, can help put other analysis into perspective when it comes to sales dates or other variables
An example would be a forecast, and this query would be used to show the future date being predicted
*/