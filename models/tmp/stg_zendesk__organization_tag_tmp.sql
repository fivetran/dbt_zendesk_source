--To disable this model, set the using_organization_tags variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_organization_tags', True)) }}

select {{ dbt_utils.star(fivetran_utils.snowflake_seed_data('organization_tag_data')) }}
from {{ var('organization_tag') }}
