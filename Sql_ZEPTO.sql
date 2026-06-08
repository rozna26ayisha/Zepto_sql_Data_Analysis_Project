CREATE DATABASE Zepto;
SELECT * FROM zepto_v2;
ALTER TABLE zepto_v2
ADD COLUMN sku_id INT AUTO_INCREMENT PRIMARY KEY FIRST;
ALTER TABLE zepto_v2
RENAME COLUMN ï»¿Category TO category;
SET SQL_SAFE_UPDATES = 0;

-- Data Exploration --
-- count of rows
SELECT COUNT(*) FROM zepto_v2;

-- sample data
SELECT * FROM zepto_v2
LIMIT 10;

-- Check for null values (no null values are there)
SELECT * FROM zepto_v2
WHERE name IS NULL
OR category IS NULL
OR mrp IS NULL
OR discountPercent IS NULL
OR availableQuantity IS NULL
OR discountedSellingPrice IS NULL
OR weightInGms IS NULL
OR outOfStock IS NULL
OR quantity IS NULL;

-- distinct product categories
SELECT DISTINCT(category) FROM zepto_v2;

-- product in stock and out stock count
SELECT outOfStock, count(sku_id) FROM zepto_v2
GROUP BY outOfStock;

-- product names present multiple times
SELECT name,count(sku_id) FROM zepto_v2
GROUP BY name
HAVING count(sku_id) >1;

-- Data Cleaning --
-- Removing rows where mrp and SP is 0
SELECT * FROM zepto_v2
WHERE mrp = 0 OR discountedSellingPrice = 0; -- 3636 th row have both column as 0

DELETE FROM zepto_v2
WHERE mrp = 0;

-- Converting paise to rupees
UPDATE zepto_v2
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT * FROM zepto_v2;

-- Data Analysis --
-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name,mrp,discountPercent FROM zepto_v2
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock.
SELECT name,mrp,outOfStock FROM zepto_v2
WHERE outOfStock = 'TRUE' AND mrp > 300
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT category,SUM(discountedSellingPrice * availableQuantity) AS total_revenue FROM zepto_v2
GROUP BY category;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT name,mrp,discountPercent FROM zepto_v2
WHERE mrp>500 AND discountPercent < 10;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,AVG(discountPercent) AS avg_discount FROM zepto_v2
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name,discountedSellingPrice,weightInGms,
(discountedSellingPrice/weightInGms,2) AS price_per_gram FROM zepto_v2
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT name,weightInGms,
CASE
WHEN weightInGms < 1000 THEN 'Low'
WHEN weightInGms < 5000 THEN 'Medium'
ELSE 'Bulk'
END AS 'weight_category'
FROM zepto_v2;

-- Q8.What is the Total Inventory Weight Per Category 
SELECT category,SUM(availableQuantity*weightInGms) AS inventory_weight FROM zepto_v2
GROUP BY category
ORDER BY inventory_weight DESC;


