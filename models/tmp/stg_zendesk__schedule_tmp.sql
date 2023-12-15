--To disable this model, set the using_schedules variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_schedules', True)) }}

{{
    fivetran_utils.union_data(
        table_identifier='schedule', 
        database_variable='zendesk_database', 
        schema_variable='zendesk_schema', 
        default_database=target.database,
        default_schema='zendesk',
        default_variable='schedule',
        union_schema_variable='zendesk_union_schemas',
        union_database_variable='zendesk_union_databases'
    )
}}