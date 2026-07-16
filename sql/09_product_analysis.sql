/*
============================================================
Product Analysis
Project : E-Commerce Sales & Customer Analytics

Objective:
Analyze product performance, categories, seller performance,
pricing, freight costs, and customer satisfaction
to identify the best and worst performing products.
============================================================
*/


/* Total Products */

SELECT
    COUNT(*) AS total_products
FROM products;



/* Total Product Categories */

SELECT
    COUNT(DISTINCT product_category_name) AS total_categories
FROM products;



/* Top 10 Product Categories */

SELECT
    product_category_name,
    COUNT(*) AS total_products
FROM products
GROUP BY product_category_name
ORDER BY total_products DESC
LIMIT 10;



/* Top 10 Best Selling Categories */

SELECT
    p.product_category_name,
    COUNT(oi.order_item_id) AS total_items_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_items_sold DESC
LIMIT 10;



/* Revenue by Product Category */

SELECT
    p.product_category_name,
    ROUND(SUM(op.payment_value),2) AS total_revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
JOIN order_payments op
ON oi.order_id = op.order_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;



/* Average Product Price by Category */

SELECT
    p.product_category_name,
    ROUND(AVG(oi.price),2) AS average_price
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY average_price DESC
LIMIT 10;



/* Average Freight Cost by Category */

SELECT
    p.product_category_name,
    ROUND(AVG(oi.freight_value),2) AS average_freight
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY average_freight DESC
LIMIT 10;



/* Top Sellers by Revenue */

SELECT
    s.seller_id,
    s.seller_state,
    ROUND(SUM(op.payment_value), 2) AS total_revenue
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
JOIN order_payments op
    ON oi.order_id = op.order_id
GROUP BY
    s.seller_id,
    s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;



/* Top Sellers by Orders */

SELECT
    s.seller_id,
    s.seller_state,
    COUNT(*) AS total_orders
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY
    s.seller_id,
    s.seller_state
ORDER BY total_orders DESC
LIMIT 10;



/* Sellers by State */

SELECT
    seller_state,
    COUNT(*) AS total_sellers
FROM sellers
GROUP BY seller_state
ORDER BY total_sellers DESC;



/* Highest Rated Product Categories */

SELECT
    p.product_category_name,
    ROUND(AVG(r.review_score), 2) AS average_review
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN order_reviews r
    ON oi.order_id = r.order_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(*) >= 50
ORDER BY average_review DESC
LIMIT 10;



/* Lowest Rated Product Categories */

SELECT
    p.product_category_name,
    ROUND(AVG(r.review_score), 2) AS average_review
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN order_reviews r
    ON oi.order_id = r.order_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(*) >= 50
ORDER BY average_review ASC
LIMIT 10;



/* Product Weight */

SELECT
    ROUND(AVG(product_weight_g),2) AS average_weight,
    MAX(product_weight_g) AS highest_weight,
    MIN(product_weight_g) AS lowest_weight
FROM products;



/* Product Dimensions */

SELECT
    ROUND(AVG(product_length_cm),2) AS avg_length,
    ROUND(AVG(product_height_cm),2) AS avg_height,
    ROUND(AVG(product_width_cm),2) AS avg_width
FROM products;



/* Top Products using RANK() */

WITH product_sales AS
(
    SELECT
        oi.product_id,
        ROUND(SUM(op.payment_value),2) AS revenue
    FROM order_items oi
    JOIN order_payments op
    ON oi.order_id = op.order_id
    GROUP BY oi.product_id
)

SELECT
    product_id,
    revenue,
    RANK() OVER(
        ORDER BY revenue DESC
    ) AS product_rank
FROM product_sales
LIMIT 20;


/*
============================================================
Business Insights
============================================================

1. The marketplace offers 32,951 products across
   73 product categories, reflecting a diverse
   product portfolio.

2. Bed, Bath & Table is the largest product category
   and also the best-selling category by units sold.

3. Home, Lifestyle, Beauty, and Sports categories
   consistently rank among the strongest performers
   in both sales volume and revenue.

4. Premium categories such as PCs and Electronics
   command the highest average selling prices despite
   lower sales volumes.

5. Heavy furniture-related categories incur the
   highest freight costs, indicating increased
   logistics expenses for bulky products.

6. Revenue is concentrated among a relatively small
   number of high-performing sellers, with the
   highest seller generating over 500,000 in revenue.

7. Most sellers are located in São Paulo, making it
   the primary supply hub for the marketplace.

8. Product review scores are generally positive,
   with several categories averaging above 4.3,
   indicating strong customer satisfaction.

9. The average product weighs approximately 2.3 kg,
   although a few products exceed 40 kg, creating
   significant shipping cost variation.

10. A small number of products contribute a large
    share of total revenue, demonstrating the
    importance of maintaining inventory for
    high-performing products.
*/