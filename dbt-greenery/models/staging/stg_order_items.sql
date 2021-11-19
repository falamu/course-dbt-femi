{{
  config(
    materialized='table'
  )
}}

SELECT 
    id, 
    order_id, 
    product_id,
    quantity   
FROM {{ source('staging', 'order_items') }}