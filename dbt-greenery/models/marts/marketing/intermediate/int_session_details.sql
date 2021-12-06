{{
  config(
    materialized='table'
  )
}}

{% set aggregate_column = 'event_type' %}

{% set event_types = dbt_utils.get_column_values(
  table = ref('stg_events'), 
  column = {{ aggregate_column }} 
) 
%}

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
    {% for event_type in event_types %}
      {{ aggregate_events( {{aggregate_column}}, {{event_type}} ) }}  as session_{{event_type}}_events,
    {% endfor %}
    COUNT(distinct event_type) as distinct_events
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

  {% for event_type in event_types %}
    session_{{event_type}}_events, 
    session_{{event_type}}_events >= 1 as session_has_{{event_type}},
  {% endfor %}

  distinct_events
FROM first_session_event 
JOIN aggregated_session_events USING (session_id)
