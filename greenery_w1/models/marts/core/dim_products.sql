{{ config(materialized='table') }}

with dim_products as (
    select
        products.product_id,
        products.product_name,
        products.price,
        products.inventory,
        order_items.order_id,
        order_items.quantity
    from {{ ref('stg_products') }} products
    left join {{ ref('stg_order_items') }} order_items 
    on products.product_id = order_items.product_id
)

select * from dim_products