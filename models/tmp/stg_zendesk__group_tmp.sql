{{
    fivetran_utils.union_data(
        table_identifier='group', 
        database_variable='zendesk_database', 
        schema_variable='zendesk_schema', 
        default_database=target.database,
        default_schema='zendesk',
        default_variable='group',
        union_schema_variable='zendesk_union_schemas',
        union_database_variable='zendesk_union_databases'
    )
}}