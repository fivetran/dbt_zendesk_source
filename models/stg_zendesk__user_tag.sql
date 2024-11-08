--To disable this model, set the using_user_tags variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_user_tags', True)) }}

with base as (

    select * 
    from {{ ref('stg_zendesk__user_tag_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__user_tag_tmp')),
                staging_columns=get_user_tag_columns()
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
        user_id,
        {% if target.type == 'redshift' %}
        'tag'
        {% else %}
        tag
        {% endif %}
        as tags,
        source_relation
        
    from fields
)

select * 
from final
