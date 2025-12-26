-- Creating new database
CREATE DATABASE IF NOT EXISTS Olist;

-- Using database Olist
USE Olist;

-- Creating Customers table
CREATE TABLE Customers (
	Customer_id VARCHAR(255) PRIMARY KEY NOT NULL,
    Customer_unique_id VARCHAR(255) NOT NULL,
    Customer_zip_code_prefix VARCHAR(50) NOT NULL,
    Customer_city VARCHAR(255) NOT NULL,
    Customer_state VARCHAR(50) NOT NULL
);

-- Creating Order_items table
CREATE TABLE Order_items (
	Order_id VARCHAR(255) NOT NULL,
    Item_id INT NOT NULL,
    Product_id VARCHAR(255) NOT NULL,
    Seller_id VARCHAR(255) NOT NULL,
    Shipping_limit_date DATE NOT NULL,
    Price Double NOT NULL,
    Freight_value DOUBLE NOT NULL
);

-- Creating Order_payments table
CREATE TABLE Order_payments (
	Order_id VARCHAR(255) NOT NULL,
    Payment_sequential INT NOT NULL,
    Payment_type VARCHAR(50) NOT NULL,
    Payment_installments INT NOT NULL,
	Payment_value DOUBLE NOT NULL
);

-- Creating Order_reviews table, 9924 EXPECTED RECORDS
CREATE TABLE Order_reviews (
	Review_id VARCHAR(255) NOT NULL,
    Order_id VARCHAR(255) NOT NULL,
    Review_score INT NOT NULL, 
    Review_creation_date DATE,
    Review_answer_timestamp DATETIME
);

-- Creating Orders table
CREATE TABLE Orders (
	order_id VARCHAR(255) UNIQUE NOT NULL PRIMARY KEY,
    Customer_id VARCHAR(255) NOT NULL,
    Order_status VARCHAR(50) NOT NULL,
    Order_purchase_timestamp VARCHAR(100), -- DATETIME NOT NULL,
    Order_approved_at VARCHAR(100), --  DATETIME,
    Order_delivered_carrier_date VARCHAR(100), --  DATE,
    Order_delivered_customer_date VARCHAR(100), --  DATE,
    Order_estimated_delivery_date VARCHAR(100) --  DATE
);

-- Creating Products table
CREATE TABLE Products (
	Product_id VARCHAR(255) UNIQUE PRIMARY KEY,
    Product_category_name VARCHAR(255),
    Porduct_name_length VARCHAR(50),	-- Should modify dayatype to INT
    Product_description_length VARCHAR(50),	-- Should modify dayatype to INT
    Product_photos_qty VARCHAR(50),	-- Should modify dayatype to INT
    Product_weight_g VARCHAR(50),	-- Should modify dayatype to INT
    Product_length_cm VARCHAR(50),	-- Should modify dayatype to INT
    Product_height_cm VARCHAR(50),	-- Should modify dayatype to INT
    Product_width_cm VARCHAR(50)	-- Should modify dayatype to INT
);

-- Creating Sellers table
CREATE TABLE Sellers (
	Seller_id VARCHAR(255) NOT NULL UNIQUE PRIMARY KEY,
    Seller_zip_code_prefix VARCHAR(50) NOT NULL,
    Seller_city VARCHAR(150) NOT NULL,
    Seller_state VARCHAR(50) NOT NULL
);

-- Creating Product_category_name_translation table
CREATE TABLE Product_category_name_translation (
	Product_category_name VARCHAR(255),
    Product_category_name_english VARCHAR(255)
);

-- Checking import errors like nulls, datatype errors

SELECT * FROM customers;
SELECT COUNT(*) FROM customers;
DESCRIBE customers;		-- No errors

SELECT * FROM Order_items;
SELECT COUNT(*) FROM Order_items;
DESCRIBE Order_items;		-- No errors

SELECT * FROM order_payments;
SELECT COUNT(*) FROM order_payments;
DESCRIBE order_payments;		-- No errors

