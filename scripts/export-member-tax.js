#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { Pool } = require("pg");

const CSV_COLUMNS = [
  "payee.handle",
  "payee.email",
  "payee.first_name",
  "payee.last_name",
  "user_tax_form.tax_form_name",
  "member_profile_advanced.full_address_1",
  "payment.payment_type_id",
  "payment.payment_type_desc",
  "payment_paid_date.date_date",
  "user_tax_form.tax_form_status",
  "payee.payment_method_desc",
  "member_profile_basic.home_country",
  "member_profile_advanced.street_address_1",
  "member_profile_advanced.street_address_2",
  "member_profile_advanced.city",
  "member_profile_advanced.state_code",
  "member_profile_advanced.country",
  "payee.zip",
  "user_tax_form.withholding_amount",
  "user_tax_form.withholding_percentage",
  "user_payment.gross_amount",
  "user_payment.net_amount",
];

const BASE_DATA_QUERY = `
WITH latest_payment AS MATERIALIZED (
  SELECT
    p.winnings_id,
    MAX(p.version) AS max_version
  FROM finance.payment AS p
  GROUP BY p.winnings_id
),
payment_rows AS MATERIALIZED (
  SELECT
    p.payment_id::text AS payment_id,
    w.winner_id AS user_id,
    COALESCE(w.category::text, w.type::text) AS payment_type_id,
    INITCAP(REPLACE(COALESCE(w.category::text, w.type::text), '_', ' '))
      AS payment_type_desc,
    DATE(p.date_paid) AS paid_date,
    COALESCE(p.gross_amount, 0) AS gross_amount,
    COALESCE(p.net_amount, 0) AS net_amount
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
paid_users AS MATERIALIZED (
  SELECT DISTINCT pr.user_id
  FROM payment_rows AS pr
),
member_base AS MATERIALIZED (
  SELECT
    mem."userId",
    mem.handle,
    mem.email,
    mem."firstName",
    mem."lastName",
    mem.country,
    mem."homeCountryCode",
    COALESCE(home_code.name, home_id.name, mem."homeCountryCode")
      AS home_country
  FROM members.member AS mem
  JOIN paid_users AS pu
    ON pu.user_id = mem."userId"::text
  LEFT JOIN lookups."Country" AS home_code
    ON UPPER(home_code."countryCode") = UPPER(mem."homeCountryCode")
  LEFT JOIN lookups."Country" AS home_id
    ON UPPER(home_id.id) = UPPER(mem."homeCountryCode")
  WHERE mem.email IS NULL
     OR mem.email NOT ILIKE '%@wipro%'
),
latest_tax_form AS MATERIALIZED (
  SELECT DISTINCT ON (utf.user_id)
    utf.user_id,
    utf.tax_form_status
  FROM finance.user_tax_form_associations AS utf
  JOIN paid_users AS pu
    ON pu.user_id = utf.user_id
  ORDER BY
    utf.user_id,
    CASE utf.tax_form_status
      WHEN 'ACTIVE' THEN 0
      ELSE 1
    END,
    utf.date_filed DESC,
    utf.id DESC
),
preferred_address AS MATERIALIZED (
  SELECT DISTINCT ON (ma."userId")
    ma."userId",
    ma."streetAddr1" AS street_address_1,
    ma."streetAddr2" AS street_address_2,
    ma.city,
    ma."stateCode" AS state_code,
    ma.zip
  FROM members."memberAddress" AS ma
  JOIN paid_users AS pu
    ON pu.user_id = ma."userId"::text
  ORDER BY
    ma."userId",
    CASE
      WHEN UPPER(ma.type) = 'HOME' THEN 0
      WHEN UPPER(ma.type) = 'BILLING' THEN 1
      ELSE 2
    END,
    ma."updatedAt" DESC NULLS LAST,
    ma."createdAt" DESC NULLS LAST,
    ma.id DESC
),
preferred_payment_method AS MATERIALIZED (
  SELECT DISTINCT ON (upm.user_id)
    upm.user_id,
    pm.name AS payment_method_desc
  FROM finance.user_payment_methods AS upm
  JOIN paid_users AS pu
    ON pu.user_id = upm.user_id
  JOIN finance.payment_method AS pm
    ON pm.payment_method_id = upm.payment_method_id
  ORDER BY
    upm.user_id,
    CASE upm.status
      WHEN 'CONNECTED' THEN 0
      WHEN 'OTP_VERIFIED' THEN 1
      WHEN 'OTP_PENDING' THEN 2
      ELSE 3
    END,
    upm.payment_method_id
)
SELECT
  mb."userId"::text AS "__user_id",
  pr.payment_id AS "__payment_id",
  pr.payment_id AS "payment.payment_id",
  mb.handle AS "payee.handle",
  mb.email AS "payee.email",
  mb."firstName" AS "payee.first_name",
  mb."lastName" AS "payee.last_name",
  NULL::text AS "user_tax_form.tax_form_name",
  CONCAT_WS(
    ' ',
    NULLIF(addr.street_address_1, ''),
    NULLIF(addr.street_address_2, ''),
    NULLIF(addr.city, ''),
    NULLIF(addr.state_code, ''),
    NULLIF(COALESCE(NULLIF(mb.country, ''), mb.home_country), '')
  ) AS "member_profile_advanced.full_address_1",
  pr.payment_type_id AS "payment.payment_type_id",
  pr.payment_type_desc AS "payment.payment_type_desc",
  pr.paid_date AS "payment_paid_date.date_date",
  utf.tax_form_status AS "user_tax_form.tax_form_status",
  ppm.payment_method_desc AS "payee.payment_method_desc",
  mb.home_country AS "member_profile_basic.home_country",
  addr.street_address_1 AS "member_profile_advanced.street_address_1",
  addr.street_address_2 AS "member_profile_advanced.street_address_2",
  addr.city AS "member_profile_advanced.city",
  addr.state_code AS "member_profile_advanced.state_code",
  COALESCE(NULLIF(mb.country, ''), mb.home_country)
    AS "member_profile_advanced.country",
  addr.zip AS "payee.zip",
  NULL::numeric AS "user_tax_form.withholding_amount",
  NULL::numeric AS "user_tax_form.withholding_percentage",
  pr.gross_amount AS "user_payment.gross_amount",
  pr.net_amount AS "user_payment.net_amount"
FROM payment_rows AS pr
JOIN member_base AS mb
  ON mb."userId"::text = pr.user_id
LEFT JOIN latest_tax_form AS utf
  ON utf.user_id = pr.user_id
LEFT JOIN preferred_address AS addr
  ON addr."userId" = mb."userId"
LEFT JOIN preferred_payment_method AS ppm
  ON ppm.user_id = pr.user_id
ORDER BY pr.paid_date DESC, mb.handle, pr.payment_id;
`;

