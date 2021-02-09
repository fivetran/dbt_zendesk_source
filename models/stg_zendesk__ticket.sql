
with base as (

    select * 
    from {{ ref('stg_zendesk__ticket_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__ticket_tmp')),
                staging_columns=get_ticket_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as ticket_id,
        _fivetran_synced,
        assignee_id,
        brand_id,
        created_at,
        description,
        due_at,
        group_id,
        is_public,
        organization_id,
        priority,
        recipient,
        requester_id,
        status,
        subject,
        submitter_id,
        ticket_form_id,
        type,
        updated_at,
        url,
        via_channel as created_channel,
        via_source_from_id as source_from_id,
        via_source_from_title as source_from_title,
        via_source_rel as source_rel,
        via_source_to_address as source_to_address,
        via_source_to_name as source_to_name
    from fields
)

select * 
from final
