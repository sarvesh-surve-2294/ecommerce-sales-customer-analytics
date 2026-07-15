/*
============================================================
Exploratory Data Analysis (EDA)
Project : E-Commerce Sales & Customer Analytics

Objective:
Understand the dataset by exploring customer,
orders, products, sellers and payments before
performing detailed business analysis.
============================================================
*/


SHOW TABLES;

SELECT COUNT(*) AS total_customers
FROM customers;


SELECT COUNT(*) AS total_orders
FROM orders;


SELECT COUNT(*) AS total_products
FROM products;


SELECT COUNT(*) AS total_sellers
FROM sellers;


SELECT COUNT(*) AS total_reviews
FROM order_reviews;


SELECT COUNT(*) AS total_payments
FROM order_payments;


/* Order Status Distribution */
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


/* Time Period */
SELECT
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order
FROM orders;


/* Customer Distribution by State */
SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;


/* Seller Distribution by State */
SELECT
    seller_state,
    COUNT(*) AS total_sellers
FROM sellers
GROUP BY seller_state
ORDER BY total_sellers DESC;


/* Paymment Methods */
SELECT
    payment_type,
    COUNT(*) AS total_payments
FROM order_payments
GROUP BY payment_type
ORDER BY total_payments DESC;


/* Review Score Distribution*/
SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;


/* Top product Categories*/
SELECT
    product_category_name,
    COUNT(*) AS total_products
FROM products
GROUP BY product_category_name
ORDER BY total_products DESC
LIMIT 10;


/* Average order values*/
SELECT
    ROUND(AVG(payment_value),2) AS average_order_value
FROM order_payments;


/* Total Revenue*/
SELECT
    ROUND(SUM(payment_value),2) AS total_revenue
FROM order_payments;


/* Average Review Score*/
SELECT
    ROUND(AVG(review_score),2) AS average_review_score
FROM order_reviews;


/*
=========================================================
EDA SUMMARY

• The dataset contains nearly 100,000 orders placed
  between September 2016 and October 2018.

• More than 96% of all orders were successfully
  delivered.

• São Paulo (SP) has the highest concentration of both
  customers and sellers.

• Credit cards are the dominant payment method,
  accounting for the majority of transactions.

• The average order value is 154.10 BRL.

• Total revenue recorded is 1.60 million BRL.

• Customers generally report positive experiences,
  with an average review score of 4.09 out of 5.

• The largest product category is Bed, Bath & Table
  (cama_mesa_banho).

These findings provide an overview of the marketplace
and serve as a foundation for detailed sales,
customer and product analysis.
=========================================================
*/