const OLD_TAX_FORM_QUERY = `
WITH input_users AS (
  SELECT DISTINCT UNNEST($1::text[]) AS user_id
)
SELECT DISTINCT ON (utfa.user_id)
  utfa.user_id,
  tf.name AS tax_form_name,
  utfa.withholding_amount,
  utfa.withholding_percentage
FROM public.user_tax_form_associations AS utfa
JOIN input_users AS iu
  ON iu.user_id = utfa.user_id
LEFT JOIN public.tax_forms AS tf
  ON tf.tax_form_id = utfa.tax_form_id
ORDER BY
  utfa.user_id,
  CASE utfa.status_id
    WHEN 'ACTIVE' THEN 0
    WHEN 'OTP_VERIFIED' THEN 1
    WHEN 'OTP_PENDING' THEN 2
    ELSE 3
  END,
  utfa.date_filed DESC NULLS LAST,
  utfa.id DESC;
`;

const OLD_PAYMENT_METHOD_QUERY = `
WITH input_payments AS (
  SELECT DISTINCT UNNEST($1::text[]) AS payment_id
)
SELECT DISTINCT ON (pra.payment_id::text)
  pra.payment_id::text AS payment_id,
  pm.name AS payment_method_desc
FROM input_payments AS ip
JOIN public.payment_release_associations AS pra
  ON pra.payment_id::text = ip.payment_id
JOIN public.payment_releases AS pr
  ON pr.payment_release_id = pra.payment_release_id
JOIN public.payment_method AS pm
  ON pm.payment_method_id = pr.payment_method_id
ORDER BY
  pra.payment_id::text,
  pr.created_at DESC NULLS LAST,
  pr.payment_release_id DESC;
`;

