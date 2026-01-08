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