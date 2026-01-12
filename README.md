**Project Title:**
Revenue Leakage & Growth Opportunity Analysis

**Objective:**
The objective of this project is to identify and quantify revenue leakage and uncover scalable growth opportunities for Olist as an e-commerce enablement platform. Using transactional and operational data, the analysis evaluates key business drivers such as order cancellations, delivery performance, customer purchasing behavior, seller contribution, product quality, and revenue concentration.

The goal is to translate these insights into actionable recommendations that help improve sales performance, reduce preventable revenue loss, optimize seller and logistics operations, and highlight regions, customer segments, and service areas where Olist should prioritize expansion and investment.

**Tools Used:**
MySQL, SQL (CTEs, Joins, Aggregations), Power BI

**Dataset:**

*Orders*:
order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date

*Customers*:
customer_id, customer_unique_id, Customer_zip_code_prefix, Customer_city, Customer_state

*Order_items*:
Order_id, Item_id, Product_id, Seller_id, Shipping_limit_date, Price, Freight_value

*Order_payments*:
Order_id, Payment_sequential, Payment_type, Payment_installments, Payment_value

*Order_reviews*:
Review_id, Order_id, Review_score, review_creation_date, review_answer_timestamp

*Products*:
Product_id, Product_category_name, product_name_length, product_description_length, product_photos_qty, product_weight_g, 
product_length_cm, product_height_cm, product_width_cm

*Sellers*:
Seller_id, Seller_zip_code_prefix, Seller_city, Seller_state

*Product_category_name_translation*:
product_category_name, product_category_name_english

Dataset -  https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce 

**Executive Summary**
**Key Findings:**
1. 97% customers are one-time buyers -> Week customer retention.
2. Revenue loss dropped from 13.9% (2016) to 1.23% (2018) -> Indicating operations improvement.
3. Late deliveries impact ~7.2% of revenue -> Need logistics optimization and Seller SLA's.
4. Top 10 sellers contribute ~18% of revenue -> High concentration risk.
5. Cities with average delivery duration grater than 7 days need logistics optimization.

**Business Recommendations:**
1. Improve seller SLAs for late-delivery sellers.
2. Design retention programs to improve repeat customer rate (currently ~3%), such as loyalty incentives and faster delivery guarantees.
3. Improve logistics in high-delay cities.
4. Monitor low-rating, high-revenue products.

**Data Limitations:**
1. No cancellation reason or cancellation timestamp available.
2. Payment failures not explicitly tracked.
3. Missing Order records in Order_items and Order_payments tables may cause minor revenue discrepancies.

**SQL queries used for answering business questions**
**Revenue Lekage**

*Revenue lost*
1. What is the percentage of revenue loss due to cancelled orders per year.
2. What is the cancellation rate and total revenue lost per customer? order by cancellation rate high to low.
3. What is the average cancellation rate of sellers and total revenue lost per seller? order by cancellation rate high to low.
4. How many orders are cancelled and revenue lost due to payment failure.
5. Total cancellations by reason.
6. What is the average time for cancellation from order date to cancellation date?
7. Revenue lost by cancellations before shipment Vs after shipment.

*Delivery delay & geographical sales*
1. What is the average delivery duration of successfull orders?
2. What is the average delivery duration of cancelled orders?
3. Top 10 cities with highest average delivery duration?
4. Total sales by city and average delivery duration. Order by delivery duration high to low.
5. Percentage of orders delivered within promised time.
6. Revenue impact of late deliveries.
7. Cities with high delivery duration and high cancellation rate.
8. Average delivery duration per seller.
9. Sellers contributing most to late deliveries.

*Bad ratings*
1. What is the average rating for orders - delivered, cancelled by seller, cancelled by customer.
2. What is the average rating by seller?
3. What is the average rating by product?
4. Average rating by delivery time buckets. (0-3 days, 4-7 days)
5. Do sellers with more cancellations also have lower ratings?
6. Revenue from orders with below average rating.

**Growth opportunities**
1. What is the percentage of one time and repeating customers?
2. What are the top 10 high selling products with low rating?
3. What is the revenue made from each category over time?
4. What is the total revenue, average revenue per seller and top 10 sellers by revenue?
5. Total orders of customers by delivery duration.
6. First-time vs returning customer revenue.
7. Repeat rate by signup month.
8. Total revenue per customer.
9. Top 10 customers by revenue.
10. % of revenue from top 10 sellers.
11. Revenue distribution across sellers.

**Product performance metrics**
1. High revenue + low rating
2. Low revenue + high rating (hidden gems)


**PowerBI visuals for business analysis**

1. Revenue loss trend by year
2. Cancellation rate vs delivery time
3. Seller revenue concentration
4. One-time vs repeat customer revenue