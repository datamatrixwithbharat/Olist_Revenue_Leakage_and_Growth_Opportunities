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
 
 -- Update Primary & Foreign keys
 
ALTER TABLE Orders
ADD CONSTRAINT
FOREIGN KEY (customer_id)
REFERENCES Customers(customer_id);
 
ALTER TABLE Product_category_name_translation
ADD PRIMARY KEY (product_category_name);

ALTER TABLE Order_items
ADD CONSTRAINT
FOREIGN KEY (order_id)
REFERENCES Orders(order_id),
ADD CONSTRAINT 
FOREIGN KEY (product_id)
REFERENCES Products(product_id),
ADD CONSTRAINT 
FOREIGN KEY (seller_id)
REFERENCES Sellers(seller_id);
 
 ALTER TABLE order_payments
 ADD CONSTRAINT
 FOREIGN KEY (order_id)
 REFERENCES Orders(order_id);
 
-- *Revenue lost*
-- 1. What is the percentage of revenue loss due to cancelled orders per year.
-- Concidering delivered orders as generated revenue, cancelled & unavailable orders as lost revenue and others as processing but not added to revenue

WITH revenue_details AS (
	SELECT 
		SUM(CASE WHEN order_status = 'delivered' THEN payment_value ELSE 0 END) as revenue_generated, 
		SUM(CASE WHEN order_status IN ('canceled', 'unavailable') THEN payment_value ELSE 0 END) as revenue_lost, 
		year_
	FROM (
			SELECT
				o.order_id, 
				o.order_status, 
				SUM(p.payment_value) AS payment_value, 
			YEAR(order_purchase_timestamp) AS year_
			FROM orders o 
			LEFT JOIN order_payments p 
			ON o.order_id = p.order_id 
			GROUP BY o.order_id, o.order_status
		) AS t
	GROUP BY year_
)
SELECT 
	year_, 
	ROUND( (revenue_lost / (revenue_lost + revenue_generated)) * 100, 2) AS percentage_of_revenue_loss
FROM revenue_details
ORDER BY year_;		-- Though the revenue loss is higher in 2016 - 13.94%, loss dropped to 2.22% in 2017 and 1.23% in 2018.

-- 2. What is the cancellation rate and total revenue lost per customer? order by cancellation rate high to low.
SELECT
	customer_unique_id,
    ROUND(
		(
			COUNT(CASE WHEN order_status = 'canceled' OR order_status = 'unavailable' THEN 1 END) 
			/
			(
				COUNT(CASE WHEN order_status = 'canceled' OR order_status = 'unavailable' THEN 1 END)
				+
				COUNT(CASE WHEN order_status = 'delivered' THEN 1 END)
			)
			) * 100, 
	2) AS cancellation_rate, 
    SUM(CASE WHEN order_status = 'canceled' OR order_status = 'unavailable' THEN payment_value ELSE 0 END) as revenue_lost
FROM (
	SELECT 
		o.customer_id AS customer_id,
		c.customer_unique_id AS customer_unique_id,
		o.order_status AS order_status,
		SUM(op.payment_value) AS payment_value
	FROM orders o 
	LEFT JOIN customers c 
	ON o.customer_id = c.customer_id
	LEFT JOIN order_payments op
	ON  op.order_id = o.order_id
    GROUP BY customer_id, customer_unique_id, order_status
) AS temp_table
GROUP BY customer_unique_id
HAVING revenue_lost > 0
ORDER BY cancellation_rate DESC;	-- Identified that most of the cancellations are from one time customers.

-- 3. What is the average cancellation rate of sellers and total revenue lost per seller? order by cancellation rate high to low.
SELECT 
	seller_id, 
    SUM(CASE WHEN order_status = 'canceled' OR order_status = 'unavailable' THEN payment_value ELSE 0 END) 
    AS revenue_lost, 
    ROUND(( COUNT(CASE WHEN order_status = 'canceled' OR order_status = 'unavailable' THEN 1 END) / 
		(COUNT(CASE WHEN order_status = 'delivered' THEN 1 END) + 
        COUNT(CASE WHEN order_status = 'canceled' OR order_status = 'unavailable' THEN 1 END))
    ) * 100, 2)
    AS cancellation_rate
