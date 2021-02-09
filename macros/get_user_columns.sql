{% macro get_user_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "active", "datatype": "boolean"},
    {"name": "alias", "datatype": dbt_utils.type_string()},
    {"name": "authenticity_token", "datatype": dbt_utils.type_int()},
    {"name": "chat_only", "datatype": "boolean"},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "custom_pre_order_", "datatype": "boolean"},
    {"name": "custom_role_id", "datatype": dbt_utils.type_int()},
    {"name": "details", "datatype": dbt_utils.type_int()},
    {"name": "email", "datatype": dbt_utils.type_string()},
    {"name": "external_id", "datatype": dbt_utils.type_int()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "last_login_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "locale", "datatype": dbt_utils.type_string()},
    {"name": "locale_id", "datatype": dbt_utils.type_int()},
    {"name": "moderator", "datatype": "boolean"},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "notes", "datatype": dbt_utils.type_int()},
    {"name": "only_private_comments", "datatype": "boolean"},
    {"name": "organization_id", "datatype": dbt_utils.type_int()},
    {"name": "phone", "datatype": dbt_utils.type_int()},
    {"name": "remote_photo_url", "datatype": dbt_utils.type_int()},
    {"name": "restricted_agent", "datatype": "boolean"},
    {"name": "role", "datatype": dbt_utils.type_string()},
    {"name": "shared", "datatype": "boolean"},
    {"name": "shared_agent", "datatype": "boolean"},
    {"name": "signature", "datatype": dbt_utils.type_int()},
    {"name": "suspended", "datatype": "boolean"},
    {"name": "ticket_restriction", "datatype": dbt_utils.type_string()},
    {"name": "time_zone", "datatype": dbt_utils.type_string()},
    {"name": "two_factor_auth_enabled", "datatype": "boolean"},
    {"name": "updated_at", "datatype": dbt_utils.type_string()},
    {"name": "url", "datatype": dbt_utils.type_string()},
    {"name": "verified", "datatype": "boolean"}
] %}

{{ return(columns) }}

{% endmacro %}
