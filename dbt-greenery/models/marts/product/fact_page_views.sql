{{
  config(
    materialized='table'
  )
}}


SELECT
  event_id, 
  created_at as page_viewed_at, 
  session_id, 
  user_id, 
  page_url, 
  page_type, 
  product_id 
FROM {{ ref('int_event_type_details')}}
WHERE event_type = 'page_view'