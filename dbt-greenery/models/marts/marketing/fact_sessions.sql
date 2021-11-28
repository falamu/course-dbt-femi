{{
  config(
    materialized='table'
  )
}}

SELECT 
  first_event_id,
  session_id, 
  session_started_at, 
  state as session_user_state, 
  country as session_user_country,
  user_id, 
  landing_page_url, 
  first_event_type, 
  session_page_views, 
  session_has_signup, 
  session_has_cart_additions,
  session_has_checkout, 
  checkouts
FROM {{ ref('int_session_details') }}
LEFT JOIN {{ ref('int_valid_user_address_country') }} USING (user_id)
WHERE session_started_at BETWEEN address_valid_from AND COALESCE(address_valid_to, now() at time zone 'utc')