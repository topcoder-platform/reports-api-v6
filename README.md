## Description

This repository houses the reports API for all Topcoder and Topgear reports on the Topcoder platform.  The reports are pulled directly from live data, not a data warehouse, so they should be up-to-date when they are generated and the response is returned.

Reports return JSON data by default. Endpoints that support CSV can also return
CSV when the request sets `Accept: text/csv` (including the Challenges and
Topcoder report groups).

## Security

Currently, an M2M token is required to pull any report, and each report has its own scope associated with it that must be applied to the M2M token client ID

The report directory (list of endpoints and parameters) is available at `GET /v6/reports/directory` and uses the same authorization rules as other endpoints. The service accepts bearer tokens from the standard `Authorization` header, and also from proxies that forward the token in `X-Authorization`/`X-Forwarded-Authorization`.

## Layout

Each report will be a separate SQL query, potentially with a few parameters (like a start and an end date, for example).  The individual SQL queries can be found in the `sql` folder and should be able to be run against the `topcoder-services` RDS database in dev or prod, with minimal changes to replace the parameters.

## Technology Stack

- **Framework**: NestJS
- **Language**: TypeScript
- **Database**: PostgreSQL
- **ORM**: Prisma
- **Package Manager**: pnpm

## Prerequisites

- Node.js (v22 or later recommended)
- pnpm

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd reports-api-v6
```

### 2. Install Dependencies

This project uses pnpm as the package manager. Ensure you have it installed, then run:

```bash
pnpm install
```
### 4. Configure Environment Variables

Create a `.env` file in the root of the project. You can copy the example structure below. The default values are configured to work with the local Docker setup.

```bash
# .env

# PostgreSQL Database URL for Prisma
# This is used by Prisma to connect to your local PostgreSQL instance.
DATABASE_URL="postgresql://user:password@localhost:5432/lookups?schema=public"

# Old tc-payments database URL (used by member-tax CSV export script)
OLD_PAYMENTS_DATABASE_URL="postgresql://user:password@localhost:5432/tc_payments?schema=public"

# ---------------------------------------------------
# JWT Authentication Secrets
# These are used by tc-core-library-js for validating JWTs.
# ---------------------------------------------------

# The secret key used to sign and verify JWTs.
AUTH_SECRET="mysecret"

# A JSON array string of valid token issuers.
VALID_ISSUERS='["https://topcoder-dev.auth0.com/","https://auth.topcoder-dev.com/","https://topcoder.auth0.com/","https://auth.topcoder.com/","https://api.topcoder.com","https://api.topcoder-dev.com"]'

## Running the Application

### Development Mode

To run the application in development mode with hot-reloading:

```bash
pnpm run dev
```

The application will be available at http://localhost:3000.

## Member Tax CSV Export

`member-tax` is generated as an offline CSV export (not an API endpoint).
The export enriches tax-form name/withholding values and payment-method names from the old payments database.

```bash
pnpm run export:member-tax -- --output ./member-tax.csv
```

Optional date window:

```bash
pnpm run export:member-tax -- --start-date 2025-01-01 --end-date 2026-01-01 --output ./member-tax-2025.csv
```

## Member Tax Aggregated CSV Export

Aggregated member-payment export (main database only):

```bash
pnpm run export:member-tax-aggregated -- --output ./member-tax-aggregated.csv
```

Optional date window:

```bash
pnpm run export:member-tax-aggregated -- --start-date 2025-01-01 --end-date 2026-01-01 --output ./member-tax-aggregated-2025.csv
```

## Public Statistics Endpoints

The following read-only endpoints are available without authentication to support the Community Statistics page. 

- `GET /v6/reports/statistics/srm/top-rated` — Highest rated SRM data (static JSON)
- `GET /v6/reports/statistics/srm/country-ratings` — SRM country ratings (static JSON)
- `GET /v6/reports/statistics/srm/competitions-count` — SRM number of competitions (static JSON)
- `GET /v6/reports/statistics/mm/top-rated` — Highest rated Marathon Match data (static JSON)
- `GET /v6/reports/statistics/mm/country-ratings` — Marathon Match country ratings (static JSON)
- `GET /v6/reports/statistics/mm/top-10-finishes` — Marathon Match Top 10 finishes (static JSON)
- `GET /v6/reports/statistics/mm/competitions-count` — Marathon Match number of competitions (static JSON)

Static datasets are stored under `data/statistics/srm` and `data/statistics/mm` and are packaged into the ECS image in the Dockerfile.
