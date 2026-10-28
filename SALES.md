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
| `filterColumn`, `filterValue` | Column ID and case-insensitive displayed-value substrings; repeat `filterValue` for OR matching (up to 25 values); supply both |
| `drilldownColumn`, `drilldownValue` | Column ID and exact, case-insensitive displayed values; repeat `drilldownValue` for OR matching (up to 25 values); narrows the returned page only, never `summary`; supply both |
| `sortBy`, `sortOrder` | Column ID and `asc`/`desc`; numeric and ISO date values sort before pagination |
| `dateColumn` | Column ID of a `date`/`datetime` column, such as Created Date or Close Date |
| `dateFrom`, `dateTo` | Inclusive `YYYY-MM-DD` bounds; either or both, and both require `dateColumn` |
| `amountColumn` | Currency/double/int/percent column ID for numeric comparisons; probability uses 0–100 units |
| `amountMin`, `amountMax` | Exclusive numeric bounds (greater than / less than); either or both require `amountColumn` |
| `offeringType`, `dealCategory`, `customerType` | Repeat each parameter for OR choices; fields combine with AND before summaries and pagination; omit for ALL |
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

### Multiple values and amount ranges (PM-6639)

Repeat a value parameter to OR its values, for example
`filterColumn=STAGE_NAME&filterValue=Proposal&filterValue=Contracts`, or
`drilldownColumn=STAGE_NAME&drilldownValue=Proposal&drilldownValue=Contracts`.
Single-value requests retain their existing matching behavior. Values are not
comma-split, so names containing commas still match as one value. At most 25
values of up to 200 characters each are accepted.

`amountColumn=AMOUNT&amountMin=100000` means strictly greater than 100,000.
`amountMax=200000` adds a strictly less than 200,000 upper bound. Bounds compare
underlying numeric values, never formatted currency labels; null and nonnumeric
cells cannot match. Amounts use the selected column's units without converting
currencies. Choose a converted column when a common currency is required.
A selected amount column without bounds does not filter. Bounds must be finite
numbers, with the lower bound less than the upper bound; missing, unknown or
nonnumeric columns and invalid ranges return 400. Zero is a valid bound.

Search, column-value OR matching, dates and amounts combine with AND before
summary aggregation and pagination. Stage drilldowns still narrow rows only,
leaving every stage in the already-filtered summary available for selection.
Deploy this API change before the matching Sales UI change.

### Pipeline category and probability filters (PM-6660)

The following independent dropdowns use exact matching against report column labels:

| Query parameter | Report column | Allowed values |
| --- | --- | --- |
| `offeringType` | Engagement Offering Type (or Offering Type) | Flexible Talent, AI Training, Crowd-Powered Outcomes, Crowd-Powered Innovation |
| `dealCategory` | Deal Category | Topcoder-Direct, Wipro-Direct, Wipro-Consumption, Wipro-Internal |
| `customerType` | New Customer, or Follow-on Business? (or Customer Type) | New Customer, New Project at Existing Customer, Extension to Existing Project, Others |

Each accepts one value or up to four repeated values, ORed within the field.
Omit a parameter for ALL; do not send the literal `ALL`. Invalid choices and
missing report columns return 400. Cell matching ignores case, surrounding
whitespace and hyphen/space differences (e.g. Wipro Direct equals Wipro-Direct).
Independent category filters combine with AND, search, column values, numeric
ranges and dates before summary aggregation, sorting and pagination. Stage
selection remains a separate drilldown after summaries. Stage is prioritized
within the three category summary slots so these fields cannot crowd it out.

`amountColumn=<probability column ID>&amountMin=60&amountMax=90` filters raw
probability values strictly between 60 and 90, using percentage points rather
than fractions. Numeric ranges support currency, double, int and percent types;
percent/int columns are not added to monetary aggregates. Existing exclusive
bounds, null handling, pagination and currency behavior are unchanged.

Deploy this API change before the PM-6660 Sales UI. Tests cover dropdown options
and validation, OR/AND matching, Salesforce spelling variants, combined
search/date/numeric filters, stage summaries/drilldowns, sorting, pagination,
clearing, empty matches, missing columns and probability boundary values.

### Drilldown (PM-6392)

`drilldownColumn`/`drilldownValue` narrow `rows`, `total` and `totalPages` to the
rows whose displayed value in that column equals any `drilldownValue` exactly, ignoring
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
| `groups[]` | Up to three (prioritizing Stage) `picklist`/`multipicklist`/`combobox`/`boolean` columns broken into `buckets[{label,count,total,amounts[]}]`, ordered by total then count, capped at 25 with the remainder in `otherBuckets` |

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

