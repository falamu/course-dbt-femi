{{
  config(
    materialized='table'
  )
}}

SELECT 
  product_id, 
  name as product_name,
  price, 
  quantity   
FROM {{ source('source', 'products') }}