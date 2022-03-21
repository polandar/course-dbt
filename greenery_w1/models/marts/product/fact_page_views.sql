{{ config(materialized='table') }}

with fact_page_views as (
    select
        events.event_id,
        events.session_id,
        events.user_id,
        events.event_type,
        events.page_url,
        events.created_at_utc AS event_created_at_utc,
        events.order_id,
        events.product_id,
        users.first_name,
        users.last_name,
        users.email,
        users.phone_number,
        users.created_at_utc AS user_created_at_utc,
        users.updated_at_utc as user_updated_at_utc,
        users.address_id
    from {{ ref('stg_events') }} events
    left join {{ ref('stg_users') }} users 
    on users.user_id = events.user_id
)

SELECT * FROM fact_page_views