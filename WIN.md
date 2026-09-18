# WIN showcase export

`GET /v6/reports/WIN` returns showcase posts explicitly shared using **Send to WIN**.
Access requires a JWT with the `reports:win` scope, or an authenticated human with
the Administrator or Talent Manager role. The general `reports:all` scope alone
does not grant access. Role and scope normalization follow the existing reports
permission checks. The report is also listed in the report directory for these callers.

## Request and response

Optional query parameters:

| Parameter | Default | Meaning |
| --- | --- | --- |
| `projectId` | all projects | Positive numeric string, up to 18 digits |
| `page` | 1 | Page number, 1–1,000,000 |
| `perPage` | 100 | Page size, 1–100 |

```http
GET /v6/reports/WIN?projectId=123&page=1&perPage=100
Authorization: Bearer <JWT>
```

The response is `{ "data": [...], "total": 0, "page": 1, "perPage": 100 }`.
`total` counts all matches, including when a later page is empty. Rows are ordered
by post ID. Repeat requests read current records; this endpoint does not mark
records as delivered or push them to another service.

Each row contains all stored showcase fields, including `title`, `type`,
`challenge`, `content` (The Solution), `businessImpact`, `keyWin`, `currentStatus`,
`owner`, `sendToWin`, lifecycle `status`, `challengeIds`, and publication/audit
metadata. `industries`, `categories`, and `media` are arrays with their stored
metadata. Media URLs are the stored asset URLs. `challengeMetadata` includes linked
challenge names, submission/registration counts, track, skills, and submitter countries.

`customer`, `smu`, `smuOther`, and `dealCloseDate` come from the current project
details, so changes made in either Work form appear immediately. For `smu: "Others"`,
use `smuOther` as the custom SMU value. `dealCloseDate` is a date-only string.
`project` contains the project's stored scalar fields and JSON metadata. Bigint
post/project/taxonomy/media IDs are serialized as strings. Missing optional fields
may be null on older posts.

Opted-in drafts and published posts are included. Opted-out and archived posts,
and posts belonging to deleted projects, are excluded. Invalid query parameters
return 400; missing authentication returns 401; insufficient access returns 403.

## Deployment and tests

The reporting `DATABASE_URL` needs read access to the `projects` schema including
the showcase taxonomy/media tables, plus `challenges`, `resources`, `members`,
and `skills` for linked challenge metadata. First deploy the projects-api-v6 migration
`20260916000000_showcase_win_metadata` and its application changes, then deploy
this endpoint and the platform-ui changes. No WIN push URL is required.

After `nvm use`, run `pnpm lint`, `pnpm build`, and
`pnpm test --runInBand win report-directory permissions.util`. Set
`WIN_TEST_DATABASE_URL` to a disposable PostgreSQL database with the projects API
migrations applied to run the real SQL tests. Use a database containing only the
projects schema; the tests create minimal reference-schema fixtures for challenges,
resources, members and skills. All fixtures run in a transaction and are rolled back.
