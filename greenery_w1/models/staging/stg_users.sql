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
        created_at as created_at_utc,
        updated_at as updated_at_utc
    FROM users_source
)

select * from renamed_casted