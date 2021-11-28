{{
  config(
    materialized='table'
  )
}}

SELECT 
  product_id, 
  product_name,
  price, 
  quantity > 0 as is_currently_in_stock 
FROM {{ ref('stg_products') }}