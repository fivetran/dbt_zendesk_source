
with base as (

    select * 
    from {{ ref('stg_zendesk__ticket_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__ticket_tmp')),
                staging_columns=get_ticket_columns()
            )
        }}

        --The below script allows for pass through columns.
        {% if var('zendesk__ticket_passthrough_columns',[]) %}
        ,
        {{ var('zendesk__ticket_passthrough_columns') | join (", ") }}

        {% endif %}
        
    from base
),

final as (
    
    select 
        id as ticket_id,
        _fivetran_synced,
        assignee_id,
        brand_id,
        {% if target.type == 'redshift' -%}
            cast(created_at as timestamp without time zone) as created_at,
            cast(updated_at as timestamp without time zone) as updated_at,
        {% else -%}
            created_at,
            updated_at,
        {% endif %}
        description,
        due_at,
        group_id,
        external_id,
        is_public,
        organization_id,
        priority,
        recipient,
        requester_id,
        status,
        subject,
        problem_id,
        submitter_id,
        ticket_form_id,
        type,
        url,
        via_channel as created_channel,
        via_source_from_id as source_from_id,
        via_source_from_title as source_from_title,
        via_source_rel as source_rel,
        via_source_to_address as source_to_address,
        via_source_to_name as source_to_name

        --The below script allows for pass through columns.
        {% if var('zendesk__ticket_passthrough_columns',[]) %}
        ,
        {{ var('zendesk__ticket_passthrough_columns') | join (", ") }}

        {% endif %}

    from fields
)

select * 
from final
