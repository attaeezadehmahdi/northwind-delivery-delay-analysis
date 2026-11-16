-- =============================================================================
-- NORTHWIND: DELIVERY TIME ANALYSIS
-- =============================================================================
-- Purpose:
-- Analyze order-to-shipment time across different business dimensions:
--   1. Product Category
--   2. Product
--   3. Order Quantity
--   4. Shipping Country
--   5. Shipping Company
--
-- Metric:
-- Order-to-Shipment Time = DATEDIFF(DAY, OrderDate, ShippedDate)
--
-- Note:
-- Only shipped orders are included in the analysis.
-- =============================================================================


-- =============================================================================
-- 1. CATEGORY ANALYSIS
-- Purpose: Calculate the average order-to-shipment time for each category.
-- =============================================================================

WITH table_1 AS (
    SELECT
        od.ProductID,
        p.CategoryID,
        o.OrderDate,
        o.ShippedDate
    FROM dbo.[Order Details] od
    INNER JOIN dbo.Orders o
        ON od.OrderID = o.OrderID
    INNER JOIN dbo.Products p
        ON od.ProductID = p.ProductID
    WHERE o.ShippedDate IS NOT NULL
),
table_2 AS (
    SELECT
        CategoryID,
        DATEDIFF(DAY, OrderDate, ShippedDate) Gap_Day
    FROM table_1
)
SELECT
    CategoryID,
    AVG(Gap_Day) AS Day_Gap_Average
FROM table_2
GROUP BY CategoryID
ORDER BY 2 DESC;


-- =============================================================================
-- 2. PRODUCT ANALYSIS
-- Purpose: Calculate the average order-to-shipment time for each product
--          and compare it with the overall average.
-- =============================================================================

WITH table_1 AS (
    SELECT
        od.ProductID,
        o.OrderDate,
        o.ShippedDate
    FROM dbo.[Order Details] od
    INNER JOIN dbo.Orders o
        ON od.OrderID = o.OrderID
    WHERE o.ShippedDate IS NOT NULL
),
table_2 AS (
    SELECT
        ProductID,
        DATEDIFF(DAY, OrderDate, ShippedDate) Gap_Day
    FROM table_1
)
SELECT
    ProductID,
    AVG(Gap_Day) AS Day_Gap_Average,
    (SELECT AVG(Gap_Day) FROM table_2) AS Average
FROM table_2
GROUP BY ProductID
ORDER BY 2 DESC;


-- =============================================================================
-- 3. QUANTITY ANALYSIS
-- Purpose: Examine the relationship between order quantity and average
--          order-to-shipment time using eight quantity groups.
-- =============================================================================

WITH table_1 AS (
    SELECT
        od.OrderID,
        od.Quantity,
        o.OrderDate,
        o.ShippedDate,
        DATEDIFF(DAY, OrderDate, ShippedDate) Gap_Day,
        MAX(od.Quantity) OVER() Max,
        MIN(od.Quantity) OVER() Min
    FROM dbo.[Order Details] od
    INNER JOIN dbo.Orders o
        ON od.OrderID = o.OrderID
    WHERE o.ShippedDate IS NOT NULL
),
table_2 AS (
    SELECT
        Quantity,
        AVG(Gap_Day) Average_Day
    FROM table_1
    GROUP BY Quantity
),
table_3 AS (
    SELECT
        *,
        NTILE(8) OVER(ORDER BY Quantity) Bins
    FROM table_2
)
SELECT
    Quantity,
    Bins,
    AVG(Average_Day) OVER(PARTITION BY Bins) AS Average_Day_Gap,
    STDEV(Average_Day) OVER(PARTITION BY Bins) AS STD
FROM table_3
ORDER BY 2;


-- =============================================================================
-- 4. COUNTRY ANALYSIS
-- Purpose: Compare the average order-to-shipment time across shipping countries
--          with the overall average.
-- =============================================================================

WITH Gap_day AS (
    SELECT
        ShipCountry,
        OrderDate,
        ShippedDate,
        DATEDIFF(DAY, OrderDate, ShippedDate) AS Order_to_ship
    FROM [NORTHWND].[dbo].[Orders]
    WHERE ShippedDate IS NOT NULL
),
cte AS (
    SELECT
        ShipCountry,
        AVG(Order_to_ship) OVER(PARTITION BY ShipCountry) Average_Order_to_ship,
        AVG(Order_to_ship) OVER() Total_avg
    FROM Gap_day
)
SELECT
    *,
    Average_Order_to_ship - Total_avg STD,
    DENSE_RANK() OVER(ORDER BY Average_Order_to_ship) RANK
FROM cte
ORDER BY STD DESC;


-- =============================================================================
-- 5. SHIPPER ANALYSIS
-- Purpose: Compare shipping companies based on the number of shipped orders
--          and their average order-to-shipment time.
-- =============================================================================

WITH Gap_day AS (
    SELECT
        ShipVia,
        OrderDate,
        ShippedDate,
        DATEDIFF(DAY, OrderDate, ShippedDate) AS Order_to_ship
    FROM NORTHWND.dbo.Orders
    WHERE ShippedDate IS NOT NULL
),
Company_order AS (
    SELECT
        CompanyName,
        Order_to_ship
    FROM Gap_day
    JOIN NORTHWND.dbo.Shippers
        ON Gap_day.ShipVia = Shippers.ShipperID
)
SELECT
    CompanyName,
    COUNT(*) AS TotalOrders,
    AVG(Order_to_ship * 1.0) AS AvgOrderToShip
FROM Company_order
GROUP BY CompanyName
ORDER BY AvgOrderToShip;
