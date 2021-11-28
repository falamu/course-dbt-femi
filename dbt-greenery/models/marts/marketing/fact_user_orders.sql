{{
  config(
    materialized='table'
  )
}}

WITH users AS (
  SELECT
    distinct user_id
  FROM {{ ref('stg_users') }} 
),

order_details AS (
  SELECT 
    order_id, 
    user_id,
    created_at, 
    order_total, 
    unique_items_in_order, 
    total_items_in_order 
  FROM {{ ref('int_order_quantity_details') }} 
) 

SELECT 
  user_id, 
  MIN(created_at) as first_order_placed_at, 
  MAX(created_at) as latest_order_placed_at, 
  COALESCE(COUNT(distinct order_id), 0) as total_orders_placed, 
  SUM(CASE WHEN unique_items_in_order > 1 THEN 1 END ) as orders_with_multiple_unique_items, 
  SUM(CASE WHEN total_items_in_order > 1 THEN 1 END) as orders_with_multiple_items, 
  MAX(total_items_in_order) as largest_order_quantity, 
  MAX(order_total) as largest_order_amount, 
  SUM(total_items_in_order) as lifetime_items_ordered, 
  SUM(order_total) as lifetime_order_amount
FROM users 
LEFT JOIN order_details USING (user_id)
GROUP BY 1