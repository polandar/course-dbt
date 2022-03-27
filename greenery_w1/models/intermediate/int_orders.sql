WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
), promos AS (
    SELECT * FROM {{ ref('stg_promos') }}
)

SELECT 
orders.order_id,
orders.user_id,
orders.promo_id,
orders.address_id,
orders.created_at_utc,
orders.order_cost,
orders.shipping_cost,
orders.order_total,
orders.tracking_id,
orders.shipping_service,
orders.estimated_delivery_at_utc,
orders.delivered_at_utc,
orders.order_status,
ROUND(COALESCE(promos.discount,0),2) AS discount_percentage,
promos.promo_status,
CASE WHEN estimated_delivery_at_utc < delivered_at_utc THEN TRUE ELSE FALSE END AS is_late_order

FROM orders

LEFT JOIN promos
    ON orders.promo_id = promos.promo_id