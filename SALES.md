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
| `sortBy`, `sortOrder` | Column ID and `asc`/`desc`; numeric and ISO date values sort before pagination |
| `refresh` | `true` to refresh, subject to the five-second minimum interval; default `false` |

Response fields: `reportId`, `reportName`, `columns[{id,label,dataType}]`,
`rows[{id,cells:[{label,value,currencyCode?}]}]`, `allData`, `sourceRowCount`,
`total`, `page`, `perPage`, `totalPages`, `refreshedAt`, `refreshAfterSeconds`.
Cells follow column order. Labels are plain text, never HTML. Currency values
retain their amount and currency code. Null values are preserved. Row IDs are
snapshot-local fact-map keys, not durable Salesforce record identifiers.
Grouping-only fields, including Stage in Bookings By Stage, precede the detail
columns and support the same filtering and sorting. Lookup names sort by their
displayed labels, while dates and currency amounts use underlying typed values.
HTML formulas are projected to text; Forecast Alert uses its image's alt label
without fetching a protected Salesforce image.

Filtering and sorting operate over the complete **received snapshot**, before
pagination. `total` is the matching received-row count; `sourceRowCount` is its
unfiltered count. Out-of-range pages clamp to the final available page. Empty
reports return zero rows and `totalPages: 0`, `page: 1`.

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
share an in-flight request; manual refresh has a five-second cooldown. No report
data is persisted. A failed refresh returns an error, with a five-second retry
cooldown, and never changes the last successful timestamp. The UI refreshes
visible pages every minute and on return to a visible tab; hidden tabs do not
poll. It displays stale-data status when a refresh fails.

OAuth and report requests time out after 15 seconds per attempt. Network
failures, HTTP 429 and 5xx retry up to three attempts with bounded backoff;
401 report responses renew OAuth once. Errors and logs omit tokens and upstream
response bodies. Validation returns 400, missing configuration 503, and upstream
failures 502. Authorization returns 401/403 before Salesforce is contacted.

Future reports can reuse `SalesforceReportsClient.runReport(reportId)` and the
metadata normalization pattern. Add explicit server-side report selection and
authorization for each; do not accept arbitrary report IDs under the sales scope.

Run `nvm use`, `pnpm lint`, `pnpm build` and `pnpm test --runInBand`.
