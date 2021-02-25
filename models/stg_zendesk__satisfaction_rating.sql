--To disable this model, set the using_satisfaction_ratings variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_satisfaction_ratings', True)) }}

with base as (

    select * 
    from {{ ref('stg_zendesk__satisfaction_rating_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__satisfaction_rating_tmp')),
                staging_columns=get_satisfaction_rating_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as satifaction_rating_id,
        ticket_id,
        requester_id,
        assignee_id,
        group_id,
        score,
        created_at,
        updated_at,
        comment,
        reason
    from fields
)

select * 
from final
