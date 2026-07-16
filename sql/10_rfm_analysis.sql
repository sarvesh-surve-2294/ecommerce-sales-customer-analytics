/*
============================================================
RFM Analysis
Project : E-Commerce Sales & Customer Analytics

Objective:
Segment customers based on Recency, Frequency,
and Monetary value to identify high-value,
loyal, and at-risk customers.

============================================================
*/


/* Customer RFM Metrics */

WITH customer_rfm AS
(
    SELECT

        c.customer_unique_id,

        MAX(o.order_purchase_timestamp) AS last_purchase_date,

        COUNT(DISTINCT o.order_id) AS frequency,

        ROUND(SUM(op.payment_value),2) AS monetary

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_payments op
        ON o.order_id = op.order_id

    GROUP BY c.customer_unique_id
)

SELECT *
FROM customer_rfm
LIMIT 20;



/* Calculate Recency */

WITH customer_rfm AS
(
    SELECT

        c.customer_unique_id,

        MAX(o.order_purchase_timestamp) AS last_purchase_date,

        COUNT(DISTINCT o.order_id) AS frequency,

        ROUND(SUM(op.payment_value),2) AS monetary

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_payments op
        ON o.order_id = op.order_id

    GROUP BY c.customer_unique_id
)

SELECT

    customer_unique_id,

    DATEDIFF(
        '2018-10-17',
        DATE(last_purchase_date)
    ) AS recency,

    frequency,

    monetary

FROM customer_rfm;



/* RFM Scores */

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
)

SELECT

    customer_unique_id,

    recency,
    frequency,
    monetary,

    6 - NTILE(5) OVER (ORDER BY recency ASC) AS r_score,

    NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,

    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score

FROM customer_rfm;



/* Combined RFM Score */

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

        recency,
        frequency,
        monetary,

        6 - NTILE(5) OVER (ORDER BY recency ASC) AS r_score,

        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,

        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score

    FROM customer_rfm
)

SELECT

    customer_unique_id,

    recency,
    frequency,
    monetary,

    r_score,
    f_score,
    m_score,

    CONCAT(r_score, f_score, m_score) AS rfm_score

FROM rfm_scores;



/* Customer Segmentation */

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

        6 - NTILE(5) OVER(ORDER BY recency ASC) AS r_score,

        NTILE(5) OVER(ORDER BY frequency ASC) AS f_score,

        NTILE(5) OVER(ORDER BY monetary ASC) AS m_score

    FROM customer_rfm
)

SELECT

    customer_unique_id,

    CONCAT(r_score,f_score,m_score) AS rfm_score,

    CASE

        WHEN r_score >= 4
             AND f_score >= 4
             AND m_score >= 4
        THEN 'Champions'

        WHEN r_score >= 4
             AND f_score >= 3
        THEN 'Loyal Customers'

        WHEN r_score >= 4
             AND f_score <= 2
        THEN 'Potential Loyalists'

        WHEN r_score BETWEEN 2 AND 3
             AND f_score >= 3
        THEN 'Need Attention'

        WHEN r_score <= 2
             AND f_score <= 2
        THEN 'At Risk'

        ELSE 'Others'

    END AS customer_segment

FROM rfm_scores;



/* Customer Segment Distribution */

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

        6 - NTILE(5) OVER(ORDER BY recency ASC) AS r_score,

        NTILE(5) OVER(ORDER BY frequency ASC) AS f_score,

        NTILE(5) OVER(ORDER BY monetary ASC) AS m_score

    FROM customer_rfm
),

segments AS
(
    SELECT

        CASE

            WHEN r_score >= 4
                 AND f_score >= 4
                 AND m_score >= 4
            THEN 'Champions'

            WHEN r_score >= 4
                 AND f_score >= 3
            THEN 'Loyal Customers'

            WHEN r_score >= 4
                 AND f_score <= 2
            THEN 'Potential Loyalists'

            WHEN r_score BETWEEN 2 AND 3
                 AND f_score >= 3
            THEN 'Need Attention'

            WHEN r_score <= 2
                 AND f_score <= 2
            THEN 'At Risk'

            ELSE 'Others'

        END AS customer_segment

    FROM rfm_scores
)

SELECT
    customer_segment,
    COUNT(*) AS total_customers
FROM segments
GROUP BY customer_segment
ORDER BY total_customers DESC;


/*
============================================================
Key Business Insights

1. At Risk customers form the largest segment, indicating a
   significant opportunity for win-back campaigns.

2. More than 26,000 customers are Loyal Customers, showing
   a strong base of repeat buyers.

3. Over 8,000 customers are Champions who purchase recently,
   frequently, and spend the most. These customers should be
   prioritized through loyalty and premium programs.

4. Around 22,000 customers require attention before they
   become inactive, making them ideal targets for personalized
   promotions.

5. Potential Loyalists represent customers with recent
   purchases who can be converted into loyal customers
   through effective engagement strategies.
============================================================
*/