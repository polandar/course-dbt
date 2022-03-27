WITH sessions AS (
    SELECT * FROM {{ ref('fact_sessions') }}
),
products AS (
    SELECT 
    DISTINCT product_id,
    product_name
    FROM {{ ref('dim_products') }}
),
product_sessions AS (
    SELECT 
        sessions.product_id,
        products.product_name,
        SUM(CASE WHEN sessions.add_to_cart_events = 0 THEN 0 ELSE 1 END) AS purchase_sessions,
        COUNT(DISTINCT sessions.session_id) AS unique_sessions
    FROM sessions
    LEFT JOIN products
    ON sessions.product_id = products.product_id
    GROUP BY 1,2
)

SELECT
    *
    ,ROUND(CAST(purchase_sessions AS NUMERIC)/CAST(unique_sessions AS NUMERIC)*100, 2) AS product_conversion_rate
FROM product_sessions
  