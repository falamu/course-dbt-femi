{{
  config(
    materialized='table'
  )
}}

WITH event_types AS (
  SELECT 
    event_id, 
    created_at, 
    session_id, 
    user_id, 
    event_type,
    page_url, 
    regexp_split_to_array(page_url, '/') as page_array
  FROM {{ ref('stg_events')}}
)

SELECT
  event_id, 
  created_at, 
  session_id, 
  user_id, 
  event_type,
  page_url, 
  COALESCE(page_array[4],'home') as page_type, 
  CASE WHEN page_array[4] = 'product' THEN page_array[5] END as product_id 
FROM event_types
