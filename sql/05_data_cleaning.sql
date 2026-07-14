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



-- ======================================================
-- 2. MISSING VALUE ANALYSIS
-- ======================================================


SELECT
    SUM(customer_id IS NULL) AS customer_id_nulls,
    SUM(customer_unique_id IS NULL) AS customer_unique_id_nulls,
    SUM(customer_zip_code_prefix IS NULL) AS customer_zip_nulls,
    SUM(customer_city IS NULL) AS customer_city_nulls,
    SUM(customer_state IS NULL) AS customer_state_nulls
FROM customers;


SELECT
    SUM(order_id IS NULL) AS order_id_nulls,
    SUM(customer_id IS NULL) AS customer_id_nulls,
    SUM(order_status IS NULL) AS order_status_nulls,
    SUM(order_purchase_timestamp IS NULL) AS purchase_timestamp_nulls,
    SUM(order_approved_at IS NULL) AS approved_at_nulls,
    SUM(order_delivered_carrier_date IS NULL) AS delivered_carrier_nulls,
    SUM(order_delivered_customer_date IS NULL) AS delivered_customer_nulls,
    SUM(order_estimated_delivery_date IS NULL) AS estimated_delivery_nulls
FROM orders;


SELECT
    SUM(product_id IS NULL) AS product_id_nulls,
    SUM(product_category_name IS NULL) AS category_nulls,
    SUM(product_name_lenght IS NULL) AS name_length_nulls,
    SUM(product_description_lenght IS NULL) AS description_length_nulls,
    SUM(product_photos_qty IS NULL) AS photos_nulls,
    SUM(product_weight_g IS NULL) AS weight_nulls,
    SUM(product_length_cm IS NULL) AS length_nulls,
    SUM(product_height_cm IS NULL) AS height_nulls,
    SUM(product_width_cm IS NULL) AS width_nulls
FROM products;


SELECT
    SUM(review_id IS NULL) AS review_id_nulls,
    SUM(order_id IS NULL) AS order_id_nulls,
    SUM(review_score IS NULL) AS review_score_nulls,
    SUM(review_comment_title IS NULL) AS review_title_nulls,
    SUM(review_comment_message IS NULL) AS review_message_nulls,
    SUM(review_creation_date IS NULL) AS review_creation_nulls,
    SUM(review_answer_timestamp IS NULL) AS review_answer_nulls
FROM order_reviews;


/*
=========================================================
MISSING VALUE OBSERVATIONS

1. Orders
- order_approved_at: 160 NULLs
- order_delivered_carrier_date: 1,783 NULLs
- order_delivered_customer_date: 2,965 NULLs

Reason:
These correspond to cancelled, unavailable or undelivered orders.
No action required.

---------------------------------------------------------

2. Products

610 products have missing:
- product_category_name
- product_name_lenght
- product_description_lenght
- product_photos_qty

2 products have missing:
- product_weight_g
- product_length_cm
- product_height_cm
- product_width_cm

Reason:
Product metadata is unavailable for these products.
No imputation performed to preserve original data.

---------------------------------------------------------

3. Order Reviews

87,656 NULL review titles
58,247 NULL review messages

Reason:
Most customers submitted only a rating without writing a review.
These NULLs are expected.
No action required.

=========================================================
*/


SELECT *
FROM order_items
WHERE price < 0;


SELECT *
FROM order_items
WHERE freight_value < 0;

SELECT *
FROM order_payments
WHERE payment_value < 0;


SELECT DISTINCT review_score
FROM order_reviews
ORDER BY review_score;


SELECT *
FROM order_payments
WHERE payment_installments < 0;


SELECT *
FROM products
WHERE product_weight_g < 0;


SELECT *
FROM products
WHERE product_length_cm < 0
   OR product_height_cm < 0
   OR product_width_cm < 0;


-- ======================================================
-- 4. DATE VALIDATION
-- ======================================================


SELECT *
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;


SELECT *
FROM orders
WHERE order_approved_at < order_purchase_timestamp;


SELECT *
FROM orders
WHERE order_delivered_carrier_date < order_approved_at;


SELECT *
FROM orders
WHERE order_delivered_customer_date < order_delivered_carrier_date;


SELECT COUNT(*) AS delayed_orders
FROM orders
WHERE order_delivered_customer_date > order_estimated_delivery_date;


SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


SELECT COUNT(*)
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    TIMESTAMPDIFF(
        MINUTE,
        order_delivered_carrier_date,
        order_approved_at
    ) AS difference_minutes
FROM orders
WHERE order_delivered_carrier_date < order_approved_at
ORDER BY difference_minutes DESC;


SELECT
    order_id,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    TIMESTAMPDIFF(
        MINUTE,
        order_delivered_customer_date,
        order_delivered_carrier_date
    ) AS difference_minutes
FROM orders
WHERE order_delivered_customer_date < order_delivered_carrier_date
ORDER BY difference_minutes DESC;


/*
=========================================================
DATE VALIDATION OBSERVATIONS

✓ No orders delivered before purchase.

✓ No orders approved before purchase.

⚠ 1,359 orders have carrier pickup timestamps earlier
than approval timestamps.

⚠ 23 orders have customer delivery timestamps earlier
than carrier pickup timestamps.

These are timestamp inconsistencies in the source dataset.
The original data has been preserved.

7,827 orders were delivered after the estimated delivery date.

=========================================================
*/


SELECT COUNT(*) AS missing_customers
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


SELECT COUNT(*) AS missing_orders
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


SELECT COUNT(*) AS missing_products
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


SELECT COUNT(*) AS missing_sellers
FROM order_items oi
LEFT JOIN sellers s
ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;


SELECT COUNT(*) AS missing_payment_orders
FROM order_payments op
LEFT JOIN orders o
ON op.order_id = o.order_id
WHERE o.order_id IS NULL;


SELECT COUNT(*) AS missing_review_orders
FROM order_reviews r
LEFT JOIN orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


/*
=========================================================
DATA QUALITY SUMMARY

Duplicate Checks
✓ No duplicate primary keys found in Customers
✓ No duplicate primary keys found in Orders
✓ No duplicate primary keys found in Order Items
✓ No duplicate primary keys found in Products
✓ No duplicate primary keys found in Sellers
✓ No duplicate primary keys found in Payments
✓ Geolocation contains expected duplicate locations
✓ Product Category Translation contains no duplicates

Missing Values
✓ Customers table contains no missing values.
✓ Orders table contains expected NULLs for cancelled/
  unavailable orders.
✓ Products table contains missing product metadata.
✓ Review comments contain expected NULL values.

Data Validation
✓ No negative prices.
✓ No negative freight charges.
✓ No negative payment values.
✓ Review scores contain only valid values (1–5).
✓ Product dimensions are valid.

Date Validation
✓ No order delivered before purchase.
✓ No order approved before purchase.
⚠ 1,359 timestamp inconsistencies between approval
  and carrier pickup.
⚠ 23 timestamp inconsistencies between carrier pickup
  and customer delivery.
✓ 7,827 delayed deliveries identified.

Referential Integrity
✓ Orders → Customers
✓ Order Items → Orders
✓ Order Items → Products
✓ Order Items → Sellers
✓ Payments → Orders
✓ Reviews → Orders

Overall Conclusion

The dataset is suitable for analysis.
Expected missing values and a few timestamp anomalies
were identified and documented. No modifications were
made to preserve the integrity of the original dataset.
=========================================================
*/