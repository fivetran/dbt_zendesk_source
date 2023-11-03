--To disable this model, set the using_user_tags variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_user_tags', True)) }}

select {{ dbt_utils.star(fivetran_utils.snowflake_seed_data('user_tag_data')) }}  
from {{ var('user_tag') }}
