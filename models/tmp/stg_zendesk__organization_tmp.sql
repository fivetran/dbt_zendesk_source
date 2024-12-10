{{ config(enabled=var('using_organizations', True)) }}

select {{ dbt_utils.star(source('zendesk', 'organization')) }}
from {{  source('zendesk','organization') }} as organization_table