/*
============================================================
Customer Analysis
Project : E-Commerce Sales & Customer Analytics

Objective:
Analyze customer demographics, purchasing behavior,
customer value, retention, and spending patterns.
============================================================
*/


/* Total Unique Customers */

SELECT
    COUNT(DISTINCT customer_unique_id) AS total_unique_customers
FROM customers;



/* Customers by State */

SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;



/* Top 10 Cities */

SELECT
    customer_city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 10;



/* Average Orders per Customer */

SELECT
    ROUND(
        COUNT(o.order_id) * 1.0 /
        COUNT(DISTINCT c.customer_unique_id),
        2
    ) AS average_orders_per_customer
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;



/* Repeat vs One-Time Customers */

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM customer_orders
GROUP BY customer_type;



/* Top 10 Highest Spending Customers */

SELECT
    c.customer_unique_id,
    ROUND(SUM(op.payment_value),2) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;



/* Customer Lifetime Value */

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(op.payment_value),2) AS lifetime_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY c.customer_unique_id
ORDER BY lifetime_value DESC;



/* Monthly New Customers */

SELECT
    DATE_FORMAT(first_purchase,'%Y-%m') AS month,
    COUNT(*) AS new_customers
FROM
(
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_purchase
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) t
GROUP BY month
ORDER BY month;



/* Revenue by Customer State */

SELECT
    c.customer_state,
    ROUND(SUM(op.payment_value),2) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;



/* Payment Preference */

SELECT
    payment_type,
    COUNT(*) AS total_payments
FROM order_payments
GROUP BY payment_type
ORDER BY total_payments DESC;



/* Average Review Score by State */

SELECT
    c.customer_state,
    ROUND(AVG(r.review_score),2) AS average_review
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_reviews r
ON o.order_id = r.order_id
GROUP BY c.customer_state
ORDER BY average_review DESC;



/* Top Customers using RANK() */

WITH customer_value AS
(
    SELECT
        c.customer_unique_id,
        ROUND(SUM(op.payment_value),2) AS lifetime_value
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    lifetime_value,
    RANK() OVER(
        ORDER BY lifetime_value DESC
    ) AS customer_rank
FROM customer_value
LIMIT 20;



/* Customer Segmentation */

WITH customer_value AS
(
    SELECT
        c.customer_unique_id,
        SUM(op.payment_value) AS lifetime_value
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY c.customer_unique_id
)

SELECT
    CASE
        WHEN lifetime_value >= 1000 THEN 'High Value'
        WHEN lifetime_value >= 300 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) AS total_customers
FROM customer_value
GROUP BY customer_segment;


/*
============================================================
Business Insights
============================================================

1. The marketplace serves 96,096 unique customers,
   demonstrating a large and diverse customer base.

2. Customer distribution is highly concentrated in the
   southeastern region of Brazil, with São Paulo (SP)
   having the largest customer base.

3. São Paulo city is the leading customer market,
   followed by Rio de Janeiro and Belo Horizonte.

4. Customers place an average of only 1.03 orders,
   indicating low repeat purchase behavior.

5. Approximately 97% of customers are one-time buyers,
   while only 3% return for additional purchases,
   highlighting an opportunity to improve retention.

6. A small group of customers generates exceptionally
   high lifetime value, making them ideal candidates
   for loyalty and retention programs.

7. Customer acquisition grew consistently throughout
   2017 and early 2018, reflecting rapid expansion of
   the customer base.

8. São Paulo contributes the highest customer revenue,
   followed by Rio de Janeiro and Minas Gerais.

9. Customer satisfaction remains consistently high
   across most states, with average review scores
   close to 4 out of 5.

10. Most customers belong to the Low Value segment,
    while only a small percentage are classified as
    High Value customers, emphasizing the importance
    of customer retention and upselling strategies.
*/