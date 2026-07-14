-- ======================================================
-- DATA CLEANING & VALIDATION
-- E-Commerce Sales & Customer Analytics
-- ======================================================

USE ecommerce_sales;

-- ======================================================
-- 1. CHECK FOR DUPLICATE PRIMARY KEYS
-- ======================================================

-- Customers
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Orders

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;


SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


SELECT
    seller_id,
    COUNT(*) AS duplicate_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


SELECT
    review_id,
    COUNT(*) AS duplicate_count
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;


SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS duplicate_count
FROM order_payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;


SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    COUNT(*) AS duplicate_count
FROM geolocation
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng
HAVING COUNT(*) > 1;


SELECT
    product_category_name,
    COUNT(*) AS duplicate_count
FROM product_category_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;


