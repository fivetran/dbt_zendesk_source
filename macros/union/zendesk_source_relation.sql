{% macro zendesk_source_relation(connection_dictionary, single_schema, single_database) -%}

{{ adapter.dispatch('zendesk_source_relation', 'zendesk_source') (connection_dictionary, single_schema, single_database, single_table_identifier) }}

{%- endmacro %}

{% macro default__zendesk_source_relation(connection_dictionary, single_schema, single_database, single_table_identifier) -%}

{% if connection_dictionary %}
, _dbt_source_relation as source_relation
{% else %}
, '{{ single_database }}' || '.'|| '{{ single_schema }}' as source_relation
{% endif %} 

{%- endmacro %}