## Monthly dashboards (PM-6632)

`GET /v6/reports/sales-dashboard/:section` supplies the shared Sales and Reports
portal dashboards. Sections are `bookings`, `pipeline`, `revenue`, `payments`, `taas-payments`, `talent`, and
`gross-margin`; each loads independently. The dashboard guard permits human
Administrators/Talent Managers and machines with `reports:all`.

Optional query parameters:

- `portal=reports|sales` (default `reports`): Sales payment and talent charts include only
  linked customer work, excluding TaaS and internal Topcoder payments **before**
  totals, distinct-member counts, and top-five customer ranking. Reports preserves
  internal and unlinked payment scope. Both portals load TaaS separately through
  `taas-payments`, which includes all TaaS payments within the requested period.
- `dateBasis=close|created` (default `close`): bookings and pipeline date column.
- `groupBy=offeringType|dealCategory|customerType|stage`: selects a chart breakdown
  for bookings, pipeline or revenue. Stage is supported only for pipeline; other
  unsupported combinations return 400. All selected-dimension categories appear as
  series/table columns, including Unknown; none are merged into Other. Missing source
  dimensions omit the chart with an explicit notice. The UI defaults to Offering Type
  for won/revenue and Stage for pipeline, keeping independent choices per card.
  Grouping preserves fiscal bounds, full customer datasets and all category totals;
  it reuses cached snapshots and does not filter Salesforce records.
- `offeringType`, `dealCategory`, `customerType`: legacy API value filters; repeat for OR choices within each
  field; fields combine with AND before monthly aggregation. Omit for ALL. Applies
  to bookings, pipeline and revenue, including their returned customer datasets.
  `filterOptions` retains unfiltered choices so selecting a category does not hide
  alternatives. Missing selected fields return 400 instead of ignoring the filter.
  The PM-6672 follow-up UI sends `groupBy` instead of these value filters.
  Customer Type uses Pipeline's four categories in every card. Legacy “New Project
  to Existing Customer” values match the corrected “New Project at Existing Customer”.
- `startDate` / `endDate`: inclusive/exclusive UTC bounds, at most 24 months.
  Defaults are the latest six calendar months, including the current month.
  Without explicit dates, expected bookings and pipeline by
  stage instead span three months back through six months ahead.

Both saved Salesforce reports filter to `THIS_FISCAL_YEAR`, which would silently
empty charted months on the far side of a fiscal-year boundary. Each dashboard run
therefore replaces the saved standard date filter with a `CUSTOM` range covering
every charted month, padded by one day for the Run As user's timezone. Rows are
still bounded exactly to UTC months. The override applies to that execution only;
saved reports are never edited, and their other filters still apply (for example,
Bookings By Stage keeps excluding Lost and TaaS opportunities). Dashboard snapshots
are separate from the Sales page snapshot, cached for one minute per report and
window (at most 20 windows per instance), with the same coalescing and failure
cooldown.

Pipeline aggregates every row of its dashboard snapshot. The date filter uses
`CLOSE_DATE` or `CREATED_DATE`, matching `dateBasis`, so an overriding
`SALESFORCE_SALES_REPORT_ID` must be an Opportunity report that has both columns.
Amount and Expected Revenue prefer converted columns where available. Missing
Expected Revenue falls back to Amount × Probability / 100. Closed Won counts
`Won - SOW Signed`, the only won stage in Topcoder's org and the stage behind the
Sales page's Total WON SOW Signed card. `Won - Closed` and `Closed Won` also match,
for orgs that use them. PM-6667 removes Total Opportunity Size and puts Won - SOW
Signed bookings first. Expected bookings and Pipeline by stage exclude all won
stages before aggregation. Won amounts are also grouped into three monthly charts:
`won-offering` (Engagement Offering Type), `won-deal-category` (Deal Category), and
`won-customer-type` (New Customer or Follow-on Business / Customer Type). These
fields are resolved from report labels, ignoring a relationship prefix. Blank
categories remain Unknown; a missing category field omits its chart with a notice.
All won charts follow the selected date basis and use the same converted amounts.
The `bookings` section returns only the consolidated `closed-won` chart, using the
same cached pipeline snapshot. With `groupBy`, its series represent every category
in the chosen dimension. Pipeline returns matching amount and expected-amount
breakdowns, excluding won opportunities from both. Expected amounts retain the existing
Expected Revenue / Amount × Probability fallback. Without `groupBy`, legacy chart
responses are unchanged. The UI renders one full-width won card and one full-width
open-pipeline card with an Amount / Expected Amount switch and one Filter by selector each.
Incomplete reports, missing values and non-USD/mixed
currencies are surfaced as notices. No currency conversion is added.

