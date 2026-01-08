USE olist;

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
                                                                        cancellation rate correlation is weakly positive
																	*/

-- 8. Average delivery duration per seller.

SELECT 
	seller_id, 
    ROUND( 
		AVG(delivery_duration), 
	2) AS avg_delivery_duration 
FROM (
	SELECT 
		o.order_id,
		i.seller_id, 
		DATEDIFF(Order_delivered_customer_date, order_purchase_timestamp) AS delivery_duration 
	FROM orders o 
	LEFT JOIN order_items i 
	ON i.order_id = o.order_id
    ) AS temp_table
GROUP BY seller_id
ORDER BY avg_delivery_duration DESC;	/* Sellers with avg_delivery_duration greater than 7 days must be optimized
											for improving orders and customer ratings. Not all at once but at 
                                            different stages */

-- 9. Sellers contributing most to late deliveries. 
 
 SELECT 
	seller_id, 
    COUNT(*) AS total_deliveries_delayed
FROM (
	SELECT 
		o.order_id, 
		i.seller_id, 
		DATEDIFF(Order_estimated_delivery_date, order_purchase_timestamp) AS expected_delivery_duration, 
		DATEDIFF(Order_delivered_customer_date, order_purchase_timestamp) AS delivery_duration
	FROM orders o 
	LEFT JOIN order_items i 
	ON o.order_id = i.order_id
	WHERE DATEDIFF(Order_delivered_customer_date, order_purchase_timestamp) > DATEDIFF(Order_estimated_delivery_date, order_purchase_timestamp)
			AND order_status = 'delivered'
) AS temp_table
GROUP BY seller_id
ORDER BY total_deliveries_delayed DESC;		/* High delivery delays indicates
												1. Delayed seller response to received orders.
                                                2. Inconsistency in logistic services. 
											This can result in lower orders and loss of seller interest*/