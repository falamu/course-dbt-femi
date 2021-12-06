{% macro get_event_types() %}

{{ return(dbt_utils.get_column_values(
  table = ref('stg_events'), 
  column = 'event_type'
))
}}

{% endmacro %}