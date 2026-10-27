import { Pool } from "pg";
import { SqlLoaderService } from "../../common/sql-loader.service";

// Opt-in integration test: point only at a disposable database named sales_dashboard_test.
const connectionString = process.env.SALES_DASHBOARD_TEST_DB_URL;
const integration = connectionString ? describe : describe.skip;

integration("Monthly sales SQL (PostgreSQL)", () => {
  const pool = new Pool({ connectionString });
  const sql = new SqlLoaderService();
  const bounds = ["2026-08-01T00:00:00Z", "2026-11-01T00:00:00Z"];
  beforeAll(async () => {
    if (
      !connectionString ||
      new URL(connectionString).pathname !== "/sales_dashboard_test"
    )
      throw new Error("Use a disposable sales_dashboard_test database.");
    await pool.query(`
      CREATE SCHEMA finance;
      CREATE SCHEMA challenges;
      CREATE SCHEMA "billing-accounts";
      CREATE SCHEMA engagements;
      CREATE SCHEMA projects;
      CREATE TABLE projects.projects (id int, "billingAccountId" int);
      CREATE TABLE engagements."Engagement" (id text, "projectId" text);
      CREATE TABLE finance.payment (winnings_id text, version int, created_at timestamp, gross_amount numeric, total_amount numeric, billing_account text, payment_status text, challenge_markup numeric);
      CREATE TABLE finance.winnings (winning_id text, winner_id text, category text, type text, external_id text);
      CREATE TABLE challenges."Challenge" (id text);
      CREATE TABLE challenges."ChallengeBilling" ("challengeId" text, "billingAccountId" text);
      CREATE TABLE "billing-accounts"."BillingAccount" (id int, "clientId" text, "subcontractingEndCustomer" text);
      CREATE TABLE "billing-accounts"."Client" (id text, name text);
      CREATE TABLE engagements."EngagementAssignment" ("memberId" text, status text, "acceptedAt" timestamp, "startDate" timestamp, "endDate" timestamp, "engagementId" text DEFAULT 'external');
      INSERT INTO "billing-accounts"."Client" VALUES ('customer', 'Customer'), ('internal', 'Topcoder'), ('wipro', 'Wipro Limited (NA subcontracting)');
      INSERT INTO "billing-accounts"."BillingAccount" VALUES (1, 'customer', 'Customer'), (2, 'internal', 'Some internal work'), (3, 'wipro', 'Customer B');
      INSERT INTO challenges."Challenge" VALUES ('challenge');
      INSERT INTO challenges."ChallengeBilling" VALUES ('challenge', '1');
      INSERT INTO finance.winnings VALUES
        ('a', 'member1', 'CHALLENGE_PAYMENT', 'PAYMENT', 'challenge'),
        ('b', 'member1', 'CHALLENGE_PAYMENT', 'PAYMENT', 'challenge'),
        ('c', 'member2', 'TAAS_PAYMENT', 'PAYMENT', null),
        ('d', 'member3', 'CHALLENGE_PAYMENT', 'PAYMENT', null),
        ('e', 'member4', 'ENGAGEMENT_PAYMENT', 'PAYMENT', null),
        ('f', 'member5', 'CHALLENGE_PAYMENT', 'PAYMENT', null),
        ('g', 'member6', 'CHALLENGE_PAYMENT', 'PAYMENT', null),
        ('h', 'member7', 'CHALLENGE_PAYMENT', 'PAYMENT', null),
        ('i', 'member8', 'CHALLENGE_PAYMENT', 'PAYMENT', null);
      INSERT INTO finance.payment VALUES
        ('a', 1, '2026-08-01', 999, 999, '1', 'PAID', 9),
        ('a', 2, '2026-08-01', 100, 100, '0001', 'PAID', .10),
        ('b', 1, '2026-08-20', 900, 900, '0', 'OWED', .30),
        ('c', 1, '2026-08-20', 5000, 5000, '3', 'PAID', .40),
        ('d', 1, '2026-08-20', 6000, 6000, '2', 'PAID', .50),
        ('e', 1, '2026-08-20', 50, 50, '3', 'PAID', .20),
        ('f', 1, '2026-09-01', 100, 100, '1', 'CANCELLED', .50),
        ('g', 1, '2026-09-02', 200, 200, '1', 'FAILED', .10),
        ('h', 1, '2026-10-01', 300, 300, 'missing', 'PAID', null),
        ('i', 1, '2026-11-01', 888, 888, '1', 'PAID', .99);
      INSERT INTO projects.projects VALUES (1, 1), (2, 2), (3, NULL), (4, 3);
      INSERT INTO engagements."Engagement" VALUES ('external', '1'), ('internal', '2'), ('unlinked', '3'), ('wipro', '4');
      INSERT INTO engagements."EngagementAssignment" ("memberId", status, "acceptedAt", "startDate", "endDate") VALUES
        ('alice', 'COMPLETED', '2026-08-05', '2026-08-10', '2026-09-15'),
        ('alice', 'ASSIGNED', '2026-08-20', null, null),
        ('bob', 'ASSIGNED', null, '2026-07-01', null),
        ('carol', 'TERMINATED', '2026-08-01', null, '2026-08-31'),
        ('dave', 'SELECTED', null, '2026-08-01', null),
        ('eve', 'COMPLETED', null, null, '2026-09-20'),
        ('frank', 'ASSIGNED', '2026-11-01', null, null);
    `);
  });
  afterAll(async () => {
    if (
      connectionString &&
      new URL(connectionString).pathname === "/sales_dashboard_test"
    ) {
      await pool.query(
        'DROP SCHEMA IF EXISTS finance, challenges, "billing-accounts", engagements, projects CASCADE',
      );
    }
    await pool.end();
  });

  it("filters customer work before type totals, distinct-member counts and customer ranking", async () => {
    const sales = await pool.query(
      sql.load("reports/dashboard/sales-payments.sql"),
      [...bounds, true, false],
    );
    const reports = await pool.query(
      sql.load("reports/dashboard/sales-payments.sql"),
      [...bounds, false, false],
    );
    const august = sales.rows.filter((r) => r.month === "2026-08-01");
    expect(
      august.find((r) => r.kind === "type" && r.payment_type === "challenge"),
    ).toMatchObject({ amount: "1000", members: "1" });
    expect(
      august.find((r) => r.kind === "type" && r.payment_type === "engagement")
        .amount,
    ).toBe("50");
    expect(
      sales.rows.some(
        (r) =>
          r.payment_type === "taas" ||
          r.customer_label === "Topcoder" ||
          r.customer_label === "TaaS",
      ),
    ).toBe(false);
    expect(
      sales.rows
        .filter((r) => r.kind === "customer")
        .reduce((sum, r) => sum + Number(r.amount), 0),
    ).toBe(1250);
    expect(
      reports.rows.some(
        (r) => r.customer_label === "Topcoder" && Number(r.amount) === 6000,
      ),
    ).toBe(true);
    expect(
      reports.rows.some(
        (r) => r.payment_type === "taas" || r.customer_label === "TaaS",
      ),
    ).toBe(false);
    expect(
      sales.rows.some(
        (r) => r.month === "2026-11-01" || r.month === "2026-10-01",
      ),
    ).toBe(false);
  });

  it("averages latest payment markup equally across all statuses, retaining null for unknown markup", async () => {
    const result = await pool.query(
      sql.load("reports/dashboard/sales-gross-margin.sql"),
      bounds,
    );
    expect(Number(result.rows[0].markup)).toBe(30);
    // September includes cancelled and failed payments: (.50 + .10) / 2 * 100.
    expect(Number(result.rows[1].markup)).toBe(30);
    expect(result.rows[2]).toMatchObject({
      month: "2026-10-01",
      markup: null,
      missing: "1",
    });
  });

  it("counts distinct assigned/completed/ongoing members using durable event dates and legacy starts", async () => {
    const result = await pool.query(
      sql.load("reports/dashboard/sales-talent.sql"),
      [...bounds, null],
    );
    expect(result.rows[0]).toMatchObject({
      month: "2026-08-01",
      newly_assigned: "2",
      completed: "0",
      ongoing: "2",
    });
    expect(result.rows[1]).toMatchObject({
      month: "2026-09-01",
      newly_assigned: "0",
      completed: "2",
      ongoing: "2",
    });
    expect(result.rows[2]).toMatchObject({
      month: "2026-10-01",
      newly_assigned: "0",
      completed: "0",
      ongoing: "2",
    });
  });
  it("excludes internal/unlinked engagement assignments before all monthly distinct counts", async () => {
    await pool.query(`INSERT INTO engagements."EngagementAssignment" VALUES
      ('internal-only', 'COMPLETED', '2026-08-01', null, '2026-09-15', 'internal'),
      ('unlinked-only', 'ASSIGNED', '2026-08-01', null, null, 'unlinked'),
      ('alice', 'ASSIGNED', '2026-08-01', null, null, 'internal'),
      ('external-wipro', 'ASSIGNED', '2026-08-01', null, null, 'wipro')`);
    const projects = await pool.query(
      sql.load("reports/dashboard/sales-customer-projects.sql"),
    );
    const ids = projects.rows.map((p) => p.project_id).sort();
    expect(ids).toEqual(["1", "4"]);
    const scoped = await pool.query(
      sql.load("reports/dashboard/sales-talent.sql"),
      [...bounds, ids],
    );
    expect(scoped.rows[0]).toMatchObject({ newly_assigned: "3", ongoing: "3" });
    expect(scoped.rows[1]).toMatchObject({ completed: "2", ongoing: "3" });
    const empty = await pool.query(
      sql.load("reports/dashboard/sales-talent.sql"),
      [...bounds, []],
    );
    expect(
      empty.rows.every((row) =>
        [row.newly_assigned, row.completed, row.ongoing].every(
          (n) => n === "0",
        ),
      ),
    ).toBe(true);
    const unscoped = await pool.query(
      sql.load("reports/dashboard/sales-talent.sql"),
      [...bounds, null],
    );
    expect(unscoped.rows[0]).toMatchObject({
      newly_assigned: "5",
      ongoing: "5",
    });
  });
  it("uses linked client names for missing end customers while preserving billing-account precedence", async () => {
    await pool.query(`
      INSERT INTO "billing-accounts"."Client" VALUES ('71000361', 'Named client'), ('82e8-test', 'Another named client');
      INSERT INTO "billing-accounts"."BillingAccount" VALUES (20, '71000361', '   '), (21, '82e8-test', NULL), (22, 'customer', 'Specific end customer');
      INSERT INTO finance.winnings VALUES ('fallback-a', 'member1', 'TASK_PAYMENT', 'PAYMENT', 'challenge'), ('fallback-b', 'member2', 'TASK_PAYMENT', 'PAYMENT', NULL), ('fallback-c', 'member3', 'TASK_PAYMENT', 'PAYMENT', NULL);
      INSERT INTO finance.payment VALUES ('fallback-a', 1, '2026-09-01', 100, 100, '20', 'PAID', NULL), ('fallback-b', 1, '2026-09-01', 200, 200, '21', 'PAID', NULL), ('fallback-c', 1, '2026-09-01', 300, 300, '22', 'PAID', NULL);
    `);
    const { rows } = await pool.query(
      sql.load("reports/dashboard/sales-payments.sql"),
      [...bounds, true, false],
    );
    const labels = rows
      .filter((row) => row.kind === "customer")
      .map((row) => row.customer_label);
    expect(labels).toEqual(
      expect.arrayContaining([
        "Named client",
        "Another named client",
        "Specific end customer",
      ]),
    );
    expect(
      labels.some((label) => label === null || /^Customer \d/.test(label)),
    ).toBe(false);
  });

  it("isolates TaaS payments by creation month and latest version, excluding cancelled and out-of-range records", async () => {
    await pool.query(`
      INSERT INTO finance.winnings VALUES ('taas-cancelled', 'member1', 'TAAS_PAYMENT', 'PAYMENT', NULL), ('taas-outside', 'member2', 'TAAS_PAYMENT', 'PAYMENT', NULL);
      INSERT INTO finance.payment VALUES ('c', 2, '2026-09-01', 6000, 6000, '3', 'PAID', NULL), ('taas-cancelled', 1, '2026-09-01', 100, 100, '3', 'CANCELLED', NULL), ('taas-outside', 1, '2026-11-01', 200, 200, '3', 'PAID', NULL);
    `);
    const { rows } = await pool.query(
      sql.load("reports/dashboard/sales-payments.sql"),
      [...bounds, false, true],
    );
    expect(rows.filter((row) => row.kind === "type")).toEqual([
      expect.objectContaining({
        month: "2026-09-01",
        payment_type: "taas",
        amount: "6000",
        members: "1",
      }),
    ]);
    const regular = await pool.query(
      sql.load("reports/dashboard/sales-payments.sql"),
      [...bounds, false, false],
    );
    expect(
      regular.rows.some(
        (row) => row.payment_type === "taas" || row.customer_label === "TaaS",
      ),
    ).toBe(false);
  });
});
