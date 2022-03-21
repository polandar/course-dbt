{{ config(materialized='table') }}

with fact_user_orders as (
    select
        users.user_id,
        users.created_at_utc as user_created_at_utc,
        users.updated_at_utc as user_updated_at_utc,
        orders.order_id,
        orders.promo_id,
        orders.address_id,
        orders.created_at_utc as order_created_at_utc,
        orders.order_cost,
        orders.shipping_cost,
        orders.order_total,
        orders.tracking_id,
        orders.shipping_service,
        orders.estimated_delivery_at_utc,
        orders.delivered_at_utc,
        orders.order_status
    from {{ ref('stg_users') }} users
    left join {{ ref('stg_orders') }} orders
    on users.user_id = orders.user_id
)

select * from fact_user_orders