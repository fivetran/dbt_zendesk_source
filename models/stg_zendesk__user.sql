
with base as (

    select * 
    from {{ ref('stg_zendesk__user_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__user_tmp')),
                staging_columns=get_user_columns()
            )
        }}
        
    from base
),

final as ( 
    
    select 
        id as user_id,
        external_id,
        _fivetran_synced,
        cast(last_login_at as {{ dbt.type_timestamp() }}) as last_login_at,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at,
        email,
        name,
        organization_id,
        phone,
        {% if var('internal_user_criteria', false) -%}
            case 
                when role in ('admin', 'agent') then role
                when {{ var('internal_user_criteria', false) }} then 'agent'
            else role end as role,
        {% else -%}
        role,
        {% endif -%}
        ticket_restriction,
        time_zone,
        locale,
        active as is_active,
        suspended as is_suspended

        {{ fivetran_utils.fill_pass_through_columns('zendesk__user_passthrough_columns') }}

        {%- set custom_fields = var('zendesk__user_passthrough_columns') -%}
        {%- set unique_custom_field_list = ['user_id', 'external_id', '_fivetran_synced', 'last_login_at', 'created_at', 'updated_at', 'email', 'name', 'organization_id', 'phone', 'role', 'ticket_restriction', 'locale', 'is_active', 'is_suspended'] -%}
        {%- for field in custom_fields %}
            {%- if field is mapping %}
                {%- do unique_custom_field_list.append(field.alias|lower if field.alias else field.name|lower) %}
            {%- else %}
                {%- do unique_custom_field_list.append(field|lower) %}
            {%- endif %}
        {% endfor -%}

        {%- if var('customer360_internal_match_ids', none) %}
            {%- for match_set in var('customer360_internal_match_ids', []) %}
                {%- if match_set.zendesk and match_set.zendesk.source|lower == 'user' %}
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
