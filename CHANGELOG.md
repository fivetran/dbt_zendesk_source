# dbt_zendesk_source v0.UPDATE.UPDATE

 ## Under the Hood:

- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github).
# dbt_zendesk_source v0.8.1
## Bug Fixes
- Updated the dbt-utils dispatch within the `stg_zendesk__ticket_schedule_tmp` model to properly dispatch `dbt` as opposed to `dbt_utils` for the cross-db-macros. ([#32](https://github.com/fivetran/dbt_zendesk_source/pull/32))

## Contributors
- [stumelius](https://github.com/stumelius) ([#32](https://github.com/fivetran/dbt_zendesk_source/pull/32))

# dbt_zendesk_source v0.8.0

## 🚨 Breaking Changes 🚨:
[PR #31](https://github.com/fivetran/dbt_zendesk_source/pull/31) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_zendesk_source v0.7.0
🚨 This includes Breaking Changes! 🚨

## 🎉 Documentation and Feature Updates 🎉
- Updated README documentation for easier navigation and dbt package setup ([#28](https://github.com/fivetran/dbt_zendesk_source/pull/28)).
- Included the `zendesk_[source_table_name]_identifier` variables for easier flexibility of the package models to refer to differently named sources tables ([#28](https://github.com/fivetran/dbt_zendesk_source/pull/28)).
- Databricks compatibility 🧱 ([#29](https://github.com/fivetran/dbt_zendesk_source/pull/29))
- By default, this package now builds the Zendesk staging models within a schema titled (`<target_schema>` + `_zendesk_source`) in your target database. This was previously `<target_schema>` + `_zendesk_staging`, but we have changed it to maintain consistency with our other packges. See the README for instructions on how to configure the build schema differently. 

# dbt_zendesk_source v0.6.1
## Features
- The `stg_zendesk__ticket` table now allows for your custom passthrough columns to be added via the `zendesk__ticket_passthrough_columns` variable. You can add your passthrough columns as a list within the variable in your project configuration. ([#27](https://github.com/fivetran/dbt_zendesk_source/pull/27))
# dbt_zendesk_source v0.6.0

# Features
- Incorporates the `daylight_time` and `time_zone` source tables into the package. In the transform package, these tables are used to more precisely calculate business hour metrics ([#62](https://github.com/fivetran/dbt_zendesk/issues/62)). 

# dbt_zendesk_source v0.5.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_fivetran_utils`. The latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_zendesk_source v0.4.2
## Fixes
- Adjusted timestamp fields within staging models to explicitly cast the data type as `timestamp without time zone`. This fixes a Redshift error where downstream datediff and dateadd functions would result in an error if the timestamp fields are synced as `timestamp_tz`. ([#23](https://github.com/fivetran/dbt_zendesk_source/pull/23))

## Contributors
- @juanbriones ([#55](https://github.com/fivetran/dbt_zendesk/issues/55))


# dbt_zendesk_source v0.1.0 -> v0.4.1
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!