The revenue report confirmed in the October 20 PM-6632 comment is
[Salesforce report `00O1K000009GxBtUAK`](https://topcoder.lightning.force.com/lightning/r/Report/00O1K000009GxBtUAK/view)
("Accounts Monthly revenue File"), and it is the default source. Its column IDs were
read from the report's `describe` metadata, and the defaults below apply only while
that report is used:

| Setting | Default for the confirmed report | Meaning |
| --- | --- | --- |
| `SALESFORCE_REVENUE_REPORT_ID` | `00O1K000009GxBtUAK` | Optional report override |
| `SALESFORCE_REVENUE_DATE_COLUMN` | `PSA_Revenue_Recognition__c.Date__c` (Date) | Date/datetime column that assigns the month |
| `SALESFORCE_REVENUE_AMOUNT_COLUMN` | `PSA_Revenue_Recognition__c.Amount__c` (Gross Amount) | Currency/double revenue column |
| `SALESFORCE_REVENUE_OFFERING_COLUMN` | Metadata label **Engagement Offering Type**, including `Project Stream:` prefix | Optional field-ID override for Revenue by offering |
| `SALESFORCE_REVENUE_CUSTOMER_COLUMN` | Metadata labels **Reporting Account**, then **End Customer** / **Subcontracting End Customer**, then **Customer** / **Customer Name**, then **Account Name** / **Account**, including relationship prefixes | Optional field-ID override for Revenue Customer-Wise |
| `SALESFORCE_REVENUE_CATEGORY_COLUMN` | Metadata label **Deal Category** | Optional field-ID override for Revenue by account category |
| `SALESFORCE_REVENUE_CUSTOMER_TYPE_COLUMN` | Joined from Opportunity (see below) | Optional direct field exposing Pipeline's four categories; added at execution time |
| `SALESFORCE_REVENUE_OPPORTUNITY_COLUMN` | Revenue Opportunity, falling back to Project Stream Opportunity | Optional lookup field ID for a custom report; used unless a direct customer-type field is configured |

An overridden report must set its own date and amount columns. Until it does, the
section returns an explicit pending notice; date and amount IDs are never inferred
from labels. Category fields use the business labels above unless explicitly configured.
Remove any old offering/category overrides pointing to Type or Account Category
when deploying PM-6667; those fields are no longer the default category sources. Configured date or amount columns that are missing, or have the wrong
type, return 502. A configured breakdown column the report lacks omits that chart
with a notice.

Revenue Customer Type is resolved through raw Opportunity IDs, using
`PSA_Revenue_Recognition__c.Opportunity__c`, then
`FK_Opportunity_Project_in_Appirio__c.Opportunity__c` when the direct lookup is absent.
These verified lookup fields are added to the report's detail columns for execution
only; the saved report is unchanged. The API reads `Opportunity.New_or_Follow_On__c`
through SOQL in batches of at most 200 distinct IDs, without an opportunity close-date
restriction: an older opportunity can recognize revenue this fiscal year. The existing
Salesforce integration identity must be able to read that field. Results are cached
with the revenue snapshot; lookup errors use the existing sanitized error/cooldown path.
The Yes/No `New Customer?` field is not used to infer the four categories. Missing links
or classifications stay in totals and appear as **Unknown** when grouped by Customer Type.
They never match a specific category when legacy value filters are supplied.
Custom reports can configure a direct four-category field or their Opportunity lookup;
otherwise the existing Customer Type metadata-label match applies.

The section uses **Revenue** in display copy (PM-6668), retaining the `revenue` route,
chart IDs and source field names for compatibility. With `groupBy`, it returns a single
`revenue` chart containing all categories of the chosen dimension, including customer types.
Without `groupBy`, it retains the legacy monthly totals and stacked breakdowns by engagement offering and deal category. Each breakdown keeps its five largest categories, merges the rest
into Other (when there are more than six), and shows blank values as Unknown.
For blank engagement offerings only, Opportunity/Project Name `TopGear` maps to
`TopGear Ops`, and `Multiple App Enhancement 5` / `Multiple App Enhancements 5`
maps to `Flexible Talent`. Populated offerings are never overwritten. These
corrections are applied before category ranking and monthly summation. Every row the report returns counts,
including the `Wipro Internal - Ignore` account category, so totals match the
Salesforce report and the breakdown shows that category separately. Amounts round
to cents. The report must expose detail rows, as the pipeline report does.

Revenue also returns optional `customerRevenue` with **all** customer names, using
the chart's `series` and `months` shape. It uses the same date, amount, fiscal-year
bounds and source notices as the revenue charts. Customer metadata matching uses
the labels above in priority order, with **Reporting Account** first (PM-6672).
Relationship prefixes such as `Project Stream:` are ignored when matching labels.
Lookup display labels supply names rather than raw Salesforce IDs. Account Category
is not a customer-name fallback. An explicit field ID takes precedence and does
not silently fall back when missing. If the report lacks the customer field, this
dataset is omitted with an unavailable notice, while the other revenue charts
remain usable. Blank names are retained as Unknown customer; equal names aggregate
together. All customers remain separate from Other regardless of their rank.
A valid report with no rows returns an empty customer dataset.

Payments return optional `customerPayments`, using the same shape for **every**
customer before top-five/Other grouping. Each series key identifies the client
ID/customer label pair. A blank subcontracting end-customer name falls back to
`Client.name`, preventing avoidable `Customer <id>` labels. Unnamed or unlinked customers in Reports remain
identifiable entries rather than being lost. The existing `payment-customer`
chart remains in the API for compatibility; the PM-6668 UI no longer renders it.

The UI's bottom Customer section renders these datasets as **Revenue Customer-Wise**
and **Goods Sold Customer-Wise**, respectively: customer rows, month columns,
annual customer totals, monthly totals and a grand total. **Annual** is the first
numeric column and **Total** is the first body row. The UI previews five customer
rows with an expand/collapse control; API datasets and displayed totals always retain
every customer. Currency chart tables also show
an Annual row and Total columns/tooltips. Count charts omit summed annual/series
totals because members can recur across months and categories. Deploy this API
companion before the PM-6672 UI; no database migration is required.

Topcoder Payments switches between amount and monthly distinct-member count using
one non-TaaS response. TaaS Payments has a separate amount chart based on the latest
payment version's platform `created_at`, excluding cancelled and non-payment winnings.
The SQL's fourth bound parameter selects TaaS-only versus non-TaaS rows before totals;
its third parameter retains the existing customer-work scope for Sales Topcoder
payments. TaaS is unscoped by customer in both portals.

Flexible talent uses `ENGAGEMENTS_DB_URL`. For `portal=sales`, the reporting DB
first resolves project IDs through `projects.projects.billingAccountId` → BillingAccount
→ Client. Internal Topcoder clients, Topcoder/TaaS end-customer labels and unlinked
projects are excluded. The resulting project allowlist is passed as a bound array
to the engagement query and filters assignments **before** distinct counts. An
empty list returns zero counts; Reports continues with unscoped counts. The
reporting connection must be able to read projects and billing accounts. It counts distinct members newly
assigned (durable `acceptedAt`, falling back to legacy `startDate`), completed
(`COMPLETED` assignment `endDate`), and ongoing at month end (now for the current
month). Completed and terminated history contributes to earlier ongoing months.
Selected/rejected offers do not count. Unknown assignment dates are not inferred
from mutable `updatedAt`.

Gross margin is **on hold** per the October 20 PM-6632 clarification. Neither
portal renders or requests it. The existing API endpoint remains available for
backward compatibility; its calculation is the arithmetic mean of stored
`payment.challenge_markup` × 100, grouped by payment creation month. All payment
categories/statuses participate in both portals. The latest payment version is
used, consistently with existing payment dashboards. Null markup is excluded
with an explicit count; a month without known markup remains null, not zero.
This is not the fee-to-revenue ratio shown in the draft attachment.

Regression coverage includes monthly aggregation, source configuration, snapshot
isolation, scope selection and actual PostgreSQL calculations. To run the SQL
fixtures, provision a **disposable** database named `sales_dashboard_test`, then:

```bash
nvm use
SALES_DASHBOARD_TEST_DB_URL=postgresql://user:password@localhost:5432/sales_dashboard_test pnpm test --runInBand
```

The SQL suite creates and drops its fixture schemas and is skipped without that
variable. No production or development data is required.

PM-6672 follow-up tests: `sales-dashboard.breakdowns.spec.ts` checks every dimension,
won/open separation, both date bases, expected weighting, full category visibility,
canonical customer labels, Unknown buckets, missing dimensions and unchanged customer totals.
