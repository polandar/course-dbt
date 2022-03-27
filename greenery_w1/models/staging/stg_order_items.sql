with order_items_source as (
    select * from {{ source('staging', 'order_items') }}
),
renamed_casted as (
    SELECT
        order_id,
        product_id,
        quantity
    FROM
        order_items_source
)

select * FROM renamed_casted