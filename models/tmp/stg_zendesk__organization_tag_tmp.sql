--To disable this model, set the using_organization_tags variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_organization_tags', True)) }}

select * 
from {{ var('organization_tag') }}
