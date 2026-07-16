/*
============================================================
Sales Analysis
Project : E-Commerce Sales & Customer Analytics

Objective:
Analyze sales performance, revenue trends, payment
behavior, and delivery performance to generate
business insights.
============================================================
*/


/* Total Revenue */
SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM order_payments;


/* Total Orders */
SELECT
    COUNT(*) AS total_orders
FROM orders;


/* Average Order Value */
SELECT
    ROUND(AVG(payment_value), 2) AS average_order_value
FROM order_payments;


/* Monthly Revenue Trend*/
SELECT
    DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS month,
    ROUND(SUM(op.payment_value),2) AS monthly_revenue
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY month
ORDER BY month;


/* Monthly Order Trend*/
SELECT
    DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;


/* Revenue by Order Status*/
SELECT
    o.order_status,
    ROUND(SUM(op.payment_value),2) AS revenue
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY o.order_status
ORDER BY revenue DESC;


/* Revenue by Payment Method*/
SELECT
    payment_type,
    ROUND(SUM(payment_value),2) AS total_revenue
FROM order_payments
GROUP BY payment_type
ORDER BY total_revenue DESC;


/* Average Payment Value by Payment Method */
SELECT
    payment_type,
    ROUND(AVG(payment_value),2) AS average_payment
FROM order_payments
GROUP BY payment_type
ORDER BY average_payment DESC;


/* Average Payment Value by Payment Method */
SELECT
    payment_type,
    ROUND(AVG(payment_value),2) AS average_payment
FROM order_payments
GROUP BY payment_type
ORDER BY average_payment DESC;


/* Top 10 Revenue Generating States */
SELECT
    c.customer_state,
    ROUND(SUM(op.payment_value),2) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;


/* Monthly Average Order Value*/
SELECT
    DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS month,
    ROUND(AVG(op.payment_value),2) AS average_order_value
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY month
ORDER BY month;


/* Frieght Cost Analysis */
SELECT
    ROUND(AVG(freight_value),2) AS average_freight_cost,
    ROUND(MAX(freight_value),2) AS highest_freight_cost,
    ROUND(MIN(freight_value),2) AS lowest_freight_cost
FROM order_items;


/* Revenue by Year */
SELECT
    YEAR(o.order_purchase_timestamp) AS year,
    ROUND(SUM(op.payment_value),2) AS total_revenue
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY year
ORDER BY year;


/* Top 10 Highest Value Orders */
SELECT
    op.order_id,
    ROUND(SUM(op.payment_value),2) AS total_order_value
FROM order_payments op
GROUP BY op.order_id
ORDER BY total_order_value DESC
LIMIT 10;


/* Delayed Delivery Analysis */
SELECT
    COUNT(*) AS delayed_orders
FROM orders
WHERE order_delivered_customer_date >
      order_estimated_delivery_date;


/* Percentage of Delayed Deliveries */
SELECT
    ROUND(
        (
            SUM(
                CASE
                    WHEN order_delivered_customer_date >
                         order_estimated_delivery_date
                    THEN 1
                    ELSE 0
                END
            ) * 100.0
        ) / COUNT(*),
        2
    ) AS delayed_delivery_percentage
FROM orders
WHERE order_status='delivered';


/*
============================================================
Business Insights
============================================================

1. The business generated a total revenue of approximately
   16 million across 99,441 orders, with an average order
   value of 154.10.

2. Revenue and order volume increased steadily throughout
   2017 and reached their highest levels during early 2018,
   indicating strong business growth.

3. Delivered orders contributed the vast majority of revenue,
   while cancelled and unavailable orders accounted for only
   a small portion of total sales.

4. Credit Card is the dominant payment method, generating
   the highest revenue and accounting for most transactions.

5. São Paulo (SP) is the highest revenue-generating state,
   highlighting it as the company's primary market.

6. Average freight cost is approximately 20, while the
   highest freight charge exceeds 400, showing significant
   variation in shipping costs.

7. Revenue increased significantly from 2016 to 2018,
   reflecting rapid expansion of the business.

8. The highest-value order exceeded 13,600, indicating the
   presence of premium or bulk purchases.

9. Around 8.11% of delivered orders were delivered later
   than the estimated delivery date, suggesting overall
   strong delivery performance with room for improvement.
*/