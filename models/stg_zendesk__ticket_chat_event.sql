
{{ config(enabled=var('using_chat', True)) }}

with base as (

    select * 
    from {{ ref('stg_zendesk__ticket_chat_event_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__ticket_chat_event_tmp')),
                staging_columns=get_ticket_chat_event_columns()
            )
        }}

        {{ zendesk_source.apply_source_relation() }}

    from base
),

final as (
    
    select 
        source_relation, 
        _fivetran_synced,
        cast(actor_id as {{ dbt.type_int() }}) as actor_id,
        chat_id,
        chat_index,
        created_at,
        external_message_id,
        filename,
        is_history_context,
        message,
        message_id,
        message_source,
        mime_type,
        original_message_type,
        parent_message_id,
        reason,
        size,
        status,
        status_updated_at,
        type,
        url

    from fields
)

select *
from final
