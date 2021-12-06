{{
  config(
    materialized='table'
  )
}}

{%- set event_types = get_event_types() -%}

WITH days AS (
  {{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2020-01-01' as date)",
    end_date="cast('2025-01-01' as date)"
   )
  }}
),

product_days AS (
  SELECT 
    date_day::date as event_date,
    product_id
  FROM days 
  CROSS JOIN {{ ref('stg_products') }}
), 

daily_product_event_stats AS (
  SELECT
    date_trunc('day', created_at) as event_date, 
    product_id, 
    {% for event in event_types %}
    SUM(CASE WHEN event_type = '{{event}}' THEN 1 END) as daily_{{event}},
    COUNT(distinct session_id) FILTER(WHERE event_type = '{{event}}') as daily_sessions_with_{{event}},
    {% endfor %}
    COUNT(distinct session_id) as daily_sessions
  FROM {{ ref('int_event_type_details') }}
  WHERE created_at IS NOT NULL
  GROUP BY 1,2
), 

daily_orders AS (
  SELECT
    date_trunc('day', created_at) as event_date,  
    product_id, 
    COUNT(distinct order_id) as daily_orders_containing_product,
    SUM(quantity) as daily_total_quantity_ordered
  FROM {{ ref('stg_orders') }} 
  JOIN {{ ref('stg_order_items') }} USING (order_id) 
  GROUP BY 1,2
)

SELECT 
  event_date,
  product_id, 
  daily_page_view, 
  daily_add_to_cart, 
  daily_delete_from_cart, 
  daily_sessions_with_page_view, 
  daily_sessions_with_add_to_cart, 
  daily_sessions_with_delete_from_cart, 
  daily_orders_containing_product, 
  daily_total_quantity_ordered, 
  daily_sessions
FROM product_days
LEFT JOIN daily_product_event_stats USING (event_date, product_id)
LEFT JOIN daily_orders USING (event_date, product_id)