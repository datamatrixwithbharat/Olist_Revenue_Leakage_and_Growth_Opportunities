# Olist_Revenue_Leakage_and_Growth_Opportunities
Analysis of revenue leakage and growth opportunities of Olist with data from 2016 to 2018 using MySQL and PowerBI

dataset from kaggle: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

SQL questions - Revenue lekage ang growth opportunities

This project analyzes revenue leakage and growth opportunities for olist.com a e-commerce enabler platform, using SQL. The analysis focuses on cancellations, delivery performance, customer behavior, seller performance, product quality, and revenue concentration to identify operational inefficiencies and areas for growth.

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

*Product performance metrics*
1. High revenue + low rating
2. Low revenue + high rating (hidden gems)