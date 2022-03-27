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
        orders.product_id,
        orders.product_name,
        SUM(orders.quantity) as items_quantity
    from {{ ref('int_orders') }} orders
    {{ dbt_utils.group_by(n=18) }}
)

select * from fact_orders