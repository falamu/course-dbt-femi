{{
  config(
    materialized='table'
  )
}}

SELECT 
    id, 
    product_id, 
    name,
    price, 
    quantity   
FROM {{ source('staging', 'products') }}