{{
  config(
    materialized='table'
  )
}}

SELECT 
    id, 
    address_id, 
    address,
    zipcode, 
    state, 
    country   
FROM {{ source('staging', 'addresses') }}