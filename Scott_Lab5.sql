/*

SQL Lab #5

Michael Scott

*/

USE Cape_Codd;

-- 1

SELECT SUM(Quantity) AS 'AmtItems' -- Summing the order quantities and renaming it to 'AmtItems'
FROM ORDER_ITEM -- getting the order quantity from the Order Item database
WHERE SKU IN -- summing only the SKUs that...
	(SELECT SKU -- finding the SKU #s
	 FROM INVENTORY -- from the Inventory Database
	 WHERE SKU_Description = 'Dive Mask, Small Clear'); -- that correspond to small clear dive masks

/*
This dual query allows us to utilize the foreign key to find information stored on other tables. 

This is useful in finding sales in specific dates stored on another table, etc.
*/

-- 2 

SELECT DISTINCT WarehouseID AS 'MidBookWarehouseIDs' -- returning the unique warehouse IDs renamed to 'MidBookWarehouseIDs'
FROM INVENTORY -- getting the warehouse IDs from inventory database
WHERE SKU IN -- using SKU's that...
	(SELECT SKU -- returning the SKU #s
	 FROM CATALOG_SKU_2014 -- from the 2014 catalog database
	 WHERE CatalogPage BETWEEN 24 AND 70); -- returning the SKUS in between pages 24 and 70 in the catalog

/*
This query is great for combining Operations and Marketing/Sales. 
This is important so that management knows the location and stock of inventory that the company is pushing in advertisements.
*/

-- 3 

SELECT Manager, -- Returning the Manager name
	   WarehouseCity AS 'Warehouse City', -- and the Warehouse City
	   WarehouseState AS 'Warehouse State' -- and the Warehouse State
FROM WAREHOUSE -- from the Warehouse Database
WHERE WarehouseID IN -- returning the warehouse ID where...
	(SELECT WarehouseID -- returning the warehouse ID
	 FROM INVENTORY -- from the Inventory Database
	 WHERE SKU IN -- returning the SKUs that...
		(SELECT SKU -- returning the SKU #s
		FROM SKU_DATA -- from SKU Data database
		WHERE Department = 'Camping')); -- returning SKUs in the Camping department

/*
This query utilizes a third table to connect the Warehouse ID to the SKU-Data, since there are no foreign keys connecting the two
This technique allows us to connect any tables and find any data across the data base, as long as there is a chain of foreign keys in which to travel through
*/

-- 4 

SELECT BUYER AS 'Buyer', -- Returning the Buyer names
	(SELECT SUM(QuantityOnOrder) -- also returning the sum of total quantity on orders
	 FROM INVENTORY -- from the inventory database
	 WHERE INVENTORY.SKU = SKU_DATA.SKU) AS 'Total Order Quantity' -- connecting the SKU columns in SKU Data and Inventory 
FROM SKU_DATA -- returning the buyer names from SKU Data
ORDER BY Buyer; -- ordered by the buyer names

/*
This query returns the total orders per each SKU, and not the total ordered combined into one row
However, this query is useful to find any variable per buyer or department.
This is important so businesses know where time and resources are devoted to
*/

