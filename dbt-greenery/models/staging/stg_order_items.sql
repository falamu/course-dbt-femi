{{
  config(
    materialized='table'
  )
}}

SELECT
    id as order_item_id, 
    order_id, 
    product_id,
    quantity   
FROM {{ source('source', 'order_items') }}