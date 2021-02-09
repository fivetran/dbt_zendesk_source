
with base as (

    select * 
    from {{ ref('stg_zendesk__ticket_field_history_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__ticket_field_history_tmp')),
                staging_columns=get_ticket_field_history_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        ticket_id,
        field_name,
        updated as valid_starting_at,
        lead(updated) over (partition by ticket_id, field_name order by updated) as valid_ending_at,
        value,
        user_id
    from fields
    
    order by 1,2,3
)

select * 
from final
