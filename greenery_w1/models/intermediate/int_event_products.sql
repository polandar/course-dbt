WITH events AS (
    SELECT * FROM {{ ref('stg_events') }}
)

, products AS (
    SELECT * FROM {{ ref('stg_products') }}
)

Select
events.event_id,
events.session_id,
events.page_url,
events.created_at_utc,
events.event_type,
events.product_id


from events