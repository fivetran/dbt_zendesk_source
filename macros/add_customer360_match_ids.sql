{%- macro add_customer360_match_ids(source_table, setting, base_columns=none) -%}

{%- set custom_fields = var('zendesk__' ~ source_table ~ '_passthrough_base_columns') -%}
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
        {%- if match_set.zendesk and match_set.zendesk.source|lower == source_table|lower %}
            {%- if match_set.zendesk.map_table %}
                {%- if match_set.zendesk.join_with_map_on not in unique_custom_field_list -%}
                    {%- if setting == 'model' %}
                        , {{ match_set.zendesk.join_with_map_on }}
                    {%- elif setting == 'macro' -%}
                        {% do base_columns.append({ "name": match_set.zendesk.join_with_map_on, "datatype": dbt.type_string()}) %}
                    {%- endif -%}
                {%- endif %}
            {%- else %}
                {%- if match_set.zendesk.match_key not in unique_custom_field_list -%}
                    {%- if setting == 'model' %}
                        , {{ match_set.zendesk.match_key }}
                    {% elif setting == 'macro' %}
                        {% do base_columns.append({ "name": match_set.zendesk.match_key, "datatype": dbt.type_string()}) %}
                    {% endif -%}
                {%- endif %}
            {%- endif %}
        {%- endif %}
    {%- endfor %}
{%- endif %}

{%- endmacro -%}