SELECT * FROM order_reviews;
SELECT COUNT(*) FROM order_reviews;
DESCRIBE order_reviews;		-- Need to check null values with 2 columns review_creation_date & review_answer_timestamp

SELECT 
	COUNT(review_creation_date), 
    COUNT(review_answer_timestamp)
FROM order_reviews
WHERE review_creation_date IS NULL
	AND review_answer_timestamp IS NULL; -- No null value in either of the fields. So, It's better to apply NOT NULL constraint to these columns
    
-- Applying NOT NULL constraint to 2 columns review_creation_date & review_answer_timestamp
ALTER TABLE order_reviews
MODIFY review_creation_date DATE NOT NULL,
MODIFY review_answer_timestamp DATETIME NOT NULL;

-- Rechecking order_reviews table for confirming changes
DESCRIBE order_reviews;

-- Checking import errors like nulls, datatype errors

SELECT * FROM product_category_name_translation;
SELECT COUNT(*) FROM product_category_name_translation;
DESCRIBE product_category_name_translation;		-- No null's in the data. Need to apply NOT NULL constraint

ALTER TABLE product_category_name_translation
MODIFY product_category_name VARCHAR(255) NOT NULL,
MODIFY product_category_name_english VARCHAR(255) NOT NULL;

-- Rechecking order_reviews table for confirming changes
DESCRIBE product_category_name_translation;

-- Checking import errors like nulls, datatype errors

SELECT * FROM sellers;
SELECT COUNT(*) FROM sellers;
DESCRIBE sellers;	-- No errors

SELECT * FROM products;
SELECT COUNT(*) FROM products;
DESCRIBE products; -- check for null values and need datatype modifications

-- checking null's in product_category_name field

SELECT COUNT(*) FROM products
WHERE product_category_name  = ''; -- identified 610 null values

-- replacing '' with null in product_categor_name field

UPDATE products
SET product_category_name = NULL 
WHERE product_category_name = '';

SELECT COUNT(*) FROM products
where product_category_name IS NULL; -- verifying null replacement

-- checking null's in product_name_length field
-- renaming required

ALTER TABLE products
RENAME COLUMN porduct_name_length TO product_name_length;

SELECT COUNT(*) FROM products
WHERE product_name_length IS NULL
OR product_name_length = ''
OR product_name_length = ' '; -- Identified 610 null values. replace '' with NULL

UPDATE products
SET product_name_length = NULL 
WHERE product_name_length = '';

-- not modify datatype to INT
ALTER TABLE products
MODIFY product_name_length INT;

DESCRIBE products; 	-- Confirmation check

-- checking null's in product_description_length field

SELECT COUNT(*) FROM products
WHERE product_description_length IS NULL
OR product_description_length = ''
OR product_description_length = ' '; 	-- identified 610 null's. Rplace '' with NULL

UPDATE products
SET product_description_length = NULL 
WHERE product_description_length = '';

-- not modify datatype to INT
ALTER TABLE products
MODIFY product_description_length INT;

DESCRIBE products; 	-- Confirmation check

-- checking null's in product_photos_qty

SELECT COUNT(*) FROM products
WHERE product_photos_qty IS NULL
OR product_photos_qty = ''
OR product_photos_qty = ' '; 	-- identified 610 null's. Rplace '' with NULL

UPDATE products
SET product_photos_qty = NULL 
WHERE product_photos_qty = '';

-- not modify datatype to INT
ALTER TABLE products
MODIFY product_photos_qty INT;

DESCRIBE products; 	-- Confirmation check

-- checking null's in product_weight_g

SELECT COUNT(*) FROM products
WHERE product_weight_g IS NULL
OR product_weight_g = ''
OR product_weight_g = ' '; 	-- identified 610 null's. Rplace '' with NULL

UPDATE products
SET product_weight_g = NULL 
WHERE product_weight_g = '';

