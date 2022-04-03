SELECT 
s.session_id,
s.user_id,
s.product_id,
s.order_id,
s.product_name
s.session_started_at_utc,
case when page_view_occured = 1 or add_to_cart_occured = 1 or checkout_occured = 1
     then 1
     else 0
     end as total_sessions_fnl,
case when add_to_cart_occured = 1 or checkout_occured = 1
     then 1
     else 0
     end as total_sessions_add_to_cart_fnl,
case when checkout_occured = 1
     then 1
     else 0
     end as total_sessions_checkout_fnl
FROM {{ ref('int_sessions') }} s
LEFT JOIN {{ ref('stg_products') }} p
  ON e.product_id = p.product_id