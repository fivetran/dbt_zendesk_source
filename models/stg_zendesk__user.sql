
with base as (

    select * 
    from {{ ref('stg_zendesk__user_tmp') }}

),

fields as (

    select
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
        _fivetran_synced,
        created_at,
        email,
        name,
        organization_id,
        role,
        ticket_restriction,
        time_zone,
        active as is_active
    from fields
)

select * 
from final
