{{ config(materialized='table') }}

with events_source as (
    select * from {{ source('staging', 'events') }}
),
renamed_casted as (
    SELECT
        event_id,
        session_id,
        user_id,
        event_type,
        page_url,
        created_at as created_at_utc,
        order_id,
        product_id
    FROM events_source
)

select * from renamed_casted