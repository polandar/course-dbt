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
        orders.discount_percentage,
        orders.promo_status,
        orders.is_late_order,
        order_items.product_id,
        SUM(order_items.quantity) as items_quantity
    from {{ ref('int_orders') }} orders
    left join {{ ref('stg_order_items') }} order_items 
    on orders.order_id = order_items.order_id
    group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
)

select * from fact_orders