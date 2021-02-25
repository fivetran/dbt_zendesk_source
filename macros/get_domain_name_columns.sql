{% macro get_domain_name_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "domain_name", "datatype": dbt_utils.type_string()},
    {"name": "index", "datatype": dbt_utils.type_int()},
    {"name": "organization_id", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}
