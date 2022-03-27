with promos_source as (
    select * from {{ source('staging', 'promos') }}
),

renamed_casted as (
    SELECT
        promo_id,
        discount,
        status as promo_status
    FROM
        promos_source
)

select * from renamed_casted