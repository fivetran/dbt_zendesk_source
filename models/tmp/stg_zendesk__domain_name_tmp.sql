--To disable this model, set the using_domain_names variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_domain_names', True) and var('customer360__using_zendesk', true)) }}

select {{ dbt_utils.star(source('zendesk', 'domain_name')) }} 
from {{ source('zendesk', 'domain_name') }} as domain_name_table