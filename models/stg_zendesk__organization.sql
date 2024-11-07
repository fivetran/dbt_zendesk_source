
with base as (

    select * 
    from {{ ref('stg_zendesk__organization_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__organization_tmp')),
                staging_columns=get_organization_columns()
            )
        }}
        
        {{ 
            zendesk_source.zendesk_source_relation(
                connection_dictionary=var('zendesk_sources', []),
                single_schema=var('zendesk_schema', 'zendesk'),
                single_database=var('zendesk_schema', target.database),
                single_table_identifier=var("zendesk_organization_identifier", "organization")
            ) 
        }}

    from base
),

final as (
    
    select 
        id as organization_id,
        created_at,
        updated_at,
        details,
        name,
        external_id,
        source_relation

        {{ fivetran_utils.fill_pass_through_columns('zendesk__organization_passthrough_columns') }}

    from fields
)

select * 
from final
