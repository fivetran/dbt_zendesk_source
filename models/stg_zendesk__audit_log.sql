{{ config(enabled=var('using_schedules', True) and var('using_schedule_histories', False)) }}

with base as (

    select * 
    from {{ ref('stg_zendesk__audit_log_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__audit_log_tmp')),
                staging_columns=get_audit_log_columns()
            )
        }}

        {{ 
            zendesk_source.zendesk_source_relation(
                connection_dictionary=var('zendesk_sources', []),
                single_schema=var('zendesk_schema', 'zendesk'),
                single_database=var('zendesk_schema', target.database)
            ) 
        }}
        
    from base
),

final as (
    select 
        cast(id as {{ dbt.type_string() }}) as audit_log_id,
        action,
        actor_id,
        change_description,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        source_id,
        source_label,
        source_type,
        _fivetran_synced

    from fields
)

select * 
from final