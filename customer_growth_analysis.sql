USE olist;

-- 1. What is the average rating for orders - delivered, cancelled by seller, cancelled by customer.

SELECT 
	ROUND( 
		AVG(CASE WHEN order_status = 'delivered' THEN review_score END), 2
	) AS rating_delivered, 
    ROUND( 
		AVG(CASE WHEN order_status = 'unavailable' THEN review_score END), 2
	)AS rating_unavailable, 
    ROUND( 
		AVG(CASE WHEN order_status = 'canceled' THEN review_score END), 2
	)AS rating_canceled 
FROM orders o 
INNER JOIN order_reviews r 
ON o.order_id = r.order_id;		/* The average rating of delivered orders is 4.16, while 
									rating of canceled orders is 1.81 and unavailable is 1.53. 
                                    This indicates that the customer satisfaction is high when
                                    a order is delivered. */

-- 2. What is the average rating by seller?

SELECT 
	seller_id, 
    AVG(review_score) AS rating
FROM order_items i 
LEFT JOIN order_reviews r 
ON i.order_id = r.order_id
GROUP BY seller_id
ORDER BY rating ASC;	/* sellers with average rating below 3.5 should be reviewed for 
							delayed deliveries and product unavailability. Such sellers 
                            might contribute to revenue leakage. */

-- 3. What is the average rating by product? 

SELECT 
	product_id, 
	AVG(review_score) AS rating
FROM order_items i
LEFT JOIN order_reviews r
ON i.order_id = r.order_id 
GROUP BY product_id
ORDER BY rating;		/* Products with average rating below 3.5 might lead to revenue leakage. 
							Sellers with such products must be informed to improve average product rating. */

-- 4. Average rating by delivery time buckets. (1-3 days, 4-7 days)

WITH order_delivery_duration AS (
	SELECT 
		order_id, 
        DATEDIFF(Order_delivered_customer_date, order_purchase_timestamp) AS delivery_duration
	FROM orders 
), 
order_bucket AS (
	SELECT 
		order_id, 
        CASE 
			WHEN delivery_duration <= 3 THEN '1 - 3' 
            WHEN delivery_duration <= 7 THEN '4 - 7'
            ELSE '> 8'
		END AS delivery_bucket
	FROM order_delivery_duration
) 
SELECT 
	delivery_bucket, 
    ROUND( 
		AVG(review_score), 2
    )AS avg_rating
FROM order_bucket b
LEFT JOIN order_reviews r 
ON b.order_id = r.order_id
GROUP BY delivery_bucket;		/* orders delivered in 1-3 days have higher rating of 4.46, 
									4-7 days have rating of 4.4
                                    >8 days have rating of 3.94 */

-- 5. Do sellers with more cancellations also have lower ratings?

WITH temp_table AS (
	SELECT 
		i.order_id, 
		seller_id, 
		order_status, 
		review_score
	FROM order_items i 
	LEFT JOIN orders o 
	ON i.order_id = o.order_id 
	INNER JOIN order_reviews r 
	ON i.order_id = r.order_id
), 
seller_cancellations AS (
	SELECT 
		seller_id, 
		COUNT(*) AS total_cancellations
	FROM temp_table
    WHERE order_status IN ('canceled', 'unavailable')
	GROUP BY seller_id
), 
seller_rating AS (
	SELECT 
		seller_id, 
		AVG(review_score) AS avg_rating
	FROM temp_table
	GROUP BY seller_id
) 
SELECT 
	c.seller_id, 
    total_cancellations, 
    avg_rating
FROM seller_cancellations c 
INNER JOIN seller_rating r 
ON c.seller_id = r.seller_id
ORDER BY total_cancellations DESC;		/* Yes, sellers with high cancellations have high average rating */

-- 6. Revenue from orders with below average rating.

WITH orders_rating_revenue AS (
	SELECT 
		o.order_id, 
		SUM(payment_value) AS payment_value,
		AVG(review_score) AS rating
	FROM orders o 
	LEFT JOIN order_payments p 
	ON o.order_id = p.order_id
	LEFT JOIN order_reviews r 
	ON o.order_id = r.order_id
	GROUP BY o.order_id
)
SELECT 
	ROUND(
		SUM(payment_value), 2
	) AS revenue_from_orders_with_below_avg_rating
FROM orders_rating_revenue
WHERE rating < ( SELECT 
					AVG(rating) 
				FROM orders_rating_revenue
                )
;			/* revenue from orders below average rating is 69,79,042.53(43%), while total revenue is 1,60,08,872.12. */
 
 
-- **Growth opportunities**
-- 1. What is the percentage of one time and repeating customers?