FROM
(SELECT
	i.order_id, 
    i.seller_id, 
    o.order_status, 
    SUM(p.payment_value) AS payment_value
FROM order_items i
LEFT JOIN orders o  
ON i.order_id = o.order_id
INNER JOIN order_payments p 
ON i.order_id = p.order_id
WHERE i.item_id = 1
GROUP BY i.order_id, i.seller_id, o.order_status) AS t
GROUP BY seller_id
HAVING revenue_lost > 0
ORDER BY cancellation_rate DESC;

-- 4. How many orders are cancelled and revenue lost due to payment failure.
-- No details of payment failure in the dataset

-- 5. Total cancellations by reason.
-- No fields in dataset for cancellation reason.

-- 6. What is the average time for cancellation from order date to cancellation date?
-- No details of cancellation date in dataset

-- 7. Revenue lost by cancellations before shipment Vs after shipment.
SELECT 
	ROUND(SUM(CASE WHEN shipped = 'No' THEN payment_value ELSE 0 END), 2) AS revenue_loss_before_shipping, 
    ROUND(SUM(CASE WHEN shipped = 'YES' THEN payment_value ELSE 0 END), 2) AS revenue_loss_after_shipping 
FROM (
	SELECT 
			o.order_id, 
			CASE 
				WHEN Order_delivered_carrier_date IS NULL THEN 'No' 
				ELSE 'Yes' 
			END AS shipped, 
			p.payment_value
	FROM orders o
	INNER JOIN order_payments p 
	ON o.order_id = p.order_id 
	WHERE o.order_status IN ('canceled', 'unavailable')
) AS temp_table;	/* Loss before shipping is 2,60,867.45 and after shipping is 8,867.66. 
						This indicating that revenue loss after shipping is comparitively low */

-- *Delivery delay & geographical sales*
-- 1. What is the average delivery duration of successfull orders?

SELECT 
	ROUND( 
		AVG( 
			DATEDIFF( Order_delivered_customer_date, order_purchase_timestamp)
			), 2
    )AS average_delivery_duration_in_days
FROM orders
WHERE order_status = 'delivered';	/* The average delivery duration is 12.5 days. 
										Also identified few orders with 20+ days of delivery duration, 
										might be the reason for cancellations and onetime buyers */

-- 2. What is the average delivery duration of cancelled orders?
select * from orders;
SELECT 
	COUNT(CASE WHEN Order_delivered_customer_date IS NOT NULL THEN 1 END) AS orders_delivered_before_cancellation, 
	ROUND( 
		AVG( 
			DATEDIFF( 
				CASE WHEN Order_delivered_customer_date IS NOT NULL THEN Order_delivered_customer_date END,
                CASE WHEN order_purchase_timestamp IS NOT NULL THEN order_purchase_timestamp END)
			), 2
    )AS average_delivery_duration_of_canceled_orders_in_days 
FROM orders
WHERE order_status IN ('canceled', 'unavailable');	/* We had noticed that most of the orders are canceled before shipping. 
														There are only 6 orders that are shipped which are canceled. 
                                                        However there's no data of order cancellation date and reason, leading to 
                                                        missing information of order cancellation and returns */

-- 3. Top 10 cities with highest average delivery duration?
-- There are no delivery details directly associated with orders. Therefore took reference from customers table

SELECT 
	customer_city AS city, 
	AVG( 
		DATEDIFF(Order_delivered_customer_date, order_purchase_timestamp)
	) AS average_delivery_duration_by_city
FROM orders o 
LEFT JOIN customers c 
ON o.customer_id = c.customer_id
WHERE order_status = 'delivered'
GROUP BY customer_city
ORDER BY average_delivery_duration_by_city DESC
LIMIT 10;	/* Red flag for delivery duration. Identified greater than 65 day average delivery duration 
				which is a potential risk for repeated customers. A opportunity to scale services. */

