/*
============================================================
Business Insight 1
Top 10 Most Valuable Customers
============================================================
*/

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
ORDER BY lifetime_value DESC
LIMIT 10;


/*
============================================================
Business Insight 2
Top Revenue Generating Sellers
============================================================
*/

SELECT
    s.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(op.payment_value),2) AS total_revenue
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
JOIN order_payments op
    ON oi.order_id = op.order_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10;




/*
============================================================
Business Insight 3
Highest Revenue Product Categories
============================================================
*/

SELECT
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS orders,
    ROUND(SUM(op.payment_value),2) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN order_payments op
    ON oi.order_id = op.order_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;




/*
============================================================
Business Insight 4
Highest Average Order Value by State
============================================================
*/

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(op.payment_value),2) AS average_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY c.customer_state
HAVING COUNT(DISTINCT o.order_id) >= 100
ORDER BY average_order_value DESC;


/*
============================================================
Business Insight 5
Customer Repeat Purchase Rate
============================================================
*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN total_orders > 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    ROUND(
        SUM(
            CASE
                WHEN total_orders > 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS repeat_purchase_rate
FROM customer_orders;



/*
============================================================
Business Insight 6
Revenue Contribution by Customer Segment
============================================================
*/

WITH customer_rfm AS
(
    SELECT
        c.customer_unique_id,

        DATEDIFF(
            '2018-10-17',
            DATE(MAX(o.order_purchase_timestamp))
        ) AS recency,

        COUNT(DISTINCT o.order_id) AS frequency,

        ROUND(SUM(op.payment_value),2) AS monetary

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_payments op
        ON o.order_id = op.order_id

    GROUP BY c.customer_unique_id
),

rfm_scores AS
(
    SELECT
        customer_unique_id,
        monetary,

        6 - NTILE(5) OVER(ORDER BY recency ASC) AS r_score,

        NTILE(5) OVER(ORDER BY frequency ASC) AS f_score,

        NTILE(5) OVER(ORDER BY monetary ASC) AS m_score

    FROM customer_rfm
)

SELECT

    CASE

        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
            THEN 'Champions'

        WHEN r_score >= 4 AND f_score >= 3
            THEN 'Loyal Customers'

        WHEN r_score >= 4 AND f_score <= 2
            THEN 'Potential Loyalists'

        WHEN r_score BETWEEN 2 AND 3 AND f_score >= 3
            THEN 'Need Attention'

        WHEN r_score <= 2 AND f_score <= 2
            THEN 'At Risk'

        ELSE 'Others'

    END AS customer_segment,

    COUNT(*) AS customers,

    ROUND(SUM(monetary),2) AS total_revenue

FROM rfm_scores

GROUP BY customer_segment

ORDER BY total_revenue DESC;




/*
============================================================
Business Insight 7
Monthly Revenue Growth
============================================================
*/

WITH monthly_sales AS
(
    SELECT

        DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS month,

        ROUND(SUM(op.payment_value),2) AS revenue

    FROM orders o

    JOIN order_payments op
        ON o.order_id = op.order_id

    GROUP BY month
)

SELECT

    month,

    revenue,

    LAG(revenue) OVER(ORDER BY month) AS previous_month,

    ROUND(
        (
            (revenue -
             LAG(revenue) OVER(ORDER BY month))
            /
             LAG(revenue) OVER(ORDER BY month)
        ) * 100,
        2
    ) AS growth_percentage

FROM monthly_sales;



/*
============================================================
Business Insight 8
Delayed Delivery Percentage by State
============================================================
*/

SELECT

    c.customer_state,

    COUNT(*) AS delivered_orders,

    SUM(
        CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS delayed_orders,

    ROUND(
        SUM(
            CASE
                WHEN o.order_delivered_customer_date >
                     o.order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS delayed_percentage

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

WHERE o.order_status='delivered'

GROUP BY c.customer_state

HAVING COUNT(*) >= 100

ORDER BY delayed_percentage DESC;



/*
============================================================
Business Insight 9
Highest Freight Cost Ratio by Category
============================================================
*/

SELECT

    p.product_category_name,

    ROUND(AVG(oi.price),2) AS average_price,

    ROUND(AVG(oi.freight_value),2) AS average_freight,

    ROUND(
        AVG(oi.freight_value) /
        AVG(oi.price) * 100,
        2
    ) AS freight_percentage

FROM products p

JOIN order_items oi
    ON p.product_id = oi.product_id

GROUP BY p.product_category_name

HAVING COUNT(*) >= 100

ORDER BY freight_percentage DESC

LIMIT 10;



/*
============================================================
Business Insight 10
Payment Method Performance
============================================================
*/

SELECT

    payment_type,

    COUNT(*) AS total_transactions,

    ROUND(SUM(payment_value),2) AS total_revenue,

    ROUND(AVG(payment_value),2) AS average_payment

FROM order_payments

GROUP BY payment_type

ORDER BY total_revenue DESC;