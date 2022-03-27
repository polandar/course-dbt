
{% set event_types = event_types() %}
-- {% set event_types = dbt_utils.get_column_values(table=ref('stg_events'), column='event_type') %}
with events AS (
    SELECT * FROM {{ ref('int_event_products') }}
),
sessions AS (
  SELECT
    session_id,
    product_id,
    MIN(created_at_utc) AS session_started_at_utc,
    {% for e_type in event_types %}
    SUM(CASE WHEN event_type = '{{ e_type }}' THEN 1 ELSE 0 END) AS {{ e_type }}_events,
    {% endfor %}
    COUNT(*) as total_events
  FROM events
  GROUP BY 1,2
)

SELECT * FROM sessions