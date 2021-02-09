
with base as (

    select * 
    from {{ ref('stg_zendesk__ticket_comment_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__ticket_comment_tmp')),
                staging_columns=get_ticket_comment_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as ticket_comment_id,
        _fivetran_synced,
        body,
        created as created_at,
        public as is_public,
        ticket_id,
        user_id,
        facebook_comment as is_facebook_comment,
        tweet as is_tweet,
        voice_comment as is_voice_comment
    from fields
)

select * 
from final
