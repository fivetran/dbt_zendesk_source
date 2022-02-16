{% macro get_time_zone_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "standard_offset", "datatype": dbt_utils.type_string()},
    {"name": "time_zone", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
