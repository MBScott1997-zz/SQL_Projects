/*

SQL Lab #6

Michael Scott

*/

USE Cape_Codd; 

-- 1

SELECT * -- selecting all data
FROM INVENTORY, ORDER_ITEM -- from these 2 databases
WHERE ORDER_ITEM.SKU=INVENTORY.SKU; -- connecting them through their joined SKU columns

/*
When data about products are split into two databases this query allows you to see all the data in one place
This can be helpful for connecting different departments, like marketing and sales
*/

-- 2

SELECT StoreNumber, SUM(Quantity) AS 'Store Quantity' -- returning the store number and order quantities
FROM ORDER_ITEM, RETAIL_ORDER -- from the two needed databases
WHERE ORDER_ITEM.OrderNumber=RETAIL_ORDER.OrderNumber -- connected by the OrderNumber column
GROUP BY StoreNumber; -- grouped by the store number

/*
This query allows us to answer questions about store performance or actions relative to other stores
*/

-- 3 

SELECT ORDER_ITEM.SKU, -- returning SKUs from Order Item database
	WarehouseID AS 'Warehouse', -- returning warehouses
	QuantityOnOrder AS 'Quantity', -- returning quantity on ordered
	Price, -- returning price
	(QuantityOnOrder * Price) AS 'Total Cost' -- returning total cost
FROM INVENTORY -- from inventory database
	JOIN ORDER_ITEM -- also selecting order_item database
		ON INVENTORY.SKU = ORDER_ITEM.SKU -- joined on the SKU columns
GROUP BY ORDER_ITEM.SKU, WarehouseID, QuantityOnOrder, Price -- grouped by the non-functions
ORDER BY WarehouseID; -- sorted by the warehouse

/*
This is useful when inventory purchasing or developing a new stocking strategy for a warehousing or distribution business
*/

-- 4 

SELECT * -- returning all data
FROM INVENTORY -- from inventory
	JOIN ORDER_ITEM -- and order item
		ON INVENTORY.SKU = ORDER_ITEM.SKU; -- combining the two on the SKU column

/*
This query returned the same table as #1, but used the explicit join, not implicit.
This explicit join is more useful when wanting to perform a partial join, such as an outer left join
*/

-- 5 

SELECT WAREHOUSE.WarehouseID, -- returning warehouse ID
	WarehouseCity AS 'City', -- and the city
	SKU_Description AS 'Items' -- and the sku descriptions
FROM WAREHOUSE -- from the warehouse database
	LEFT OUTER JOIN INVENTORY -- using the warehouse database but pulling in just the sku descriptions from inventory
	ON WAREHOUSE.WarehouseID = INVENTORY.WarehouseID -- using warehouse ID as the common factor
GROUP BY WAREHOUSE.WarehouseID, WarehouseCity, SKU_Description; -- grouped by the non-functions

/*
This query returns a NULL for San Fran, since it returns SKU descriptions per warehouse and the SF warehouse has no current inventory, therefore no sku descriptions
*/