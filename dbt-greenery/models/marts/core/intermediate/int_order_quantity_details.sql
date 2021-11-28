{{
  config(
    materialized='table'
  )
}}

WITH aggregated_order_details AS (
  SELECT 
    order_id, 
    COUNT(distinct product_id) as unique_items_in_order,
    SUM(quantity) as total_items_in_order
  FROM {{ ref('stg_order_items') }}
  GROUP BY 1
)

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
FROM {{ ref('stg_orders') }} ord 
JOIN aggregated_order_details aod USING (order_id) 