WITH customer_orders AS (
	SELECT 
	customer_unique_id, 
	COUNT(*) AS total_orders
	FROM (
		SELECT 
			o.order_id, 
			c.customer_id, 
			c.customer_unique_id 
		FROM orders o 
		LEFT JOIN customers c 
		ON o.customer_id = c.customer_id
		) AS temp_table
	GROUP BY customer_unique_id
) 
SELECT 
	ROUND(
		COUNT(CASE WHEN total_orders = 1 THEN 1 END) / (COUNT(*)) * 100
    , 2) AS percentage_of_one_time_customers
FROM customer_orders;		/* 96.88% of the customers are one time buyers.
								100-96.88 = 3.12% are repeating. 
                                This indicates that the customer repeat rate is very low. A survey 
                                with repeating & one time customers would help business to understand the 
                                needs of the customers.*/

-- 2. What are the top 10 high selling products with low rating?

SELECT 
	product_id, 
    COUNT(*) AS total_orders, 
    AVG(review_score) AS avg_rating 
FROM (
	SELECT 
		i.order_id, 
		i.product_id, 
		r.review_score 
	FROM order_items i 
	RIGHT JOIN order_reviews r 
	ON r.order_id = i.order_id
    ) AS temp_table
GROUP BY product_id
ORDER BY avg_rating, total_orders DESC
LIMIT 10;		/* We have top 10 selling products with low rating */

-- 3. What is the revenue made from each category over time?

SELECT 
	product_category_name_english, 
    ROUND(SUM(price), 2) AS revenue_generated_over_time 
FROM (
	SELECT 
		i.order_id, 
		i.product_id,  
		ROUND(Price + Freight_value, 2) AS price, 
		p.product_category_name
	FROM order_items i 
	LEFT JOIN products p 
	ON i.product_id = p.product_id) AS m
INNER JOIN product_category_name_translation t 
ON t.product_category_name = m.product_category_name
GROUP BY t.product_category_name
ORDER BY revenue_generated_over_time DESC;		/* health_beauty category has generated the highest revenue over time followed
													by watches_gifts, bed_bath_table, etc., */

-- 4. What is the total revenue, average revenue per seller and top 10 sellers by revenue?

SELECT 
	seller_id, 
    ROUND(
		SUM(price + freight_value)
    , 2) AS revenue, 
    ROUND(
		AVG(price + freight_value)
    , 2) AS average_revenue
FROM order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;		/* We have top 10 sellers by revenue and average sales as average_revenue */

-- 5. Total orders of customers by delivery duration. 

SELECT 
	customer_unique_id, 
    delivery_duration, 
    COUNT(*) AS total_orders
FROM (
	SELECT 
		customer_id, 
		DATEDIFF(Order_delivered_customer_date, order_purchase_timestamp) AS delivery_duration
	FROM orders
	WHERE order_status = 'delivered'
    ) AS t 
LEFT JOIN customers c 
ON t.customer_id = c.customer_id
GROUP BY customer_unique_id, delivery_duration
ORDER BY customer_unique_id;			/* Since most of the customers are one time buyers, 
											this query is not supportive for analysis */

-- 6. First-time vs returning customer revenue.

WITH customer_orders AS (
	SELECT 
		o.order_id, 
		SUM(p.payment_value) AS price, 
		o.customer_id, 
		c.customer_unique_id 
	FROM orders o 
	RIGHT JOIN order_payments p 
	ON o.order_id = p.order_id
	LEFT JOIN customers c 
	ON o.customer_id = c.customer_id 
	GROUP BY o.order_id
), 
customer_revenue AS (
	SELECT 
		customer_unique_id, 
        COUNT(*) AS total_orders, 
        SUM(price) AS revenue
	FROM customer_orders
    GROUP BY customer_unique_id
)
SELECT 
	ROUND( 
		SUM(CASE WHEN total_orders = 1 THEN revenue END) 
	, 2) AS one_time_customers_revenue, 
    ROUND( 
		SUM(CASE WHEN total_orders != 1 THEN revenue END) 
	, 2) AS repeating_customers_revenue 
FROM customer_revenue;		/* one time customers revenue = 15064849.41. 
								repeating customers revenue = 944022.71*/

-- 7. Repeat rate by signup month. 

WITH customer_orders AS (
	SELECT 
		customer_unique_id, 
		COUNT(order_id) AS total_orders, 
		MIN(order_purchase_timestamp) AS first_order_date 
	FROM orders o 
	LEFT JOIN customers c 
	ON o.customer_id = c.customer_id
	WHERE order_status = 'delivered'
	GROUP BY customer_unique_id
) 
SELECT 
	DATE_FORMAT(first_order_date, '%Y-%m') AS signup_month, 
    COUNT(*) AS total_customers, 
    COUNT(CASE WHEN total_orders > 1 THEN 1 END) AS repeat_customers, 
    ROUND(
		(COUNT(CASE WHEN total_orders > 1 THEN 1 END) / COUNT(*) ) * 100
    , 2) AS repeat_rate 
