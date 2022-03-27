with products_source as (
    select * from {{ source('staging', 'products') }}
),
renamed_casted as (
    SELECT
        product_id,
        name as product_name,
        price,
        inventory
    FROM products_source
)

select * from renamed_casted