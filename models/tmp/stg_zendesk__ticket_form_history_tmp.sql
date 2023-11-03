--To disable this model, set the using_ticket_form_history variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_ticket_form_history', True)) }}

select {{ dbt_utils.star(from=source('zendesk', 'ticket_form_history')) }}
from {{ var('ticket_form_history') }}
