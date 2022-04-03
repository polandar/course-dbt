
{% set event_types = event_types() %}
-- {% set event_types = dbt_utils.get_column_values(table=ref('stg_events'), column='event_type') %}
with events AS (
    SELECT * FROM {{ ref('stg_events') }}
),
sessions AS (
  SELECT
    session_id,
    product_id,
    user_id,
    order_id,
    MIN(created_at_utc) AS session_started_at_utc,
    {% for e_type in event_types %}
    SUM(CASE WHEN event_type = '{{ e_type }}' THEN 1 ELSE 0 END) AS {{ e_type }}_events,
    {% endfor %}
    {% for event_type in event_types %}
    MAX(CASE WHEN event_type = '{{event_type}}' THEN 1 ELSE 0 END) AS {{event_type}}_occured,
    {% endfor %},
    COUNT(*) as total_events
  FROM events
  WHERE product_id is not NULL
  GROUP BY 1,2,3, 4
)

SELECT * FROM sessions