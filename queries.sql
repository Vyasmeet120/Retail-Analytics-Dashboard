-- ===============================
-- 1. TOTAL REVENUE BY STORE
-- ===============================
SELECT 
    Store_ID,
    SUM(Revenue) AS Total_Revenue
FROM Sales
GROUP BY Store_ID
ORDER BY Total_Revenue DESC;


-- ===============================
-- 2. TOTAL UNITS SOLD BY STORE
-- ===============================
SELECT 
    Store_ID,
    SUM(Units_Sold) AS Total_Units_Sold
FROM Sales
GROUP BY Store_ID
ORDER BY Total_Units_Sold DESC;


-- ===============================
-- 3. REVENUE BY PRODUCT CATEGORY
-- ===============================
SELECT 
    p.Category,
    SUM(s.Revenue) AS Total_Revenue
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Total_Revenue DESC;


-- ===============================
-- 4. CATEGORY PROFITABILITY
-- ===============================
SELECT 
    p.Category,
    SUM(s.Revenue) AS Total_Revenue,
    SUM(p.Cost * s.Units_Sold) AS Total_Cost,
    SUM(s.Revenue) - SUM(p.Cost * s.Units_Sold) AS Profit
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Profit DESC;


-- ===============================
-- 5. TOP 10 BEST-SELLING PRODUCTS
-- ===============================
SELECT 
    s.Product_ID,
    p.Category,
    p.Subcategory,
    SUM(s.Units_Sold) AS Total_Units
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
GROUP BY s.Product_ID, p.Category, p.Subcategory
ORDER BY Total_Units DESC
LIMIT 10;


-- ===============================
-- 6. MONTHLY REVENUE TREND
-- ===============================
SELECT 
    DATE_TRUNC('month', Date) AS Month,
    SUM(Revenue) AS Total_Revenue
FROM Sales
GROUP BY Month
ORDER BY Month;


-- ===============================
-- 7. MONTH-OVER-MONTH GROWTH
-- ===============================
SELECT 
    DATE_TRUNC('month', Date) AS Month,
    SUM(Revenue) AS Total_Revenue,
    LAG(SUM(Revenue)) OVER (ORDER BY DATE_TRUNC('month', Date)) AS Prev_Month_Revenue,
    (SUM(Revenue) - LAG(SUM(Revenue)) OVER (ORDER BY DATE_TRUNC('month', Date)))
        / NULLIF(LAG(SUM(Revenue)) OVER (ORDER BY DATE_TRUNC('month', Date)), 0) AS MoM_Growth
FROM Sales
GROUP BY Month
ORDER BY Month;


-- ===============================
-- 8. SHRINKAGE PER STORE
-- ===============================
SELECT 
    Store_ID,
    SUM(Shrinkage) AS Total_Shrinkage
FROM Inventory
GROUP BY Store_ID
ORDER BY Total_Shrinkage DESC;


-- ===============================
-- 9. INVENTORY TURNOVER
-- ===============================
SELECT 
    i.Store_ID,
    i.Product_ID,
    SUM(s.Units_Sold) AS Units_Sold,
    AVG(i.Opening_Stock) AS Avg_Inventory,
    SUM(s.Units_Sold) / NULLIF(AVG(i.Opening_Stock), 0) AS Inventory_Turnover
FROM Inventory i
LEFT JOIN Sales s ON i.Store_ID = s.Store_ID 
                  AND i.Product_ID = s.Product_ID
GROUP BY i.Store_ID, i.Product_ID
ORDER BY Inventory_Turnover DESC;


-- ===============================
-- 10. STOCKOUTS PER PRODUCT
-- ===============================
SELECT 
    Product_ID,
    Store_ID,
    SUM(CASE WHEN Closing_Stock = 0 THEN 1 ELSE 0 END) AS Stockout_Days
FROM Inventory
GROUP BY Product_ID, Store_ID
ORDER BY Stockout_Days DESC;
