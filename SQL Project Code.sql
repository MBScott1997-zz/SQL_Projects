/*

Project 1: Excelsior Mobile Report

Michael Scott

*/

USE Excelsior_Mobile;

CREATE TABLE Device (
	IMEI bigint NOT NULL PRIMARY KEY,
	Device varchar(50) NOT NULL,
	Type varchar(7) NOT NULL,
	YearReleased int,
);

CREATE TABLE MPlan (
	PlanName varchar(10) NOT NULL PRIMARY KEY,
	Minutes varchar(50) NOT NULL,
	Data varchar(10) NOT NULL,
	Throttle int,
	Cost money NOT NULL
);

CREATE TABLE DirNums (
	MDN varchar(12) PRIMARY KEY,
	City varchar(50) NOT NULL,
	State char(2) NOT NULL,
	IMEI bigint FOREIGN KEY REFERENCES Device(IMEI)
);

CREATE TABLE Subscriber (
	MIN bigint NOT NULL PRIMARY KEY,
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	StreetAddress varchar(50),
	City varchar(50) NOT NULL,
	State char(2) NOT NULL,
	ZipCode int NOT NULL,
	MDN varchar(12) FOREIGN KEY REFERENCES DirNums(MDN),
	PlanName varchar(10) FOREIGN KEY REFERENCES MPlan(PlanName)
);

CREATE TABLE Bill (
	MIN bigint NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Subscriber(MIN),
	Base money NOT NULL,
	Tax money NOT NULL,
	EquipFee money NOT NULL,
	Insurance money NOT NULL,
	Total money NOT NULL,
);

CREATE TABLE LastMonthUsage (
	MIN bigint NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Subscriber(MIN),
	Minutes int NOT NULL,
	DataInMB int NOT NULL,
	Texts int NOT NULL,
);

-- Visualized --
-- 1 -- 
-- A
SELECT CONCAT(FirstName, ' ', LastName) AS 'Name', -- return name
	   Minutes, -- return minutes
	   DataInMB AS 'Data Usage', -- return data usage
	   Texts, -- return texts
	   Total AS 'Total Bill' -- return total bill
FROM Subscriber JOIN LastMonthUsage -- from Subscriber and LastMonthUsage
	ON Subscriber.[MIN] = LastMonthUsage.[MIN]
		JOIN Bill -- and Bill
			ON LastMonthUsage.[MIN] = Bill.[MIN]
ORDER BY CONCAT(FirstName, ' ', LastName); -- sorted by name

-- B
SELECT City, -- Return city
	   AVG(Minutes) AS 'Avg Minutes', -- average minutes by city
	   AVG(DataInMB) AS 'Avg Data Usage', -- average data usage by city
	   AVG(Texts) AS 'Avg Texts', -- average texts by city
	   AVG(Total) AS 'Avg Total Bill' -- average total bill by city
FROM Subscriber JOIN LastMonthUsage -- from Subscriber and LastMonthUsage
	ON Subscriber.[MIN] = LastMonthUsage.[MIN]
		JOIN Bill -- and Bill
			ON LastMonthUsage.[MIN] = Bill.[MIN]
GROUP BY City; -- grouped by the city

-- C
SELECT City, -- Return city
	   SUM(Minutes) AS 'Total Minutes', -- total minutes by city
	   SUM(DataInMB) AS 'Total Data Usage', -- total data usage by city
	   SUM(Texts) AS 'Total Texts', -- total texts by city
	   SUM(Total) AS 'Total Total Bill' -- total total bill by city
FROM Subscriber JOIN LastMonthUsage -- from Subscriber and LastMonthUsage
	ON Subscriber.[MIN] = LastMonthUsage.[MIN]
		JOIN Bill -- and Bill
			ON LastMonthUsage.[MIN] = Bill.[MIN]
GROUP BY City; -- grouped by the city

-- D
SELECT PlanName, -- Return city
	   AVG(Minutes) AS 'Avg Minutes', -- average minutes by plan name
	   AVG(DataInMB) AS 'Avg Data Usage', -- average data usage by plan name
	   AVG(Texts) AS 'Avg Texts', -- average texts by plan name
	   AVG(Total) AS 'Avg Total Bill' -- average total bill by plan name
