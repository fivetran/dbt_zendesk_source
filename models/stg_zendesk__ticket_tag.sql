
with base as (

    select * 
    from {{ ref('stg_zendesk__ticket_tag_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__ticket_tag_tmp')),
                staging_columns=get_ticket_tag_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        ticket_id,
        tags
    from fields
)

select * 
from final
