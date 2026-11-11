# First-time submitter SQL regression

The public Design report failed with HTTP 500 when a submission's memberId was an
M2M client identifier (`…@clients`). Both first-time-submitter queries cast that
field to bigint. Guard the cast inside CASE so PostgreSQL predicate reordering
cannot evaluate it for non-member or out-of-range identifiers. Valid members,
earliest submissions, the three-month window, and maximum ratings are unchanged.

Run the actual queries against PostgreSQL 16 with:

```sh
STATISTICS_PSQL_COMMAND='psql postgresql://localhost/test_database' \
  python3 -m unittest discover -s test/statistics
```

The test uses unique fixture schemas in a rolled-back transaction. It includes
service accounts, null/empty/oversized identifiers, returning members, multiple
submissions, duplicate ratings, and an unrated member. No application tables are
changed. Without STATISTICS_PSQL_COMMAND the integration test is skipped.