FROM Subscriber JOIN LastMonthUsage -- from Subscriber and LastMonthUsage
	ON Subscriber.[MIN] = LastMonthUsage.[MIN]
		JOIN Bill -- and Bill
			ON LastMonthUsage.[MIN] = Bill.[MIN]
GROUP BY PlanName; -- grouped by the plan name

-- E
SELECT PlanName, -- Return city
	   SUM(Minutes) AS 'Total Minutes', -- total minutes by plan name
	   SUM(DataInMB) AS 'Total Data Usage', -- total data usage by plan name
	   SUM(Texts) AS 'Total Texts', -- total texts by plan name
	   SUM(Total) AS 'Total Total Bill' -- total total bill by plan name
FROM Subscriber JOIN LastMonthUsage -- from Subscriber and LastMonthUsage
	ON Subscriber.[MIN] = LastMonthUsage.[MIN]
		JOIN Bill -- and Bill
			ON LastMonthUsage.[MIN] = Bill.[MIN]
GROUP BY PlanName; -- grouped by the plan name

-- Non-Visualized --
-- 1 --
-- A
SELECT TOP 2 City, -- returning the top 2 cities
	   COUNT([MIN]) AS '# Customers' -- and the count of customers
FROM Subscriber -- from the subscriber database
GROUP BY City -- grouping the number of customers into their respective cities
ORDER BY COUNT([MIN]) DESC; -- ordered from highest to lowest

/*
We should not spend marketing dollars in Seattle or Olympia, since we have a high number of customers in these cities
*/

-- B
SELECT TOP 3 City, -- returning the top 3 cities
	   COUNT([MIN]) AS '# Customers' -- and the count of customers
FROM Subscriber -- from the subscriber database
GROUP BY City -- grouping the number of customers into their respective cities
ORDER BY COUNT([MIN]); -- ordering from lowest to highest

/*
We should spend more resources marketing in Kent, Issaquah, and Tacoma, since there is only one customer in each city
*/

-- C 
SELECT TOP 4 PlanName AS 'Plan Name', -- returning the top 4 plans
	   COUNT(PlanName) AS '# Customers' -- returning the count of customers per plan
FROM Subscriber -- from the subscriber database
GROUP BY PlanName -- grouping the number of customers into their plan groups
ORDER BY COUNT(PlanName); -- sorted from least customers to most customers

/*
We should spend most time marketing Data2, Data10, Data25, and UnlSuper, as they have the lowest customer count
*/

-- 2 --
-- A
SELECT Type AS 'Phone Type', -- returning phone type
	   COUNT(Type) AS '# Customers' -- returning the number of customers
FROM Device -- from the device database
GROUP BY Type -- grouping customers by their phone type
ORDER BY COUNT(Type) DESC; -- sorted from most customers to least

/*
Most of our customers use Android phones, therefore we should market Apple devices
*/

-- B

SELECT CONCAT(FirstName, ' ', LastName) AS 'Name', -- returning name of customer 
	   Type -- and the type of phone they have
FROM Subscriber JOIN DirNums -- pulling name from Subscriber and using DirNums to link to Device
	ON Subscriber.MDN = DirNums.MDN -- using DirNums as connection
	JOIN Device -- adding Device database for the phone type
		ON DirNums.IMEI = Device.IMEI 
WHERE Type = 'Apple' -- pulling only those with Apple since it's least used
ORDER BY 'Name'; -- sorted alphabetically 

/*
There are 7 customers who use the least-used phone type (Apple), so we should give them the promotion
*/

-- C
SELECT CONCAT(FirstName, ' ', LastName) AS 'Name', -- returning customer name
	   YearReleased AS 'Year Released' -- and the year their phone released
FROM Subscriber JOIN DirNums -- pulling name from Subscriber and using DirNums to link to Device
	ON Subscriber.MDN = DirNums.MDN -- using DirNums as connection
	JOIN Device -- adding Device database for the phone type
		ON DirNums.IMEI = Device.IMEI 
WHERE YearReleased < 2018 -- pulling those who's phone was released before 2018
ORDER BY YearReleased DESC; -- ordered by year released

