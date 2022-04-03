{% snapshot orders_snapshot %}

{{
    config(
      target_database='dbt',
      target_schema='snapshots',
      unique_key='order_id',

      strategy='timestamp',
      updated_at='estimated_delivery_at_utc',
    )
}}


SELECT
order_id,
user_id,
promo_id,
address_id,
created_at,
order_cost,
shipping_cost,
order_total,
tracking_id,
shipping_service,
estimated_delivery_at as estimated_delivery_at_utc,
delivered_at as delivered_at_utc,
status AS order_status

FROM {{ source('staging', 'orders') }}

{% endsnapshot %} 