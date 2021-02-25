{% macro get_brand_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "active", "datatype": "boolean"},
    {"name": "brand_url", "datatype": dbt_utils.type_string()},
    {"name": "has_help_center", "datatype": "boolean"},
    {"name": "help_center_state", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "logo_content_type", "datatype": dbt_utils.type_string()},
    {"name": "logo_content_url", "datatype": dbt_utils.type_string()},
    {"name": "logo_deleted", "datatype": "boolean"},
    {"name": "logo_file_name", "datatype": dbt_utils.type_string()},
    {"name": "logo_height", "datatype": dbt_utils.type_int()},
    {"name": "logo_id", "datatype": dbt_utils.type_int()},
    {"name": "logo_inline", "datatype": "boolean"},
    {"name": "logo_mapped_content_url", "datatype": dbt_utils.type_string()},
    {"name": "logo_size", "datatype": dbt_utils.type_int()},
    {"name": "logo_url", "datatype": dbt_utils.type_string()},
    {"name": "logo_width", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "subdomain", "datatype": dbt_utils.type_string()},
    {"name": "url", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
