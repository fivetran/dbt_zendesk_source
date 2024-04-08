{% macro get_user_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "active", "datatype": "boolean"},
    {"name": "alias", "datatype": dbt.type_string()},
    {"name": "authenticity_token", "datatype": dbt.type_int()},
    {"name": "chat_only", "datatype": "boolean"},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "details", "datatype": dbt.type_int()},
    {"name": "email", "datatype": dbt.type_string()},
    {"name": "external_id", "datatype": dbt.type_int()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "last_login_at", "datatype": dbt.type_timestamp()},
    {"name": "locale", "datatype": dbt.type_string()},
    {"name": "locale_id", "datatype": dbt.type_int()},
    {"name": "moderator", "datatype": "boolean"},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "notes", "datatype": dbt.type_int()},
    {"name": "only_private_comments", "datatype": "boolean"},
    {"name": "organization_id", "datatype": dbt.type_int()},
    {"name": "phone", "datatype": dbt.type_string()},
    {"name": "remote_photo_url", "datatype": dbt.type_int()},
    {"name": "restricted_agent", "datatype": "boolean"},
    {"name": "role", "datatype": dbt.type_string()},
    {"name": "shared", "datatype": "boolean"},
    {"name": "shared_agent", "datatype": "boolean"},
    {"name": "signature", "datatype": dbt.type_int()},
    {"name": "suspended", "datatype": "boolean"},
    {"name": "ticket_restriction", "datatype": dbt.type_string()},
    {"name": "time_zone", "datatype": dbt.type_string()},
    {"name": "two_factor_auth_enabled", "datatype": "boolean"},
    {"name": "updated_at", "datatype": dbt.type_string()},
    {"name": "url", "datatype": dbt.type_string()},
    {"name": "verified", "datatype": "boolean"}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('zendesk__user_passthrough_columns')) }}

{%- set custom_fields = var('zendesk__user_passthrough_columns') -%}
{%- set unique_custom_field_list = [] -%}
{%- for field in custom_fields %}
    {%- if field is mapping %}
        {%- do unique_custom_field_list.append(field.alias if field.alias else field.name) %}
    {%- else %}
        {%- do unique_custom_field_list.append(field) %}
    {%- endif %}
{% endfor -%}

{%- if var('customer360_internal_match_ids') %}
    {%- for match_set in var('customer360_internal_match_ids') %}
        {%- if match_set.zendesk and match_set.zendesk.source|lower == 'user' %}
            {%- if match_set.zendesk.map_table %}
                {%- if match_set.zendesk.join_with_map_on not in unique_custom_field_list -%}
                    {% do columns.append({ "name": match_set.zendesk.join_with_map_on, "datatype": dbt.type_string()}) %}
                {% endif %}
            {%- else %}
                {%- if match_set.zendesk.match_key not in unique_custom_field_list -%}
                    {% do columns.append({ "name": match_set.zendesk.match_key, "datatype": dbt.type_string()}) %}
                {% endif %}
            {%- endif %}
        {%- endif %}
    {%- endfor %}
{%- endif %}

{{ return(columns) }}

{% endmacro %}