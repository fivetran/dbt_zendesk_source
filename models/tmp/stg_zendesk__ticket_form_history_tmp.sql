--To disable this model, set the using_ticket_form_history variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_ticket_form_history', True)) }}

{{
    fivetran_utils.union_data(
        table_identifier='ticket_form_history', 
        database_variable='zendesk_database', 
        schema_variable='zendesk_schema', 
        default_database=target.database,
        default_schema='zendesk',
        default_variable='ticket_form_history',
        union_schema_variable='zendesk_union_schemas',
        union_database_variable='zendesk_union_databases'
    )
}}