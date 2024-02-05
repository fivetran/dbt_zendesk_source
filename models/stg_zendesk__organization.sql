
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
        
        {{ fivetran_utils.source_relation(
            union_schema_variable='zendesk_union_schemas', 
            union_database_variable='zendesk_union_databases') 
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

    from fields
)

select * 
from final
