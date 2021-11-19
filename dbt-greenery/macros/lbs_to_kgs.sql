​​{% macro lbs_to_kgs(column_name, precision=2) %}
   round(
       (COALESCE({{ column_name }}, -99) / 2.205)::numeric, 
       {{ precision }}
    )
{% endmacro %}