{% macro get_satisfaction_rating_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "assignee_id", "datatype": dbt_utils.type_int()},
    {"name": "comment", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "group_id", "datatype": dbt_utils.type_int()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "reason", "datatype": dbt_utils.type_string()},
    {"name": "requester_id", "datatype": dbt_utils.type_int()},
    {"name": "score", "datatype": dbt_utils.type_string()},
    {"name": "ticket_id", "datatype": dbt_utils.type_int()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "url", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
