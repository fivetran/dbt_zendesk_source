--To disable this model, set the using_satisfaction_ratings variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_satisfaction_ratings', True)) }}

select * 
from {{ var('satisfaction_rating') }}
