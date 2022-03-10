{{ config(materialized='table') }}

with addresses_source as (
    select * from {{ source('staging', 'addresses') }}
),
renamed_casted as (
    SELECT
        address_id,
        address as full_address,
        zipcode,
        state as state_name,
        country
    FROM addresses_source
)

select * from renamed_casted