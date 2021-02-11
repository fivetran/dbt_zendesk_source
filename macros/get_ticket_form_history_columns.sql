{% macro get_ticket_form_history_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "active", "datatype": "boolean"},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "display_name", "datatype": dbt_utils.type_string()},
    {"name": "end_user_visible", "datatype": "boolean"},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
