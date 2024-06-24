# dbt_zendesk_source v0.11.2

[PR #49](https://github.com/fivetran/dbt_zendesk_source/pull/49) includes the following updates:

## Feature Updates
- Adds passthrough column support for `USER` and `ORGANIZATION`. 
  - Using the new `zendesk__user_passthrough_columns` and `zendesk__organization_passthrough_columns` variables, you can include custom columns from these source tables in their respective staging models. See [README](https://github.com/fivetran/dbt_zendesk_source?tab=readme-ov-file#add-passthrough-columns) for more details on how to configure.
- Also updated the format of the pre-existing `TICKET` passthrough column variable, `zendesk__ticket_passthrough_columns`, to align with the newly added passthrough variables delineated above.
  - Previously, you could only provide a list of custom fields to be included in `stg_zendesk__ticket`. Now, you have the option to provide an `alias` and `transform_sql` clause to be applied to each field (see [README](https://github.com/fivetran/dbt_zendesk_source?tab=readme-ov-file#add-passthrough-columns) for more details).
  - **Note**: the package is and will continue to be backwards compatible with the old list-format.

# dbt_zendesk_source v0.11.1

[PR #48](https://github.com/fivetran/dbt_zendesk_source/pull/48) includes the following updates:

## Feature Updates
- Adds the `phone` field to `stg_zendesk__user` and ensures it is a `string` if the column is not found in your source data.
- Adds documentation for `user` fields that were previously missing yml descriptions.

# dbt_zendesk_source v0.11.0

[PR #46](https://github.com/fivetran/dbt_zendesk_source/pull/46) includes the following updates:

## 🚨 Breaking Change Bug Fixes 🚨
- Updated the following staging models to leverage the `{{ dbt.type_timestamp() }}` macro on timestamp fields in order to ensure timestamp with no timezone is used in downstream models. This update will cause timestamps to be converted to have no timezone. If records were reported as timezone timestamps before, this will result in converted timestamp records.
  - `stg_zendesk__ticket`
  - `stg_zendesk__ticket_comment`
  - `stg_zendesk__ticket_field_history`
  - `stg_zendesk__ticket_form_history`
  - `stg_zendesk__ticket_schedule`
  - `stg_zendesk__user`

## Documentation Updates
- Updated "Zendesk" references within the README to now refer to "Zendesk Support" in order to more accurately reflect the name of the Fivetran Zendesk Support Connector.

# dbt_zendesk_source v0.10.1
[PR #43](https://github.com/fivetran/dbt_zendesk_source/pull/43) introduces the following updates:

## Feature Updates
- Added the `internal_user_criteria` variable, which can be used to mark internal users whose `USER.role` may have changed from `agent` to `end-user` after they left your organization. This variable accepts SQL that may reference any non-custom field in `USER`, and it will be wrapped in a `case when` statement in the `stg_zendesk__user` model.
  - Example usage:
```yml
# dbt_project.yml
vars:
  zendesk_source:
    internal_user_criteria: "lower(email) like '%@fivetran.com' or external_id = '12345' or name in ('Garrett', 'Alfredo')" # can reference any non-custom field in USER
```
  - Output: In `stg_zendesk__user`, users who match your criteria and have a role of `end-user` will have their role switched to `agent`. This will ensure that downstream SLA metrics are appropriately calculated.

## Under the Hood
- Updated the way we dynamically disable sources. Previously, we used a custom `meta.is_enabled` flag, but, since we added this, dbt-core introduced a native `config.enabled` attribute.  We have opted to use the dbt-native config instead.
- Updated the pull request [templates](/.github).
- Included auto-releaser GitHub Actions workflow to automate future releases.

# dbt_zendesk_source v0.10.0
[PR #42](https://github.com/fivetran/dbt_zendesk_source/pull/42) introduces the following updates: 

# 🚨 Breaking Change (Snowflake users) 🚨
- We have changed the identifier logic in `src_zendesk.yml` to account for `group` being both a Snowflake reserved word and a source table. Snowflake users will want to execute a `dbt run --full-refresh` before using the new version of the package.

# 🎉 Feature Update 🎉 
- Updated our `tmp` models to utilize the `dbt_utils.star` macro rather than the select * function. This removes Snowflake issues that arise when a source's dimensions change. 

## 🔎 Under the Hood 🔎 
- Updates to the seed files and seed file configurations for the package integration tests to ensure updates are properly tested.

# dbt_zendesk_source v0.9.0

# 🚨 New Schedule Holiday Table 🚨
- Adding the `schedule_holiday` source table so that downstream models that involve business minutes calculations will accurately take holiday time into account. This staging model may be disabled by setting `using_schedules` to false. ([#92](https://github.com/fivetran/dbt_zendesk/issues/92))

## Under the Hood:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([#37](https://github.com/fivetran/dbt_zendesk_source/pull/37))
- Updated the pull request [templates](/.github). ([#37](https://github.com/fivetran/dbt_zendesk_source/pull/37))

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
