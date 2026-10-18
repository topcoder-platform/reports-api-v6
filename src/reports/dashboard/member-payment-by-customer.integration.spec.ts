import { Client } from "pg";
import { SqlLoaderService } from "../../common/sql-loader.service";

const databaseTests = process.env.DASHBOARD_TEST_DATABASE_URL
  ? describe
  : describe.skip;

// Use an empty, disposable PostgreSQL database. All schema and fixture changes
// are rolled back, including when an assertion fails.
databaseTests("Member payment by customer SQL with PostgreSQL", () => {
  const db = new Client({
    connectionString: process.env.DASHBOARD_TEST_DATABASE_URL,
  });
  const sql = new SqlLoaderService().load(
    "reports/dashboard/member-payment-by-customer.sql",
  );
  const range = ["2026-01-01T00:00:00Z", "2026-03-01T00:00:00Z"];

  beforeAll(async () => {
    await db.connect();
    await db.query("BEGIN");
    await db.query(`
      CREATE SCHEMA finance;
      CREATE SCHEMA challenges;
      CREATE SCHEMA "billing-accounts";
      CREATE TABLE finance.payment (
        winnings_id text, version integer, created_at timestamp,
        gross_amount numeric, total_amount numeric,
        billing_account text, payment_status text
      );
      CREATE TABLE finance.winnings (
        winning_id text, external_id text, type text, winner_id text, category text
      );
      CREATE TABLE challenges."Challenge" (id text PRIMARY KEY);
      CREATE TABLE challenges."ChallengeBilling" (
        "challengeId" text, "billingAccountId" text
      );
      CREATE TABLE "billing-accounts"."BillingAccount" (
        id integer PRIMARY KEY, "clientId" text, "subcontractingEndCustomer" text
      );
      CREATE TABLE "billing-accounts"."Client" (id text PRIMARY KEY, name text);
      INSERT INTO "billing-accounts"."Client" VALUES
        ('client-1', 'Customer'), ('client-2', 'Challenge customer');
      INSERT INTO "billing-accounts"."BillingAccount" VALUES
        (1, 'client-1', 'Payment account'), (2, 'client-2', 'Challenge account');
      INSERT INTO challenges."Challenge" VALUES ('challenge');
      INSERT INTO challenges."ChallengeBilling" VALUES ('challenge', '2');
      INSERT INTO finance.winnings VALUES
        ('winning', 'challenge', 'PAYMENT', 'member', 'TASK_PAYMENT');
      INSERT INTO finance.payment VALUES
        ('winning', 1, '2026-01-15', 100, 90, '0001', 'OWED');
      SAVEPOINT fixture;
    `);
  });

  afterEach(async () => {
    await db.query("ROLLBACK TO SAVEPOINT fixture");
  });

  afterAll(async () => {
    await db.query("ROLLBACK");
    await db.end();
  });

  it.each([
    ["TAAS_PAYMENT", "Wipro Limited (NA subcontracting)", "TaaS"],
    ["TASK_PAYMENT", "Wipro Limited (NA subcontracting)", "Payment account"],
    [null, "Wipro Limited (NA subcontracting)", "Payment account"],
    ["TAAS_PAYMENT", "Topcoder", "Payment account"],
    ["TASK_PAYMENT", "Topcoder", "Topcoder"],
    ["TASK_REVIEW_PAYMENT", "Topcoder", "Topcoder"],
    ["TASK_COPILOT_PAYMENT", "Topcoder", "Topcoder"],
    ["DEPLOYMENT_TASK_PAYMENT", "Topcoder", "Topcoder"],
    ["PROJECT_DEPLOYMENT_TASK_PAYMENT", "Topcoder", "Topcoder"],
    ["ENGAGEMENT_PAYMENT", "Topcoder", "Topcoder"],
    ["CHALLENGE_PAYMENT", "Topcoder", "Topcoder"],
    [null, "Topcoder", "Topcoder"],
    ["TAAS_PAYMENT", "Customer", "Payment account"],
    ["TASK_PAYMENT", "Customer", "Payment account"],
    ["TAAS_PAYMENT", " Wipro Limited (NA subcontracting) ", "TaaS"],
  ])("labels %s for %s as %s", async (category, name, label) => {
    await db.query("UPDATE finance.winnings SET category = $1", [category]);
    await db.query(
      `UPDATE "billing-accounts"."Client" SET name = $1 WHERE id = 'client-1'`,
      [name],
    );

    const { rows } = await db.query(sql, range);

    expect(rows).toHaveLength(4);
    expect(rows[0]).toMatchObject({
      month: "2026-01-01",
      customer_id: "client-1",
      customer_label: label,
      amount: "100",
    });
    expect(rows[2]).toMatchObject({
      month: "2026-02-01",
      series_key: rows[0].series_key,
      customer_label: label,
      amount: "0",
    });
  });

  it.each([
    ["0001", "Payment account", "Payment account"],
    ["0", "Payment account", "Challenge account"],
    ["000", "Payment account", "Challenge account"],
    [null, "Payment account", "Challenge account"],
    ["", "Payment account", "Challenge account"],
    ["missing", "Payment account", "Challenge account"],
    ["1", " Trimmed account ", "Trimmed account"],
    ["1", null, "Other Customers"],
    ["1", "   ", "Other Customers"],
  ])(
    "resolves billing account %s with reporting name %s to %s",
    async (billingAccount, reportingName, label) => {
      await db.query("UPDATE finance.payment SET billing_account = $1", [
        billingAccount,
      ]);
      await db.query(
        `UPDATE "billing-accounts"."BillingAccount"
         SET "subcontractingEndCustomer" = $1 WHERE id = 1`,
        [reportingName],
      );

      const { rows } = await db.query(sql, range);

      expect(rows[0]).toMatchObject({
        customer_label: label,
        amount: "100",
      });
      expect(rows.filter((row) => row.month === "2026-02-01")).toEqual(
        expect.arrayContaining([expect.objectContaining({ amount: "0" })]),
      );
    },
  );

  it("keeps reporting accounts and TaaS under one client in distinct series", async () => {
    await db.query(`
      UPDATE "billing-accounts"."Client"
        SET name = 'Wipro Limited (NA subcontracting)' WHERE id = 'client-1';
      INSERT INTO "billing-accounts"."BillingAccount" VALUES
        (3, 'client-1', 'Second account');
      INSERT INTO finance.winnings VALUES
        ('second', 'challenge', 'PAYMENT', 'member', 'TASK_PAYMENT'),
        ('third', 'challenge', 'PAYMENT', 'member', 'TASK_PAYMENT'),
        ('taas', 'challenge', 'PAYMENT', 'member', 'TAAS_PAYMENT');
      INSERT INTO finance.payment VALUES
        ('second', 1, '2026-01-16', 200, 0, '3', 'OWED'),
        ('third', 1, '2026-01-17', 300, 0, '1', 'OWED'),
        ('taas', 1, '2026-01-18', 500, 0, '1', 'OWED');
    `);

    const { rows } = await db.query(sql, range);
    const january = rows.filter((row) => row.month === "2026-01-01");
    const february = rows.filter((row) => row.month === "2026-02-01");

    expect(january.map((row) => [row.customer_label, row.amount])).toEqual([
      ["TaaS", "500"],
      ["Payment account", "400"],
      ["Second account", "200"],
      ["Other Customers", "0"],
    ]);
    expect(new Set(january.map((row) => row.series_key)).size).toBe(4);
    expect(january.slice(0, 3).map((row) => row.customer_id)).toEqual([
      "client-1",
      "client-1",
      "client-1",
    ]);
    expect(february.map((row) => [row.series_key, row.amount])).toEqual(
      january.map((row) => [row.series_key, "0"]),
    );
  });

  it("ranks five reporting labels and preserves the remaining payment total", async () => {
    await db.query(`
      INSERT INTO "billing-accounts"."BillingAccount"
        SELECT n, 'client-1', 'Account ' || n FROM generate_series(3, 8) n;
      INSERT INTO finance.winnings
        SELECT 'winning-' || n, 'challenge', 'PAYMENT', 'member', 'TASK_PAYMENT'
        FROM generate_series(3, 8) n;
      INSERT INTO finance.payment
        SELECT 'winning-' || n, 1, '2026-01-15'::timestamp, n * 100, 0, n::text, 'OWED'
        FROM generate_series(3, 8) n;
    `);

    const { rows } = await db.query(sql, range);
    const january = rows.filter((row) => row.month === "2026-01-01");

    expect(january.map((row) => [row.customer_label, row.amount])).toEqual([
      ["Account 8", "800"],
      ["Account 7", "700"],
      ["Account 6", "600"],
      ["Account 5", "500"],
      ["Account 4", "400"],
      ["Other Customers", "400"],
    ]);
    expect(new Set(january.map((row) => row.series_key)).size).toBe(6);
  });
});
