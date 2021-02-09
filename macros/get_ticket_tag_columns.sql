{% macro get_ticket_tag_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "'tag'", "datatype": dbt_utils.type_string(), "alias": "tags"},
    {"name": "ticket_id", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}
