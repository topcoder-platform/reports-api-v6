# Sales and WIN integration (PM-6343)

Salesforce report `00O1K00000A7UGDUA3` is the source of truth. This module executes
the saved report with `includeDetails=true` and derives every column from report
metadata. It never creates, updates or deletes Salesforce records or reports.

## Authentication

- `GET /v6/reports/sales`: authenticated human Administrator or Talent Manager.
- `GET /v6/reports/win/sales`: **machine token with `reports:sales`**. Human
  administrator tokens and `reports:all` alone do not grant access.
- Register `reports:sales` on the identity provider's API resource and grant it
  to the WIN client before requesting a client-credentials token. Never place a
  WIN machine credential or Salesforce secret in the browser.

Both routes use the existing JWT authentication middleware, then independent
role/scope checks. Responses use `Cache-Control: private, no-store`.

## Server configuration

| Environment variable | Value |
| --- | --- |
| `SALESFORCE_API_CONSUMER_KEY` | Required connected-app consumer key, injected from secret storage |
| `SALESFORCE_API_CONSUMER_SECRET` | Required connected-app consumer secret, injected from secret storage |
| `SALESFORCE_LOGIN_URL` | Default `https://topcoder.my.salesforce.com` |
| `SALESFORCE_API_VERSION` | Default `65.0`, without the `v` prefix |
| `SALESFORCE_SALES_REPORT_ID` | Default `00O1K00000A7UGDUA3` |

