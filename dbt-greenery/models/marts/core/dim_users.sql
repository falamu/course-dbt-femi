{{
  config(
    materialized='table'
  )
}}

SELECT 
  user_id, 
  first_name, 
  last_name, 
  email, 
  phone_number, 
  became_user_at, 
  address_id    
FROM {{ ref('stg_users') }}