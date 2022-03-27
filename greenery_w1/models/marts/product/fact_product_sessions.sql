WITH sessions AS (
    SELECT * FROM {{ ref('fact_sessions') }}
),
products AS (
    SELECT * FROM {{ ref('dim_products') }}
),
product_sessions AS (
    SELECT 
        sessions.product_id,
        products.product_name,
        SUM(CASE WHEN sessions.checkout_events = 0 THEN 0 ELSE 1 END) AS purchase_sessions,
        COUNT(DISTINCT sessions.session_id) AS unique_sessions
    FROM sessions
    JOIN products
    ON sessions.product_id = products.product_id
    GROUP BY 1,2
)

SELECT
    *,
    CAST(purchase_sessions AS NUMERIC)/CAST(unique_sessions AS NUMERIC) AS product_conversion_rate
FROM product_sessions
  