-- not modify datatype to INT
ALTER TABLE products
MODIFY product_weight_g INT;

DESCRIBE products; 	-- Confirmation check

-- checking null's in product_length_cm

SELECT COUNT(*) FROM products
WHERE product_length_cm IS NULL
OR product_length_cm = ''
OR product_length_cm = ' '; 	-- identified 610 null's. Rplace '' with NULL

UPDATE products
SET product_length_cm = NULL 
WHERE product_length_cm = '';

-- modify datatype to INT
ALTER TABLE products
MODIFY product_length_cm INT;

DESCRIBE products; 	-- Confirmation check

-- checking null's in product_height_cm

SELECT COUNT(*) FROM products
WHERE product_height_cm IS NULL
OR product_height_cm = ''
OR product_height_cm = ' '; 	-- identified 610 null's. Rplace '' with NULL

UPDATE products
SET product_height_cm = NULL 
WHERE product_height_cm = '';

-- not modify datatype to INT
ALTER TABLE products
MODIFY product_height_cm INT;

DESCRIBE products; 	-- Confirmation check

-- checking null's in product_width_cm

SELECT COUNT(*) FROM products
WHERE product_width_cm IS NULL
OR product_width_cm = ''
OR product_width_cm = ' '; 	-- identified 610 null's. Rplace '' with NULL

UPDATE products
SET product_width_cm = NULL 
WHERE product_width_cm = '';

-- not modify datatype to INT
ALTER TABLE products
MODIFY product_width_cm INT;

DESCRIBE products; 	-- Confirmation check

-- Cleaning Order table

DESCRIBE orders;		-- Need datatype corrections to order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date

-- order_purchase_timestamp
SELECT
	COUNT(*)
FROM Orders
WHERE order_purchase_timestamp IS NULL
	OR order_purchase_timestamp = ''
    OR order_purchase_timestamp = ' ';		-- Found no nulls, change datatype to datetime
    
SELECT
	order_purchase_timestamp
FROM Orders;

-- converting order_purchase_timestamp to datetime

ALTER TABLE Orders
MODIFY order_purchase_timestamp DATETIME;

-- Dealing with nulls order_approved_at and datatype datetime and 

SELECT
	COUNT(*)
FROM Orders
WHERE order_approved_at IS NULL
	OR order_approved_at = ''
	OR order_approved_at = ' ';
    
UPDATE Orders
SET order_approved_at = NULL
WHERE order_approved_at = '';

ALTER TABLE Orders
MODIFY order_approved_at DATETIME;

-- Dealing with null's and datatype Order_delivered_carrier_date
SELECT
	COUNT(*)
FROM Orders
WHERE Order_delivered_carrier_date IS NULL
	OR Order_delivered_carrier_date = ''
    OR Order_delivered_carrier_date = ' ';
    
UPDATE Orders
SET Order_delivered_carrier_date = NULL
WHERE Order_delivered_carrier_date = '';

ALTER TABLE Orders
MODIFY Order_delivered_carrier_date DATE;

-- Dealing with null's & datatype convertion
SELECT 
	COUNT(*)
FROM Orders
WHERE Order_delivered_customer_date IS NULL
	OR Order_delivered_customer_date = ''
    OR Order_delivered_customer_date = ' ';
    
UPDATE Orders
SET Order_delivered_customer_date = NULL 
WHERE Order_delivered_customer_date = '';

ALTER TABLE Orders
MODIFY Order_delivered_customer_date DATE;

-- Dealing with null's and datatype Order_estimated_delivery_date

SELECT 
	COUNT(*)
FROM Orders
WHERE Order_estimated_delivery_date IS NULL
 OR Order_estimated_delivery_date = ''
 OR Order_estimated_delivery_date = ' '; 
 
 ALTER TABLE Orders
 MODIFY Order_estimated_delivery_date DATE;
 
 -- Verifying changes
 DESCRIBE Orders;
 
 
 
 
 
 
 