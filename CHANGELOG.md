# dbt_zendesk_source v0.4.2
## Fixes
- Adjusted timestamp fields within staging models to explicitly cast the data type as `timestamp without time zone`. This fixes a Redshift error where downstream datediff and dateadd functions would result in an error if the timestamp fields are synced as `timestamp_tz`. ([#23](https://github.com/fivetran/dbt_zendesk_source/pull/23))

## Contributors
- @juanbriones ([#55](https://github.com/fivetran/dbt_zendesk/issues/55))

# dbt_zendesk_source v0.1.0 -> v0.4.1
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!