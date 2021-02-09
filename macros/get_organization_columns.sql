{% macro get_organization_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "custom_pre_order_", "datatype": "boolean"},
    {"name": "details", "datatype": dbt_utils.type_int()},
    {"name": "external_id", "datatype": dbt_utils.type_int()},
    {"name": "group_id", "datatype": dbt_utils.type_int()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "notes", "datatype": dbt_utils.type_int()},
    {"name": "shared_comments", "datatype": "boolean"},
    {"name": "shared_tickets", "datatype": "boolean"},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "url", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
