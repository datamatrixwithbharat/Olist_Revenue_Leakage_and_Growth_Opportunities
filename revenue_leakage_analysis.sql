USE olist;

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