FROM customer_orders
GROUP BY signup_month
ORDER BY signup_month;		/* Highest repeat rate is just 7.25% in 2017 January */
    
-- 8. Total revenue per customer.

SELECT 
	customer_unique_id, 
    ROUND( 
		SUM(payment_value), 
	2)AS total_revenue_generated 
FROM orders o 
LEFT JOIN order_payments p 
ON o.order_id = p.order_id 
LEFT JOIN customers c 
ON o.customer_id = c.customer_id
GROUP BY customer_unique_id
ORDER BY total_revenue_generated DESC;	/* Highest revenue generated by a customer is 1364.08 */

-- 9. Top 10 customers by revenue.

SELECT 
	customer_unique_id, 
    ROUND( 
		SUM(payment_value), 
	2)AS total_revenue_generated 
FROM orders o 
LEFT JOIN order_payments p 
ON o.order_id = p.order_id 
LEFT JOIN customers c 
ON o.customer_id = c.customer_id
GROUP BY customer_unique_id
ORDER BY total_revenue_generated DESC
LIMIT 10;		/* Sum of revenue generated by top 10 customers is 74297.11. 
					This indicating less customer concentration risk. */

-- 10. % of revenue from top 10 sellers.

-- Identified data errors. revenue from order_payments table is not matching with order_items. showing the proof 

SELECT 
	(SELECT SUM(payment_value) FROM order_payments) AS revenue_from_order_payments, 
	(SELECT SUM(price + freight_value) FROM order_items) AS revenue_from_order_items, 
    ((SELECT SUM(payment_value) FROM order_payments) - (SELECT SUM(price + freight_value) FROM order_items)) AS difference;
		/* what causing this difference of 165318.88 */
        
SELECT COUNT(*) FROM orders 
WHERE order_id NOT IN (SELECT order_id FROM order_payments);	/* one order_id in orders table - bfbd0f9bdef84302105ad712db648a6c
																	is not found in order_payments*/

SELECT COUNT(*) FROM orders 
WHERE order_id NOT IN (SELECT order_id FROM order_items);		/* 775 orders found missing in order_items table */

/* This missing data in order_payments & order_items might lead to data inaccuracy. 
	Since only 1 value is missing from order_payments and almost all the revenue calculations are made from order_payments table 
    the room for error can be identified where freight_value, price are used*/

SELECT 
	ROUND( 
		(SUM(total_generated_revenue) / (SELECT SUM(payment_value) FROM order_payments)) 
		* 100, 2
        ) AS percentage_of_revenue_from_top_10_sellers FROM (  
SELECT 
	seller_id, 
    SUM(payment_value) AS total_generated_revenue 
FROM orders o 
LEFT JOIN order_items i 
ON o.order_id = i.order_id 
LEFT JOIN order_payments p 
ON o.order_id = p.order_id 
GROUP BY seller_id
ORDER BY total_generated_revenue DESC
LIMIT 10) AS t;		/* 17.84% of the total revenue generated is from top 10 sellers.
						This indicating high dependance and seller concentration risk. */

-- 11. Revenue distribution across sellers.
 
SELECT 
	seller_id, 
    ROUND(SUM(price + freight_value) / (SELECT SUM(payment_value) FROM order_payments) * 100, 2) AS seller_revenue_distribution
FROM order_items
GROUP BY seller_id
ORDER BY seller_revenue_distribution DESC;		/* We have seller revenue distribution. (except errors here as data used
													from order_items where most of the orders found missing from order_payments) */
                                                    
-- 12. High revenue + low rating 

SELECT 
	product_id, 
    COUNT(o.order_id) AS total_orders, 
    ROUND(SUM(freight_value + price), 2) AS revenue_generated, 
    ROUND(AVG(review_score), 2) AS average_rating
FROM order_items o 
LEFT JOIN order_reviews r 
ON o.order_id = r.order_id
WHERE review_score IS NOT NULL
GROUP BY product_id
ORDER BY average_rating, revenue_generated DESC;	/* Here we have low rated and high revenue generated product_id's */

-- 13. Low revenue + high rating (hidden gems)

SELECT 
	product_id, 
    COUNT(o.order_id) AS total_orders, 
    ROUND(SUM(freight_value + price), 2) AS revenue_generated, 
    ROUND(AVG(review_score), 2) AS average_rating
FROM order_items o 
LEFT JOIN order_reviews r 
ON o.order_id = r.order_id
WHERE review_score IS NOT NULL
GROUP BY product_id
ORDER BY average_rating DESC, revenue_generated ASC;	/* Here we have high rated and low revenue generated product_id's */		