{{
  config(
    materialized='table'
  )
}}


WITH ordered_session_events AS (
  SELECT
    event_id,  
    session_id, 
    user_id,
    page_url, 
    created_at, 
    event_type, 
    row_number() over (partition by session_id order by created_at) as seq
  FROM {{ ref('stg_events') }}
), 

first_session_event AS (
  SELECT 
    event_id as first_event_id, 
    session_id, 
    user_id, 
    page_url as landing_page_url,
    created_at as session_started_at, 
    event_type as first_event_type 
  FROM ordered_session_events
  WHERE seq = 1
), 

aggregated_session_events AS (
  SELECT 
    session_id, 
    SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) as page_views,
    SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) as cart_additions,
    SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) as checkouts,
    SUM(CASE WHEN event_type = 'account_created' THEN 1 ELSE 0 END) as signups
  FROM {{ ref('stg_events') }}
  GROUP BY 1
)

SELECT 
  first_event_id,
  session_id, 
  session_started_at, 
  user_id, 
  landing_page_url, 
  first_event_type, 
  page_views as session_page_views, 
  signups >= 1 as session_has_signup, 
  cart_additions >= 1 as session_has_cart_additions, 
  checkouts >= 1 as session_has_checkout, 
  checkouts
FROM first_session_event 
JOIN aggregated_session_events USING (session_id)
