/*

SQL Lab #3

Michael Scott

*/

USE Cape_Codd

-- 1

SELECT DISTINCT * -- selecting all data
FROM INVENTORY -- from Inventory database
WHERE SKU_Description LIKE '%Scuba%' -- pulling all items that are related to "scuba"
ORDER BY SKU_Description, WarehouseID; -- sorted by SKU_Description and warehouse ID for readability

/*
This query is very useful for pulling a list of all items a company sells that are related to each other
*/

-- 2 
SELECT DISTINCT OrderNumber -- returning unique order numbers
					AS 'Order Number', --  adding a space to order number for readability
				SKU -- pulling the SKU
FROM ORDER_ITEM -- from the database with ordered items
WHERE SKU LIKE '10%' -- where the order number starts with "10"
ORDER BY OrderNumber; -- sorting by order number for readability

/*
This query is useful when a company wants to see which SKUs are being ordered and when, using the order number as the timeline ('10%' will be earlier than '20%')
*/

-- 3 
SELECT * -- select all data
FROM WAREHOUSE -- from the Warehouse database
WHERE WarehouseCity LIKE '%[OE]'; -- pulling all Warehouse cities with an O or an E at the end of the name

/*
This query uses brackets and LIKE to find any cities with a specific set of characters in a given position. This can be used to group things, or to analyze patterns 
*/

-- 4 
SELECT SKU_Description AS 'Item' -- Returning SKU Descriptions renamed as Item
FROM CATALOG_SKU_2015 -- From the 2015 catalog
WHERE Department NOT LIKE '%Camping%' -- the items that are not in the camping department
ORDER BY SKU_Description; -- sorted alphabetically for readability

/*
This query is useful to pull a list of items that are not in a certain department. This can help show the balance of products between departments
*/

-- 5
SELECT SKU, -- returning the SKU
	   QuantityOnHand 
			AS 'In Stock', -- returning the Quantity on Hand renamed as In Stock
	   QuantityOnOrder 
			AS 'Forthcoming', -- returning the Quantity on Order renamed as Forthcoming
	   WarehouseID -- returning the warehouse to match the inventory level with the corresponding warehouse
FROM INVENTORY -- from the Inventory database
WHERE SKU LIKE '%12%'; -- where the SKU has a 12 somewhere inside of it

/*
I added the warehouse ID that wasn't asked for, since the query returned the same SKU with different stock and order levels. This data would make no actionable sense without knowing the warehouse that each stock level was kept at

This query is useful to create and report a list of SKU's that have a distinct characteristic. If SKUs have a pattern this query can return all the SKU's in one group based on the SKU number
*/

-- 6 
SELECT SKU_Description -- returning the SKU descriptions
FROM INVENTORY -- from the Inventory database
GROUP BY SKU_Description -- returning each of the SKU Descriptions 
ORDER BY SKU_Description; -- sorted alphabetically for readability

/*
This query is helpful because it will return a list of each group of distinct SKU descriptions
*/

-- 7 
SELECT OrderMonth -- returning the months of each order
			AS 'Month', -- renamed as Month
	   OrderYear -- returning the years of each order
			AS 'Year' -- renamed as Year
FROM RETAIL_ORDER -- from the Retail Order database
GROUP BY OrderMonth, OrderYear; -- returning a list of each unique month and year

/*
This query is helpful to return a table of each month and year your orders come in. This can help find seasonality or order patterns
*/

-- 8 
SELECT Department, -- returning the Department names
	   DateOnWebSite -- returning the date published on the website
			AS 'PubDate' -- renamed to PubDate
FROM CATALOG_SKU_2014 -- from the 2014 catalog
GROUP BY Department, DateOnWebSite; -- grouped by the unique combinations of Department and the date an item in the department was published online

/*
This query can be helpful to find patterns in how often one department is published online versus the other departments. It can also find patterns in when items are publshed online (start of month vs end of month, etc)
*/

-- 9 
SELECT OrderNumber, Quantity, COUNT(SKU) -- Returning the Order number, the quantity, and the counts of individual SKUs
								  AS 'NumberOfSingleItems' -- renaming the SKU column to Number of Single Items
FROM ORDER_ITEM -- from the Order Item database
GROUP BY OrderNumber, Quantity -- grouped by the unique combinations of order number and quantity of each SKU ordered
HAVING COUNT(SKU) > 1; -- with the SKU counts per order being greater than 1

/*
This query is useful in determining how many orders are considered "large" based on either quantity ordered or how many unique SKUs are in the order. This is helpful in determining customer order pattern

However, this query does not fully answer the question because Order #2000 is not included since the two orders have different quantities. Order 2000 does have more than one SKU and should be included as such
*/

-- 10
SELECT OrderNumber, -- returning the Order Numbers
	   SUM(ExtendedPrice) -- returning the sum of the prices
			AS 'TotalCost' -- renaming the sum column to TotalCost
FROM ORDER_ITEM -- from the Order Item database
WHERE Quantity > 1 -- where the order quanity is greater than one
GROUP BY OrderNumber -- grouped by the unique order numbers
HAVING COUNT(SKU) > 1 -- where the orders have more than one SKU in them

/*
This query shows that order 2000 is the only order that has both more than one SKU and quanitites that are higher than 1

This query is helpful in determining the prices for specific orders based on desired characteristics. This can help analyze patterns in cost for the "large" orders 
*/
