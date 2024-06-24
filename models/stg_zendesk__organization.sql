
with base as (

    select * 
    from {{ ref('stg_zendesk__organization_tmp') }}

),

fields as (

    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns 
        that are expected/needed (staging_columns from dbt_zendesk_source/models/tmp/) and compares it with columns 
        in the source (source_columns from dbt_zendesk_source/macros/).
        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__organization_tmp')),
                staging_columns=get_organization_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as organization_id,
        created_at,
        updated_at,
        details,
        name,
        external_id

        {{ fivetran_utils.fill_pass_through_columns('zendesk__organization_passthrough_columns') }}

        {%- set custom_fields = var('zendesk__organization_passthrough_columns') -%}
        {%- set unique_custom_field_list = ['organization_id', 'created_at', 'updated_at', 'details', 'name', 'external_id'] -%}
        {%- for field in custom_fields %}
            {%- if field is mapping %}
                {%- do unique_custom_field_list.append(field.alias|lower if field.alias else field.name|lower) %}
            {%- else %}
                {%- do unique_custom_field_list.append(field|lower) %}
            {%- endif %}
        {% endfor -%}

        {%- if var('customer360_internal_match_ids', none) %}
            {%- for match_set in var('customer360_internal_match_ids', []) %}
                {%- if match_set.zendesk and match_set.zendesk.source|lower == 'organization' %}
                    {%- if match_set.zendesk.map_table %}
                        {%- if match_set.zendesk.join_with_map_on|lower not in unique_custom_field_list -%}
                            , {{ match_set.zendesk.join_with_map_on }}
                        {% endif %}
                    {%- else %}
                        {%- if match_set.zendesk.match_key|lower not in unique_custom_field_list -%}
                            , {{ match_set.zendesk.match_key }}
                        {% endif %}
                    {%- endif %}
                {%- endif %}
            {%- endfor %}
        {%- endif %}

    from fields
)

select * 
from final