const HELP = `
Usage:
  node scripts/export-member-tax.js [--output <file>] [--start-date YYYY-MM-DD] [--end-date YYYY-MM-DD]

Required environment variables:
  DATABASE_URL
  OLD_PAYMENTS_DATABASE_URL

Defaults:
  start-date: January 1 of previous calendar year
  end-date: January 1 of current calendar year
  output: ./member-tax-<start>-to-<end>.csv
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
    const line = CSV_COLUMNS.map((column) => csvEscape(row[column])).join(",");
    lines.push(line);
  }

  fs.writeFileSync(outputPath, `${lines.join("\n")}\n`, "utf8");
}

function toNumberOrZero(value) {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : 0;
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

  const mainDatabaseUrl = process.env.DATABASE_URL;
  const oldPaymentsDatabaseUrl = process.env.OLD_PAYMENTS_DATABASE_URL;

  if (!mainDatabaseUrl) {
    throw new Error("DATABASE_URL is required");
  }
  if (!oldPaymentsDatabaseUrl) {
    throw new Error("OLD_PAYMENTS_DATABASE_URL is required");
  }

  const outputFile =
    options.output ?? `member-tax-${startDate}-to-${endDate}.csv`;
  const outputPath = path.resolve(process.cwd(), outputFile);

  const mainPool = new Pool({ connectionString: mainDatabaseUrl });
  const oldPaymentsPool = new Pool({ connectionString: oldPaymentsDatabaseUrl });

  try {
    console.log(
      `[member-tax-export] Exporting data for ${startDate} to ${endDate}`,
    );

    const baseResult = await mainPool.query(BASE_DATA_QUERY, [startDate, endDate]);
    const baseRows = baseResult.rows;
    const userIds = Array.from(
      new Set(baseRows.map((row) => row.__user_id).filter(Boolean)),
    );
    const paymentIds = Array.from(
      new Set(baseRows.map((row) => row.__payment_id).filter(Boolean)),
    );

    console.log(`[member-tax-export] Main rows: ${baseRows.length}`);
    console.log(`[member-tax-export] Distinct users: ${userIds.length}`);
    console.log(`[member-tax-export] Distinct payments: ${paymentIds.length}`);

    let taxRows = [];
    if (userIds.length > 0) {
      const oldResult = await oldPaymentsPool.query(OLD_TAX_FORM_QUERY, [userIds]);
      taxRows = oldResult.rows;
    }

    let paymentMethodRows = [];
    if (paymentIds.length > 0) {
      const oldPaymentMethodResult = await oldPaymentsPool.query(
        OLD_PAYMENT_METHOD_QUERY,
        [paymentIds],
      );
      paymentMethodRows = oldPaymentMethodResult.rows;
    }

    const taxFormsByUserId = new Map(
      taxRows.map((row) => [
        String(row.user_id),
        {
          taxFormName: row.tax_form_name ?? null,
          withholdingAmount: row.withholding_amount ?? null,
          withholdingPercentage: row.withholding_percentage ?? null,
        },
      ]),
    );
    const paymentMethodByPaymentId = new Map(
      paymentMethodRows.map((row) => [
        String(row.payment_id),
        row.payment_method_desc ?? null,
      ]),
    );

    const mergedRows = baseRows.map((row) => {
      const userId = String(row.__user_id);
      const paymentId = String(row.__payment_id);
      const oldTaxData = taxFormsByUserId.get(userId);
      const oldPaymentMethod = paymentMethodByPaymentId.get(paymentId);
      return {
        ...row,
        "user_tax_form.tax_form_name": oldTaxData?.taxFormName ?? null,
        "user_tax_form.withholding_amount": oldTaxData?.withholdingAmount ?? null,
        "user_tax_form.withholding_percentage":
          oldTaxData?.withholdingPercentage ?? null,
        "payee.payment_method_desc":
          oldPaymentMethod ?? row["payee.payment_method_desc"] ?? null,
      };
    });

    const aggregatedByUser = new Map();
    for (const row of mergedRows) {
      const userId = String(row.__user_id);
      const existing = aggregatedByUser.get(userId);

      if (!existing) {
        aggregatedByUser.set(userId, {
          ...row,
          "user_payment.gross_amount": toNumberOrZero(
            row["user_payment.gross_amount"],
          ),
          "user_payment.net_amount": toNumberOrZero(row["user_payment.net_amount"]),
        });
        continue;
      }

      existing["user_payment.gross_amount"] =
        toNumberOrZero(existing["user_payment.gross_amount"]) +
        toNumberOrZero(row["user_payment.gross_amount"]);
      existing["user_payment.net_amount"] =
        toNumberOrZero(existing["user_payment.net_amount"]) +
        toNumberOrZero(row["user_payment.net_amount"]);
    }

    const aggregatedRows = Array.from(aggregatedByUser.values())
      .map((row) => {
        const normalized = { ...row };
        delete normalized.__user_id;
        delete normalized.__payment_id;
        delete normalized["payment.payment_id"];
        return normalized;
      })
      .sort((a, b) =>
        String(a["payee.handle"] ?? "").localeCompare(
          String(b["payee.handle"] ?? ""),
        ),
      );

    writeCsv(outputPath, aggregatedRows);
    console.log(`[member-tax-export] Wrote CSV: ${outputPath}`);
  } finally {
    await Promise.allSettled([mainPool.end(), oldPaymentsPool.end()]);
  }
}

run().catch((error) => {
  console.error(`[member-tax-export] Failed: ${error.message}`);
  process.exit(1);
});
