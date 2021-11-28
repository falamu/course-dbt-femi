{{
  config(
    materialized='table'
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
  unique_items_in_order, 
  total_items_in_order,
  tracking_id, 
  shipping_service, 
  estimated_delivery_at, 
  delivered_at, 
  status   
FROM {{ ref('int_order_quantity_details') }} 