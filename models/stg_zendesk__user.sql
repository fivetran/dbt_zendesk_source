
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
        {% if target.type == 'redshift' -%}
            cast(last_login_at as timestamp without time zone) as last_login_at,
            cast(created_at as timestamp without time zone) as created_at,
            cast(updated_at as timestamp without time zone) as updated_at,
        {% else -%}
            last_login_at,
            created_at,
            updated_at,
        {% endif -%}
        email,
        name,
        organization_id,
        {% if var('zendesk__internal_user_criteria', false) -%}
            case 
                when role in ('admin', 'agent') then role
                when {{ var('zendesk__internal_user_criteria', false) }} then 'agent'
            else role end as role,
        {% else -%}
        role,
        {% endif -%}
        ticket_restriction,
        time_zone,
        locale,
        active as is_active,
        suspended as is_suspended
    from fields
)

select * 
from final
