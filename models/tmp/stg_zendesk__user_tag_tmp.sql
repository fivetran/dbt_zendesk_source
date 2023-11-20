--To disable this model, set the using_user_tags variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_user_tags', True)) }}

select {{ dbt_utils.star(source('zendesk','user_tag')) }}  
from {{ source('zendesk','user_tag') }} as user_tag_table
