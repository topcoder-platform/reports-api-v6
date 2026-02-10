#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { Pool } = require("pg");

const CSV_COLUMNS = [
  "userID",
  "handle",
  "email",
  "firstName",
  "lastName",
  "homeCountryCode",
  "net_amount",
  "gross_amount",
  "trolley_id",
  "tax_form_status",
  "num_payments",
  "last_payment_release_date",
];

const AGGREGATED_QUERY = `
WITH latest_payment AS MATERIALIZED (
  SELECT
    p.winnings_id,
    MAX(p.version) AS max_version
  FROM finance.payment AS p
  GROUP BY p.winnings_id
),
payment_rows AS MATERIALIZED (
  SELECT
    w.winner_id AS user_id,
    p.payment_id::text AS payment_id,
    COALESCE(p.net_amount, 0) AS net_amount,
    COALESCE(p.gross_amount, 0) AS gross_amount,
    p.release_date
  FROM finance.payment AS p
  JOIN latest_payment AS lp
    ON lp.winnings_id = p.winnings_id
   AND lp.max_version = p.version
  JOIN finance.winnings AS w
    ON w.winning_id = p.winnings_id
  WHERE w.type = 'PAYMENT'
    AND p.date_paid >= $1::date
    AND p.date_paid < $2::date
),
payment_agg AS MATERIALIZED (
  SELECT
    pr.user_id,
    COUNT(DISTINCT pr.payment_id) AS num_payments,
    SUM(pr.net_amount) AS net_amount,
    SUM(pr.gross_amount) AS gross_amount,
    MAX(pr.release_date) AS last_payment_release_date
  FROM payment_rows AS pr
  GROUP BY pr.user_id
),
latest_tax_form AS MATERIALIZED (
  SELECT DISTINCT ON (utf.user_id)
    utf.user_id,
    utf.tax_form_status
  FROM finance.user_tax_form_associations AS utf
  JOIN payment_agg AS pa
    ON pa.user_id = utf.user_id
  ORDER BY
    utf.user_id,
    CASE utf.tax_form_status
      WHEN 'ACTIVE' THEN 0
      ELSE 1
    END,
    utf.date_filed DESC NULLS LAST,
    utf.id DESC
)
SELECT
  mem."userId"::text AS "userID",
  mem.handle AS "handle",
  mem.email AS "email",
  mem."firstName" AS "firstName",
  mem."lastName" AS "lastName",
  mem."homeCountryCode" AS "homeCountryCode",
  pa.net_amount AS "net_amount",
  pa.gross_amount AS "gross_amount",
  tr.trolley_id AS "trolley_id",
  ltf.tax_form_status AS "tax_form_status",
  pa.num_payments AS "num_payments",
  pa.last_payment_release_date AS "last_payment_release_date"
FROM payment_agg AS pa
JOIN members.member AS mem
  ON mem."userId"::text = pa.user_id
LEFT JOIN finance.trolley_recipient AS tr
  ON tr.user_id = pa.user_id
LEFT JOIN latest_tax_form AS ltf
  ON ltf.user_id = pa.user_id
ORDER BY pa.gross_amount DESC, mem.handle;
`;

const HELP = `
Usage:
  node scripts/export-member-tax-aggregated.js [--output <file>] [--start-date YYYY-MM-DD] [--end-date YYYY-MM-DD]

Required environment variables:
  DATABASE_URL

Defaults:
  start-date: January 1 of previous calendar year
  end-date: January 1 of current calendar year
  output: ./member-tax-aggregated-<start>-to-<end>.csv
`;

function parseArgs(argv) {
  const options = {
    output: null,
    startDate: null,
    endDate: null,
    help: false,
  };

  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === "--help" || arg === "-h") {
      options.help = true;
      continue;
    }
    if (arg === "--output" || arg === "-o") {
      const value = argv[i + 1];
      if (!value) {
        throw new Error("--output requires a value");
      }
      options.output = value;
      i += 1;
      continue;
    }
    if (arg === "--start-date") {
      const value = argv[i + 1];
      if (!value) {
        throw new Error("--start-date requires a value");
      }
      options.startDate = value;
      i += 1;
      continue;
    }
    if (arg === "--end-date") {
      const value = argv[i + 1];
      if (!value) {
        throw new Error("--end-date requires a value");
      }
      options.endDate = value;
      i += 1;
      continue;
    }
    throw new Error(`Unknown argument: ${arg}`);
  }

  return options;
}

function getDefaultWindow() {
  const now = new Date();
  const currentYear = now.getUTCFullYear();
  return {
    startDate: `${currentYear - 1}-01-01`,
    endDate: `${currentYear}-01-01`,
  };
}

function validateIsoDate(value, name) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) {
    throw new Error(`${name} must be in YYYY-MM-DD format`);
  }
  const parsed = new Date(`${value}T00:00:00.000Z`);
  if (Number.isNaN(parsed.getTime())) {
    throw new Error(`${name} is not a valid date`);
  }
}

function csvEscape(value) {
  if (value === null || value === undefined) {
    return "";
  }
  const stringValue = String(value);
  if (!/[",\n\r]/.test(stringValue)) {
    return stringValue;
  }
  return `"${stringValue.replace(/"/g, '""')}"`;
}

function writeCsv(outputPath, rows) {
  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  const lines = [];
  lines.push(CSV_COLUMNS.map(csvEscape).join(","));

  for (const row of rows) {
    const line = CSV_COLUMNS.map((column) => {
      const value = row[column];
      if (column === "last_payment_release_date" && value) {
        return csvEscape(new Date(value).toISOString());
      }
      return csvEscape(value);
    }).join(",");
    lines.push(line);
  }

  fs.writeFileSync(outputPath, `${lines.join("\n")}\n`, "utf8");
}

async function run() {
  const options = parseArgs(process.argv.slice(2));
  if (options.help) {
    console.log(HELP.trim());
    return;
  }

  const defaultWindow = getDefaultWindow();
  const startDate = options.startDate ?? defaultWindow.startDate;
  const endDate = options.endDate ?? defaultWindow.endDate;

  validateIsoDate(startDate, "start-date");
  validateIsoDate(endDate, "end-date");
  if (startDate >= endDate) {
    throw new Error("start-date must be earlier than end-date");
  }

  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    throw new Error("DATABASE_URL is required");
  }

  const outputFile =
    options.output ?? `member-tax-aggregated-${startDate}-to-${endDate}.csv`;
  const outputPath = path.resolve(process.cwd(), outputFile);
  const pool = new Pool({ connectionString: databaseUrl });

  try {
    console.log(
      `[member-tax-aggregated-export] Exporting data for ${startDate} to ${endDate}`,
    );
    const result = await pool.query(AGGREGATED_QUERY, [startDate, endDate]);
    writeCsv(outputPath, result.rows);
    console.log(
      `[member-tax-aggregated-export] Rows: ${result.rows.length}. Wrote CSV: ${outputPath}`,
    );
  } finally {
    await pool.end();
  }
}

run().catch((error) => {
  console.error(`[member-tax-aggregated-export] Failed: ${error.message}`);
  process.exit(1);
});
