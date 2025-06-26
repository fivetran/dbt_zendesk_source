# dbt_zendesk_source v0.18.0

[PR #71](https://github.com/fivetran/dbt_zendesk_source/pull/71) includes the following updates:

## Breaking Change for dbt Core < 1.9.6

> *Note: This is not relevant to Fivetran Quickstart users.*

Migrated `freshness` from a top-level source property to a source `config` in alignment with [recent updates](https://github.com/dbt-labs/dbt-core/issues/11506) from dbt Core. This will resolve the following deprecation warning that users running dbt >= 1.9.6 may have received:

```
[WARNING]: Deprecated functionality
Found `freshness` as a top-level property of `zendesk` in file
`models/src_zendesk.yml`. The `freshness` top-level property should be moved
into the `config` of `zendesk`.
```

**IMPORTANT:** Users running dbt Core < 1.9.6 will not be able to utilize freshness tests in this release or any subsequent releases, as older versions of dbt will not recognize freshness as a source `config` and therefore not run the tests.

If you are using dbt Core < 1.9.6 and want to continue running Zendesk Support freshness tests, please elect **one** of the following options:
  1. (Recommended) Upgrade to dbt Core >= 1.9.6
  2. Do not upgrade your installed version of the `zendesk_source` package. Pin your dependency on v0.17.0 in your `packages.yml` file.
  3. Utilize a dbt [override](https://docs.getdbt.com/reference/resource-properties/overrides) to overwrite the package's `zendesk` source and apply freshness via the previous release top-level property route. This will require you to copy and paste the entirety of the previous release `src_zendesk.yml` file and add an `overrides: zendesk_source` property.

## Under the Hood
- Updates to ensure integration tests use latest version of dbt.

# dbt_zendesk_source v0.17.0
[PR #68](https://github.com/fivetran/dbt_zendesk_source/pull/68) includes the following updates from pre-release `v0.17.0-a1`:

## Breaking Changes
- Renamed the enablement variable for the `stg_zendesk__audit_log` model from `using_schedule_histories` to `using_audit_log`. This supports the audit log's expanded use for both schedule and user role histories downstream. Use `using_schedule_histories` and `using_user_role_histories` to control downstream feature inclusion. 
  - See the `v0.23.0 dbt_zendesk` [release notes](https://github.com/fivetran/dbt_zendesk/releases/tag/v0.23.0) for more details.

## Under the Hood
- Updated seed for `audit_log_data` to add support role changes.

# dbt_zendesk_source v0.17.0-a1
[PR #68](https://github.com/fivetran/dbt_zendesk_source/pull/68) includes the following update:

- Renamed the enablement variable from `using_schedule_histories` to `using_audit_log` in `stg_zendesk__audit_log` to support its expanded use for both schedule and user role histories. Use `using_schedule_histories` and `using_user_role_histories` to control downstream model inclusion.

# dbt_zendesk_source v0.16.1

## Under the Hood
- Prepends `materialized` configs in the package's `dbt_project.yml` file with `+` to improve compatibility with the newer versions of dbt-core starting with v1.10.0. ([PR #69](https://github.com/fivetran/dbt_zendesk_source/pull/69))
- Updates the package maintainer pull request template. ([PR #70](https://github.com/fivetran/dbt_zendesk_source/pull/70))

## Contributors
- [@b-per](https://github.com/b-per) ([PR #69](https://github.com/fivetran/dbt_zendesk_source/pull/69))

# dbt_zendesk_source v0.16.0

This release includes the following updates from pre-releases `v0.16.0-a1` and `v0.16.0-a2`.

## Schema Updates

**4 total changes • 0 possible breaking changes**
| **Data Model** | **Change type** | **Old name** | **New name** | **Notes** |
| ---------------- | --------------- | ------------ | ------------ | --------- |
| [stg_zendesk__ticket_chat](https://fivetran.github.io/dbt_zendesk_source/#!/model/model.zendesk_source.stg_zendesk__ticket_chat) | New Model |   |   |  Uses `ticket_chat` source table  |
| [stg_zendesk__ticket_chat_tmp](https://fivetran.github.io/dbt_zendesk_source/#!/model/model.zendesk_source.stg_zendesk__ticket_chat_tmp) | New Temp Model |   |   |  Uses `ticket_chat` source table  |
| [stg_zendesk__ticket_chat_event](https://fivetran.github.io/dbt_zendesk_source/#!/model/model.zendesk_source.stg_zendesk__ticket_chat_event) | New Model |   |   | Uses `ticket_chat_event` source table   |
| [stg_zendesk__ticket_chat_event_tmp](https://fivetran.github.io/dbt_zendesk_source/#!/model/model.zendesk_source.stg_zendesk__ticket_chat_event_tmp) | New Temp Model |   |   | Uses `ticket_chat_event` source table   |

## Feature Updates
- Incorporated the `ticket_chat` and `ticket_chat_event` source tables to capture tickets created via `chat` and `native_messaging` channels in downstream SLA policy transformations. ([PR #63](https://github.com/fivetran/dbt_zendesk_source/pull/63))
- Handled `actor_id` in `ticket_chat_event` having inconsistent formatting, so that we can safely cast it as a bigint. Typically, `actor_id` just contains the ID, but it may also look like `agent:<#######>`. ([PR #63](https://github.com/fivetran/dbt_zendesk_source/pull/63))
- Added the `using_ticket_chat` variable to enable/disable the `ticket_chat` and `ticket_chat_event` staging models and downstream transformations. ([PR #63](https://github.com/fivetran/dbt_zendesk_source/pull/63))
  - For Fivetran Quickstart users, `using_ticket_chat` is dynamically set based on the presence of the `ticket_chat` and `ticket_chat_event` source tables.
  - For other users, `using_ticket_chat` is set to **False** by default. To change this and enable the ticket chat models, add the following configuration (see [README](https://github.com/fivetran/dbt_zendesk_source?tab=readme-ov-file#step-4-enabledisable-models-for-non-existent-sources) for details).

```yml
vars:
  zendesk_source:
    using_ticket_chat: True
  zendesk: # if using Zendesk transformation package
    using_ticket_chat: True
```

## Documentation
- Corrected references to connectors and connections in the README. ([#PR 61](https://github.com/fivetran/dbt_zendesk_source/pull/61))
- Corrected DAG link in the README. ([PR #62](https://github.com/fivetran/dbt_zendesk_source/pull/62))

## Contributors
- [@segoldma](https://github.com/segoldma) ([PR #62](https://github.com/fivetran/dbt_zendesk_source/pull/62))

# dbt_zendesk_source v0.16.0-a2
- Handles `actor_id` in `ticket_chat_event` having inconsistent formatting, so that we can safely cast it as a bigint. Typically, `actor_id` just contains the ID, but it may also look like `agent:<#######>`. ([PR #63](https://github.com/fivetran/dbt_zendesk_source/pull/63))

# dbt_zendesk_source v0.16.0-a1

## New Features
- Incorporated the `ticket_chat` and `ticket_chat_event` source tables to capture tickets created via `chat` and `native_messaging` channels in downstream SLA policy transformations. ([PR #63](https://github.com/fivetran/dbt_zendesk_source/pull/63))
- Added the `using_ticket_chat` variable to enable/disable the `ticket_chat` and `ticket_chat_event` staging models and downstream transformations. ([PR #63](https://github.com/fivetran/dbt_zendesk_source/pull/63))
  - For Fivetran Quickstart users, `using_ticket_chat` is dynamically set based on the presence of the `ticket_chat` and `ticket_chat_event` source tables.
  - For other users, `using_ticket_chat` is set to **False** by default. To change this and enable the ticket chat models, add the following configuration (see [README](https://github.com/fivetran/dbt_zendesk_source?tab=readme-ov-file#step-4-enabledisable-models-for-non-existent-sources) for details).

```yml
vars:
  zendesk_source:
    using_ticket_chat: True
  zendesk: # if using Zendesk transformation package
    using_ticket_chat: True
```
> Note: If `using_ticket_chat` is enabled, this update increases the model count of the package by **4 models**.

## Documentation
- Corrected references to connectors and connections in the README. ([#PR 61](https://github.com/fivetran/dbt_zendesk_source/pull/61))
- Corrected DAG link in the README. ([PR #62](https://github.com/fivetran/dbt_zendesk_source/pull/62))

## Contributors
- [@segoldma](https://github.com/segoldma) ([PR #62](https://github.com/fivetran/dbt_zendesk_source/pull/62))

# dbt_zendesk_source v0.15.0
[PR #60](https://github.com/fivetran/dbt_zendesk_source/pull/60) includes the following updates:

## Under the Hood
- (Affects Redshift only) Updates the `union_zendesk_connections` macro to use a limit 1 instead of limit 0 for empty tables.
  - When a table is empty, Redshift ignores explicit data casts and will materialize every column as a `varchar`. Redshift users may experience errors in downstream transformations as a consequence.
  - For each staging model, if the source table is not found, the package will create a empty table with 0 rows for non-Redshift warehouses and a table with 1 all-`null` row for Redshift destinations. The 1 row will ensure that Redshift will respect the package's datatype casts.

## Documentation Update
- Moved badges at top of the README below the H1 header to be consistent with popular README formats.

# dbt_zendesk_source v0.14.2
[PR #59](https://github.com/fivetran/dbt_zendesk_source/pull/59) includes the following updates:

## New Features
- Introduced new config variables for whether `brand` or `organization` tables are present, allowing customers to either enable or disable the respective staging and tmp  models:
  - Updated `stg_zendesk__brand` (and upstream `tmp` model) with the new `using_brands` config variable.  
  - Updated `stg_zendesk__organization` (and upstream `tmp` model) with the new `using_organizations` config variable.
  - Updated `stg_zendesk__organization_tag` (and upstream `tmp` model) with the new `using_organizations` config variable, as the `organization_tag` source table can be disabled in some situations, while `organization` is not. Thus anything that is disabled/enabled by `using_organization_tags` should contain both the `using_organization_tags` AND `using_organizations` variables. 

## Under the Hood
- Updated our Buildkite model run script to ensure we test for when `using_brands` and `using_organizations` is set to either true or false. 

## Documentation Updates
- Added enabled config variables to `brand`, `organization` and `organization_tag` in the `src_zendesk.yml` models. 
- [Updated README](https://github.com/fivetran/dbt_zendesk_source?tab=readme-ov-file#step-4-enabledisable-models-for-non-existent-sources) with instructions on how to disable `brand` and `organization` sources.

# dbt_zendesk_source v0.14.1

[PR #58](https://github.com/fivetran/dbt_zendesk_source/pull/58) includes the following update:

## Bug Fixes
- In v0.14.0 (or [v0.19.0](https://github.com/fivetran/dbt_zendesk/releases/tag/v0.19.0) of the transform package), Snowflake users may have seen `when searching for a relation, dbt found an approximate match` errors when running the `stg_zendesk__group_tmp` model. The issue stemmed from the `adapter.get_relation()` logic within the `union_zendesk_connections` macro, which has now been updated to resolve the error.

# dbt_zendesk_source v0.14.0
[PR #44](https://github.com/fivetran/dbt_zendesk_source/pull/44) includes the following updates:

## Feature Update: Run Package on Unioned Connectors
- This release supports running the package on multiple Zendesk sources at once! See the [README](https://github.com/fivetran/dbt_zendesk_source?tab=readme-ov-file#step-3-define-database-and-schema-variables) for details on how to leverage this feature. 

> Please note: This is a **Breaking Change** in that we have a added a new field, `source_relation`, that points to the source connector from which the record originated.

## Documentation
- Added missing documentation for staging model columns.

# dbt_zendesk_source v0.13.0
[PR #55](https://github.com/fivetran/dbt_zendesk_source/pull/55) includes the following updates:

## Breaking Changes
- Introduced the `stg_zendesk__audit_log` table for capturing schedule changes from Zendesk's audit log.
  - This model is disabled by default, to enable it set variable `using_schedule_histories` to `true` in your `dbt_project.yml`.
  - While currently used for schedule tracking, this table has possible future applications, such as tracking user changes.

## Features
- Updated the `stg_zendesk__schedule_holidays` model to allow users to disable holiday processing (while still using schedules) by setting `using_holidays` to `false`.
- Added field-level documentation for the `stg_zendesk__audit_log` table.

## Under the Hood Improvements
- Added seed data for `audit_log` to enhance integration testing capabilities.

# dbt_zendesk_source v0.12.0
[PR #53](https://github.com/fivetran/dbt_zendesk_source/pull/53) includes the following updates:
## Breaking changes
- Added field `_fivetran_deleted` to the following models for use downstream:
  - `stg_zendesk__ticket`
  - `stg_zendesk__ticket_comment`
  - `stg_zendesk__user`
  - If you have already added `_fivetran_deleted` as a passthrough columns using the `zendesk__ticket_passthrough_columns` or `zendesk__user_passthrough_columns` vars, you will need to remove or alias this field from the variable to avoid duplicate column errors.

## Documentation
- Updated documentation to include `_fivetran_deleted`.

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
