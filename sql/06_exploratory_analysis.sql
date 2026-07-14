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