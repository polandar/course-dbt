with fact_orders as (
    select
        orders.order_id,
        orders.promo_id,
        orders.user_id,
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
        order_items.product_id,
        order_items.quantity
    from {{ ref('stg_orders') }} orders
    left join {{ ref('stg_order_items') }} order_items 
    on orders.order_id = order_items.order_id
)

select * from fact_orders