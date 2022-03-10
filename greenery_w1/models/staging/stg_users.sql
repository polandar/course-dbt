{{ config(materialized='table') }}

with users_source as (
    select * from {{ source('staging', 'users') }}
),
renamed_casted as (
    SELECT
        user_id,
        address_id,
        first_name,
        last_name,
        email,
        phone_number,
        created_at,
        updated_at
    FROM users_source
)

select * from renamed_casted