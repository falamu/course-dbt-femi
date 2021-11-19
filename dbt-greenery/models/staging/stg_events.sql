{{
  config(
    materialized='table'
  )
}}

SELECT 
    id, 
    event_id, 
    session_id, 
    user_id, 
    page_url, 
    created_at, 
    event_type 
FROM {{ source('staging', 'events') }}