/*
8 customers have phones released before 2018, with the oldest being Ben Grimm with a 2014 model
We should be careful marketing to these people, as their phones may not be able to utilize the newest technology
However, we could market our newest phone releases to get them to upgrade
*/

-- 3 --
-- A
SELECT TOP 3 City, -- selecting the top 3 cities
	   SUM(DataInMB) AS 'Total Data Usage', -- returning the sum of all data usage
	   COUNT(MDN) AS '# Total Customers' -- returning the count of customers
FROM Subscriber JOIN LastMonthUsage -- joining these two databases
	ON  Subscriber.[MIN] = LastMonthUsage.[MIN] -- on MIN
GROUP BY City -- grouping customers into cities they live in
ORDER BY 'Total Data Usage' DESC; -- sorted by data usage highest to lowest

/*
This query gives us the top 3 cities in minutes usage: Olympia, Bellevue, and Seattle
*/

-- B
SELECT City, -- returning the city
	   COUNT(PlanName) AS '# Customers w/ No Unlimited' -- and the number of customers
FROM Subscriber -- from Subscriber
WHERE PlanName NOT LIKE 'Unl%' -- where the plan is not unlimited
	AND City IN('Olympia', 'Bellevue', 'Seattle') -- from these 3 cities that are top in data usage
GROUP BY City; -- grouped by the city
/*
Each of the top 3 cities by minutes has 2 customers not on unlimited plans

However, Belleuve has two total customers as shown by query A, 
therefore Belleuve has zero customers on Unlimited Plans
*/

-- 4 --
-- A
SELECT TOP 1 CONCAT(FirstName, ' ', LastName) AS 'Name', -- returning the name of the customer
		     CONCAT('$', Total) AS 'Total Bill' -- returning their bill amount
FROM Subscriber, Bill -- from these two databases
WHERE Subscriber.[MIN] = Bill.[MIN] -- joining on the MIN column
ORDER BY Total DESC; -- sorted highest to lowest

/*
Frank Castle has the highest bill with $224.12
*/

-- B
SELECT TOP 1 Subscriber.PlanName AS 'Plan Name', -- returning plan name
			 COUNT(Subscriber.PlanName) AS '# of Customers on Plan', -- returning # of customers on that plan
			 CONCAT('$',Cost) AS 'Monthly Revenue per MIN', -- returning monthly revenue per customer
			 CONCAT('$',SUM(Cost)) AS 'Total Revenue' -- returning total revenue
FROM Subscriber, MPlan -- from these two databases
WHERE Subscriber.PlanName = MPlan.PlanName -- joined by PlanName
GROUP BY Subscriber.PlanName, MPlan.Cost -- Grouped by PlanName and Cost
ORDER BY SUM(Cost) DESC; -- sorted highest to lowest

/*
The Unlimited Prime plan with 4 customers brings in the most revenue
*/

-- 5 --
-- A
SELECT TOP 1 LEFT(MDN, 3) AS 'Area Code', -- returning the first 3 digits of their cell number
		     SUM(Minutes) AS 'Total Minutes Used' -- returning total minutes used
FROM Subscriber, LastMonthUsage -- from these databases
WHERE Subscriber.[MIN] = LastMonthUsage.[MIN] -- joined by MIN
GROUP BY Subscriber.MDN -- grouped by cell number
ORDER BY Sum(Minutes) DESC; -- sorted by minutes used

/*
253 area code is the most used, therefore marketing resources shouldn't be used in that area
*/

-- B 
SELECT TOP 2 City, -- returning the top 2 cities
	  (MAX(Minutes) - MIN(Minutes)) AS 'Variance' -- calculating the variance
FROM Subscriber, LastMonthUsage -- from these databases
WHERE Subscriber.[MIN] = LastMonthUsage.[MIN] -- joined by MIN
		AND Minutes NOT BETWEEN 200 AND 700 -- using only minutes higher than 700 and lower than 200
GROUP BY City -- grouped by city
Order By (MAX(Minutes) - MIN(Minutes)) DESC; -- ordered by variance

/*
Spokane has the most variance, followed by Seattle
*/