-- 4. Total sales by city and average delivery duration. Order by delivery duration high to low.

SELECT 
	customer_city AS city, 
    ROUND( 
		SUM(payment_value), 
	2) AS total_sales, 
    AVG( 
		DATEDIFF(Order_delivered_customer_date, order_purchase_timestamp)
	) AS average_delivery_duration_by_city
FROM orders o 
LEFT JOIN order_payments p 
ON o.order_id = p.order_id
LEFT JOIN customers c 
ON o.customer_id = c.customer_id
GROUP BY city
ORDER BY average_delivery_duration_by_city DESC;	/* It is identified that cities with high delivery duration have same sales as
														cities with low delivery duration. A clear indication that improving logistic
                                                        services in high delivery duration cities can boost sales. */

-- 5. Percentage of orders delivered within promised time.
SELECT 
	ROUND(
		(
		COUNT(CASE WHEN reached_on_time = 'Yes' THEN 1 END) / COUNT(*)	) * 100, 
	2)AS rate_of_ontime_deliveries
FROM (
	SELECT 
		DATEDIFF(Order_delivered_customer_date, order_purchase_timestamp) AS delivery_duration,
		DATEDIFF(Order_estimated_delivery_date, order_purchase_timestamp) AS expected_delivery_duration, 
		CASE
			WHEN DATEDIFF(Order_delivered_customer_date, order_purchase_timestamp) > 
				DATEDIFF(Order_estimated_delivery_date, order_purchase_timestamp) 
			THEN 'No' 
			ELSE 'Yes' 
		END AS reached_on_time
	FROM orders
	WHERE Order_delivered_customer_date IS NOT NULL) AS temp_table;		-- 93.23% on time deliveries is a good KPI for customer trust.
    
-- 6. Revenue impact of late deliveries.

SELECT 
	ROUND(
		(SUM(CASE WHEN reached_on_time = 'No' THEN payment_value ELSE 0 END) / SUM(payment_value)) * 100, 
    2) AS rate_of_revenue_impact_on_late_deliveries
FROM (
SELECT 
	o.order_id, 
    SUM(p.payment_value) AS payment_value, 
    CASE
		WHEN DATEDIFF(Order_delivered_customer_date, order_purchase_timestamp) > 
			DATEDIFF(Order_estimated_delivery_date, order_purchase_timestamp) 
		THEN 'No' 
		ELSE 'Yes' 
	END AS reached_on_time
FROM orders o 
LEFT JOIN order_payments p 
ON o.order_id = p.order_id 
GROUP BY o.order_id) AS temp_table;		-- 7.2% impact on revenue due to delivery delays.

-- 7. Cities with high delivery duration and high cancellation rate.

SELECT 
	city, 
    AVG(delivery_duration) AS average_delivery_duration, 
    ROUND(
		(COUNT(CASE WHEN order_status = 'canceled' THEN 1 END) / COUNT(*)) * 100, 
    2) AS cancellation_rate
 FROM (
	SELECT 
		o.order_id,
		c.customer_city AS city, 
		DATEDIFF(o.Order_delivered_customer_date, o.order_purchase_timestamp) AS delivery_duration, 
		o.order_status
	FROM orders o 
	LEFT JOIN customers c 
	ON o.customer_id = c.customer_id
	WHERE o.order_status IN ('delivered', 'canceled')
    ) AS temp_table
GROUP BY city
HAVING average_delivery_duration > 7 AND cancellation_rate > 0
ORDER BY average_delivery_duration DESC, cancellation_rate DESC;	/* Cities with delivery duration greater than 50 
																		have no cancellations. delivery duration and 
                                                                        cancellation rate correlation is postivie but not strong
																	*/

-- 8. Average delivery duration per seller.
-- 9. Sellers contributing most to late deliveries. 
 
 
 