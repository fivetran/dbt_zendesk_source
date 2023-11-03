--To disable this model, set the using_domain_names variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_domain_names', True)) }}

select {{ dbt_utils.star(from=source('zendesk', 'domain_name')) }}
from {{ var('domain_name') }}
