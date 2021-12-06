{% macro aggregate_events(column_name, column_value) %}

SUM(CASE WHEN {{column_name}} = '{{column_value}}' THEN 1 ELSE 0 END)

{% endmacro %}