import { Client } from "pg";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { ActiveMemberActivityDto } from "./dashboard-reports.dto";

const databaseUrl = process.env.REPORTS_TEST_DATABASE_URL;
const integration = databaseUrl ? describe : describe.skip;

// Explicitly opt in with an empty disposable database; schema setup is rolled back.
integration("Active member SQL against PostgreSQL", () => {
  const db = new Client({ connectionString: databaseUrl });
  const sql = new SqlLoaderService();
  const range = ["2026-02-01T00:00:00.000Z", "2026-03-01T00:00:00.000Z"];

  beforeAll(async () => {
    await db.connect();
    await db.query(`BEGIN;
      SET TIME ZONE 'Pacific/Auckland';
      CREATE SCHEMA finance; CREATE SCHEMA resources; CREATE SCHEMA challenges;
      CREATE SCHEMA members; CREATE SCHEMA engagements;
      CREATE TABLE finance.winnings (winning_id text, winner_id text, type text, title text, category text);
      CREATE TABLE finance.payment (payment_id text, winnings_id text, version int, payment_status text, date_paid timestamp, created_at timestamp);
      CREATE TABLE resources."ResourceRole" (id text, name text, "nameLower" text);
      CREATE TABLE resources."Resource" (id text, "memberId" text, "memberHandle" text, "roleId" text, "challengeId" text, "createdAt" timestamp);
      CREATE TABLE challenges."Challenge" (id text, name text);
      CREATE TABLE members.member ("userId" bigint, handle text);
      CREATE TABLE engagements."Engagement" (id text, title text);
      CREATE TABLE engagements."EngagementApplication" (id text, "userId" text, handle text, "createdAt" timestamp, "engagementId" text, status text);
      CREATE TABLE engagements."EngagementAssignment" (id text, "memberId" text, "memberHandle" text, "acceptedAt" timestamp, "createdAt" timestamp, "updatedAt" timestamp, "engagementId" text, status text);
      INSERT INTO finance.winnings VALUES
        ('w1','1','PAYMENT','Topgear payout','TOPGEAR_PAYMENT'), ('w2','2','PAYMENT','Owed','TASK_PAYMENT'),
        ('w3','3','PAYMENT','Cancelled','TASK_PAYMENT'), ('w4','4','PAYMENT','End boundary','TASK_PAYMENT'),
        ('w5','5','PAYMENT','Legacy paid','TASK_PAYMENT'), ('w6','6','OTHER','Not payment','TASK_PAYMENT');
      INSERT INTO finance.payment VALUES
        ('p1-old','w1',1,'PAID','2026-02-01','2026-01-01'),
        ('p1','w1',2,'PAID','2026-02-01','2026-01-01'),
        ('p2','w2',1,'OWED',null,'2026-02-10'),
        ('p3-old','w3',1,'PAID','2026-02-10','2026-02-01'),
        ('p3','w3',2,'CANCELLED','2026-02-10','2026-02-01'),
        ('p4','w4',1,'PAID','2026-03-01','2026-02-01'),
        ('p5','w5',1,'PAID',null,'2026-02-20'),
        ('p6','w6',1,'PAID','2026-02-10','2026-02-01');
      INSERT INTO members.member VALUES (1,'current-handle');
      INSERT INTO challenges."Challenge" VALUES ('c1','Open Challenge');
      INSERT INTO resources."ResourceRole" VALUES ('submitter','Submitter','submitter'), ('reviewer','Reviewer','reviewer'), ('registrant','Registrant','registrant');
      INSERT INTO resources."Resource" VALUES
        ('r1','1','old-handle','submitter','c1','2026-02-28 23:59:59.999'),
        ('r2','2','reviewer','reviewer','c1','2026-02-20'),
        ('r3','3','next-month','submitter','c1','2026-03-01'),
        ('r4','4','registrant','registrant','c1','2026-02-01');
      INSERT INTO engagements."Engagement" VALUES ('e1','Engagement');
      INSERT INTO engagements."EngagementApplication" VALUES
        ('a1','1','applicant','2026-02-01','e1','REJECTED'),
        ('a2','2','outside','2026-03-01','e1','SUBMITTED');
      INSERT INTO engagements."EngagementAssignment" VALUES
        ('s1','1','accepted','2026-02-10','2026-01-01','2026-04-01','e1','COMPLETED'),
        ('s2','2','selected',null,'2026-02-10','2026-02-10','e1','SELECTED'),
        ('s3','3','unknown',null,'2026-02-10','2026-02-10','e1','ASSIGNED');
    `);
  });
  afterAll(async () => {
    await db.query("ROLLBACK");
    await db.end();
  });

  it("uses actual payouts, latest versions, all payment categories, registration roles, and UTC bounds", async () => {
    const result = await db.query<ActiveMemberActivityDto>(
      sql.load("reports/dashboard/active-members.sql"),
      range,
    );
    expect(result.rows.map((row) => row.id)).toEqual([
      "registration:r1",
      "payment:p5",
      "payment:p1",
      "registration:r4",
    ]);
    expect(result.rows[0]).toMatchObject({
      handle: "current-handle",
      date: "2026-02-28T23:59:59.999Z",
    });
    expect(result.rows[1].handle).toBe("5");
  });

  it("retains applications after rejection and acceptance in its original month after assignment edits", async () => {
    const result = await db.query<ActiveMemberActivityDto>(
      sql.load("reports/dashboard/active-members-engagements.sql"),
      range,
    );
    expect(result.rows.map((row) => row.id)).toEqual([
      "acceptance:s1",
      "application:a1",
    ]);
    expect(result.rows[0].date).toBe("2026-02-10T00:00:00.000Z");
  });

  it("supports pre-migration engagement schemas without inventing acceptance dates", async () => {
    await db.query(
      'ALTER TABLE engagements."EngagementAssignment" DROP COLUMN "acceptedAt"',
    );
    const result = await db.query<ActiveMemberActivityDto>(
      sql.load("reports/dashboard/active-members-engagements.sql"),
      range,
    );
    expect(result.rows.map((row) => row.id)).toEqual(["application:a1"]);
  });
});