Enable the connected app's OAuth Client Credentials Flow and configure a **Run
As user** with API access, permission to run reports, report-folder access, and
access to the report's underlying objects/fields. The OAuth error `no client
credentials user enabled` means this Run As setup is missing. The app starts
without these settings, but Sales requests return 503 until configured.

For the current dev deployment convention, inject the variables from secure SSM
parameters under `/config/reports-api-v6/appvar/`. Do not commit real values.

## Query and response contract

Both endpoints accept the same query parameters:

| Parameter | Meaning |
| --- | --- |
| `page`, `perPage` | One-based page (default 1); page size 1–200 (default 25) |
| `search` | Case-insensitive substring across all displayed cells, up to 200 characters |
| `filterColumn`, `filterValue` | Column ID and case-insensitive displayed-value substring; supply both |
| `drilldownColumn`, `drilldownValue` | Column ID and exact, case-insensitive displayed value; narrows the returned page only, never `summary`; supply both |
| `sortBy`, `sortOrder` | Column ID and `asc`/`desc`; numeric and ISO date values sort before pagination |
| `dateColumn` | Column ID of a `date`/`datetime` column, such as Created Date or Close Date |
| `dateFrom`, `dateTo` | Inclusive `YYYY-MM-DD` bounds; either or both, and both require `dateColumn` |
| `refresh` | `true` to refresh, subject to the one-minute minimum interval; default `false` |

Response fields: `reportId`, `reportName`, `columns[{id,label,dataType}]`,
`rows[{id,cells:[{label,value,currencyCode?}]}]`, `allData`, `sourceRowCount`,
`total`, `page`, `perPage`, `totalPages`, `refreshedAt`, `refreshAfterSeconds`,
`summary`.
Cells follow column order. Labels are plain text, never HTML. Currency values
retain their amount and currency code. Null values are preserved. Row IDs are
snapshot-local fact-map keys, not durable Salesforce record identifiers.
Grouping-only fields, including Stage in Bookings By Stage, precede the detail
columns and support the same filtering and sorting. Lookup names sort by their
displayed labels, while dates and currency amounts use underlying typed values.
HTML formulas are projected to text; Forecast Alert uses its image's alt label
without fetching a protected Salesforce image.

Filtering and sorting operate over the complete **received snapshot**, before
pagination. `total` is the returned received-row count, after any drilldown;
`sourceRowCount` is its unfiltered count. Out-of-range pages clamp to the final
available page. Empty reports return zero rows and `totalPages: 0`, `page: 1`.

### Drilldown (PM-6392)

`drilldownColumn`/`drilldownValue` narrow `rows`, `total` and `totalPages` to the
rows whose displayed value in that column equals `drilldownValue` exactly, ignoring
case and surrounding whitespace. Unlike `filterColumn`/`filterValue` it is applied
**after** aggregation, so `summary` continues to describe the whole filtered set.
That lets a dashboard drill into one `summary.groups[].buckets[]` entry — a pipeline
stage, say — while every bucket stays on screen to be clicked next. A drilldown
therefore makes `summary.recordCount` larger than `total`. Supplying one half of the
pair, or a column ID the report does not define, returns `400`.

### Date range filtering (PM-6364)

`dateColumn` selects which date the range applies to, so the same report answers
both pipeline generation (Created Date) and revenue realization (Close Date)
questions. Bounds are inclusive and combine with `search` and
`filterColumn`/`filterValue`. Selecting a `dateColumn` with no bound is a no-op,
which lets a client keep the field selected while the range is empty.

Comparison uses each cell's **underlying** Salesforce value, never its localized
label: date and datetime values arrive as ISO 8601, and a datetime keeps the
report's own offset, so its day matches the day the report displays. A row whose
date cell is null or unparseable cannot satisfy a range and is excluded rather
than counted. `400` responses cover a bound without `dateColumn`, `dateFrom`
after `dateTo`, a `dateColumn` that is not a `date`/`datetime` column, and any
bound that is not a real `YYYY-MM-DD` calendar day (`2026-02-30` and non-leap
`2027-02-29` are rejected; datetimes and offsets are not accepted as bounds).

### Summary aggregates (PM-6364)

`summary` describes **every matching row in the snapshot**, not the returned
page, so counts and totals stay correct under pagination:

| Field | Meaning |
| --- | --- |
| `recordCount` | Matching rows; equal to `total` unless a drilldown narrows the page |
| `amounts[]` | One entry per `currency`/`double` column: `columnId`, `label`, `total`, contributing `count`, and `currencyCode` when the contributing rows agree |
| `groups[]` | Up to three `picklist`/`multipicklist`/`combobox`/`boolean` columns broken into `buckets[{label,count,total,amounts[]}]`, ordered by total then count, capped at 25 with the remainder in `otherBuckets` |

Bucket `total` uses the report's first amount column, named in `amountColumnId`,
while `buckets[].amounts[]` repeats every amount column inside the bucket using the
same entry shape and order as `summary.amounts`, so a breakdown can show a stage's
Amount beside its Expected Revenue.
Totals round to cents so repeated floating-point addition cannot leak artifacts
into displayed currency. A `currencyCode` is omitted when contributing rows
declare different currencies; rows that declare none cannot contradict the rest.
Because aggregates cover received rows only, `allData: false` limits them
exactly as it limits `total`.

Salesforce Analytics limits detail responses to 2,000 rows. `allData: false`
explicitly flags an incomplete upstream snapshot; the UI warns that search,
filtering and counts apply only to returned rows. It must never be treated as a
complete export by WIN. Refine the saved Salesforce report if the limit is hit;
this API does not replace report semantics with a guessed SOQL query. Joined
reports and reports without details are rejected. See Salesforce's
[Reports API limits](https://help.salesforce.com/s/articleView?id=rd_reports_dashboards_limits.htm&language=en_US&type=5)
and [report execution contract](https://developer.salesforce.com/docs/analytics/salesforce-analytics-rest-api/guide/sforce-analytics-rest-api-getreportrundata.html).

## Freshness, failures and extension

One in-memory snapshot per service instance lasts 60 seconds. Concurrent reads
share an in-flight request; manual refresh uses the same one-minute interval. No report
data is persisted. A failed refresh returns an error, with a one-minute retry
cooldown, and never changes the last successful timestamp. The UI refreshes
visible pages every minute and on return to a visible tab; hidden tabs do not
poll. It displays stale-data status when a refresh fails.

OAuth and report requests time out after 15 seconds per attempt. Network
failures, HTTP 429 and 5xx retry up to three attempts with bounded backoff;
401 report responses renew OAuth once. A Salesforce synchronous report quota error
pauses report calls from that instance for five minutes. Warnings include the HTTP
status, bounded Salesforce error code/message, configured report ID, and Salesforce
request ID when present; tokens and full upstream response bodies are omitted.
Validation returns 400, missing configuration 503, and upstream
failures 502. Authorization returns 401/403 before Salesforce is contacted.

Future reports can reuse `SalesforceReportsClient.runReport(reportId, metadata?, includeDetails?)` and the
metadata normalization pattern. Add explicit server-side report selection and
authorization for each; do not accept arbitrary report IDs under the sales scope.

Run `nvm use`, `pnpm lint`, `pnpm build` and `pnpm test --runInBand`.

## Historical stage progression (CORE-2658)

`GET /v6/reports/sales/progression` is a separate human-only Admin/Talent Manager
endpoint. It accepts required inclusive `dateFrom` and `dateTo` (`YYYY-MM-DD`,
maximum 366 days including both endpoints), and optional exact `fromStage` and
`toStage` values from the configured stage lists. Unknown stages and invalid dates return 400. Unknown parameters are stripped by
the global validation pipe; callers cannot choose report IDs or metadata. The existing pipeline and WIN endpoints are unchanged.

The response contains the applied dates/stages, `timeZone`, `stages`, `openStages`,
`wonStages`, `refreshedAt`, `refreshAfterSeconds`, and two summaries:

- `progressed`: distinct `opportunities`, total qualifying `transitions`, and
  `breakdown[{fromStage,toStage,opportunities,transitions}]` for forward movement.
- `won`: the same shape for entry from a non-won stage into a won stage.

Forward movement means a move from a configured open stage to a later configured
open stage or any configured won stage. Skipped stages count as one transition.
Regressions, reopenings, initial assignments, and lost/other/unknown source stages
are excluded from progression. Open stage order is explicit, never inferred from
alphabetic order, probability, or numeric prefixes. Won stages are terminal and
are not ordered against each other. A move between won stages does not count as
a win. A lost-to-won move counts as a win but not progression. Initial assignments
with an empty From Stage are excluded from both metrics. A reopened opportunity
that wins again contributes another transition, but still one distinct opportunity
in the selected period. Cards overlap and must not be added together.

### Salesforce setup required before validation

1. Create a **separate standard Opportunity History report**, accessible to the
   connected app's OAuth Run As user. Keep the existing pipeline report unchanged.
   Include Opportunity ID, From Stage, To Stage and history Last Modified fields.
   Use the history record's date, not the opportunity's current Last Modified,
   Last Stage Change, Created or Close Date. Confirm older history exists.
2. Set the intended reporting scope (typically All Opportunities and any status).
   Remove current-stage, current-close-date, row-limit, or other restrictions that
   would inadvertently exclude historical wins or reopened opportunities. Existing
   saved custom filters and their Boolean logic remain in force. Do not use a
   joined report. The API does not create or edit the saved report or records.
3. Read `/analytics/reports/{reportId}/describe` to obtain the exact API column
   IDs. Configure the Opportunity ID field, **not the opportunity name**, for the
   distinct count. Ensure it supports filtering and unique counts. Configure the
   history Last Modified column as the report's standard date-filter column.
4. Inject `SALESFORCE_SALES_HISTORY_CONFIG` as a JSON string. The example below
   uses **placeholder report/column IDs**; replace them using the actual report
   metadata and exact stage values in the org. `openStages` is ordered from
   earliest to latest; `wonStages` is an unordered set. Optional `otherStages`
   exposes lost/other stages in the UI filters without treating them as progression.
   Stage lists must be disjoint; commas/quotes in stage names are not supported by
   this integration's multi-value report filters. `timeZone` must be an IANA name
   matching the OAuth Run As user's Salesforce timezone. Salesforce interprets
   the inclusive calendar dates; the API does not apply a browser-timezone offset.

```json
{
  "reportId": "REPLACE_WITH_HISTORY_REPORT_ID",
  "dateColumn": "REPLACE_WITH_HISTORY_DATE_COLUMN",
  "opportunityIdColumn": "REPLACE_WITH_OPPORTUNITY_ID_COLUMN",
  "fromStageColumn": "REPLACE_WITH_FROM_STAGE_COLUMN",
  "toStageColumn": "REPLACE_WITH_TO_STAGE_COLUMN",
  "openStages": ["Prospecting", "Qualification", "Proposal", "Contracts", "Closing"],
  "wonStages": ["Won - SOW Signed"],
  "otherStages": ["Closed Lost"],
  "timeZone": "America/New_York"
}
```

5. Compare the API with the report for a known historical period, including
   several moves by one opportunity, a regression, a reopened win, changes on
   each period boundary, and a period with more than 2,000 history events. Check
   that the unique-count field identifies opportunities, the history timestamp
   is the date being filtered, and the displayed timezone matches the Run As user.
   Historical data and live report permissions require validation in the org;
   synthetic tests cannot establish them.

### Execution and completeness

The service describes the saved report, then runs it twice via POST execution
metadata overrides with `includeDetails=false`. Each run sets a custom standard
date filter, From Stage/To Stage summary groupings, `RowCount`, and
`u!<opportunityIdColumn>` (Salesforce's unique count). Execution-only predicates
select forward moves or entries into won. A nonempty Opportunity ID filter avoids
counting null as a distinct opportunity. Saved custom filters are combined as
`(saved logic) AND (requested filters) AND (movement predicate)`.

The service reads `factMap` aggregates, including the independent `T!T` distinct
grand total. It never sums group distinct counts into a grand total, aggregates
truncated detail rows, or reconstructs opportunity states. Missing, malformed,
inconsistent or incomplete (`allData !== true`) summaries return 502; there is
no partial-success response. If a period cannot return a complete summary, narrow
the period or review the report setup. Reports without details are valid here.

Salesforce permits at most 20 custom filters. Forward movement uses two filters
per open stage, one nonempty-ID filter, plus saved and optional user filters;
win entry uses four plus saved/user filters. Configurations exceeding the limit
return 503 before report execution. Keep the saved report's filters minimal.

A bounded per-instance in-memory cache stores up to 50 responses/failures for
60 seconds, keyed by configuration and all applied filters. Concurrent identical
requests coalesce; at most five distinct period queries run at once. Repeated
failures have the same cooldown. Existing client retries, token renewal and
Salesforce quota backoff apply to metadata and execution requests. There is no
database persistence, background snapshot collection, or new migration.

References: [Opportunity History report](https://help.salesforce.com/articleView?id=reports_opp_history.htm&language=en_US&type=0),
[report execution overrides](https://developer.salesforce.com/docs/analytics/salesforce-analytics-rest-api/guide/sforce-analytics-rest-api-getreportrundata.html),
[unique-count aggregates](https://developer.salesforce.com/docs/analytics/salesforce-analytics-rest-api/guide/analytics-api-report-list-resource.html).
