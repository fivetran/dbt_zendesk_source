
with base as (

    select * 
    from {{ ref('stg_zendesk__brand_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__brand_tmp')),
                staging_columns=get_brand_columns()
            )
        }}

        {{ 
            zendesk_source.zendesk_source_relation(
                connection_dictionary=var('zendesk_sources', []),
                single_schema=var('zendesk_schema', 'zendesk'),
                single_database=var('zendesk_schema', target.database),
                single_table_identifier=var("zendesk_brand_identifier", "brand")
            ) 
        }}
        
    from base
),

final as (
    
    select 
        id as brand_id,
        brand_url,
        name,
        subdomain,
        active as is_active,
        source_relation
        
    from fields
    where not coalesce(_fivetran_deleted, false)
)

select * 
from final
