{% macro get_organization_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "details", "datatype": dbt.type_int()},
    {"name": "external_id", "datatype": dbt.type_int()},
    {"name": "group_id", "datatype": dbt.type_int()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "notes", "datatype": dbt.type_int()},
    {"name": "shared_comments", "datatype": "boolean"},
    {"name": "shared_tickets", "datatype": "boolean"},
    {"name": "updated_at", "datatype": dbt.type_timestamp()},
    {"name": "url", "datatype": dbt.type_string()}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('zendesk__organization_passthrough_columns')) }}

{%- set custom_fields = var('zendesk__organization_passthrough_columns') -%}
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
        {%- if match_set.zendesk and match_set.zendesk.source|lower == 'organization' %}
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
