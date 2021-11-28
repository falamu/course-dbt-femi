{{
  config(
    materialized='table'
  )
}}


WITH address_location AS (
  SELECT
    address_id, 
    state,
    country
  FROM {{ ref('stg_addresses') }}
), 

address_validity AS (
  SELECT
    user_id, 
    address_id, 
    dbt_valid_from as address_valid_from, 
    dbt_valid_to as address_valid_to
  FROM {{ ref('users_snapshot') }}
)

SELECT 
  user_id,
  state, 
  country, 
  address_valid_from, 
  address_valid_to
FROM address_validity
JOIN address_location USING (address_id)