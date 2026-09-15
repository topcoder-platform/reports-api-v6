import { readFileSync } from "fs";
import { resolve } from "path";
import { Client } from "pg";

const databaseTests = process.env.WIN_TEST_DATABASE_URL ? describe : describe.skip;

// Run against a disposable PostgreSQL database with the projects-api-v6 migrations applied.
// All fixture writes are rolled back, including when an assertion fails.
databaseTests("WIN report SQL with PostgreSQL", () => {
  const db = new Client({ connectionString: process.env.WIN_TEST_DATABASE_URL });
  const sql = readFileSync(resolve(process.cwd(), "sql/reports/win/showcase.sql"), "utf8");
  const projectId = "9007199254740993";

  beforeAll(async () => {
    await db.connect();
    await db.query("BEGIN");
    await db.query(`
      CREATE SCHEMA challenges;
      CREATE SCHEMA resources;
      CREATE SCHEMA members;
      CREATE SCHEMA skills;
      CREATE TABLE challenges."Challenge" (id text PRIMARY KEY, name text, "trackId" text, "numOfRegistrants" integer, "numOfSubmissions" integer);
      CREATE TABLE challenges."ChallengeTrack" (id text PRIMARY KEY, name text);
      CREATE TABLE challenges."ChallengeSkill" ("challengeId" text, "skillId" text);
      CREATE TABLE skills.skill (id uuid PRIMARY KEY, name text);
      CREATE TABLE resources."ResourceRole" (id text PRIMARY KEY, name text);
      CREATE TABLE resources."Resource" ("challengeId" text, "memberId" text, "roleId" text);
      CREATE TABLE members.member ("userId" bigint PRIMARY KEY, "competitionCountryCode" text, country text, "homeCountryCode" text);
      INSERT INTO challenges."Challenge" VALUES ('challenge-id', 'Linked challenge', 'track-id', 3, 2);
      INSERT INTO challenges."ChallengeTrack" VALUES ('track-id', 'Development');
      INSERT INTO challenges."ChallengeSkill" VALUES ('challenge-id', '11111111-1111-4111-8111-111111111111');
      INSERT INTO skills.skill VALUES ('11111111-1111-4111-8111-111111111111', 'Skill');
      INSERT INTO resources."ResourceRole" VALUES ('submitter', 'Submitter'), ('reviewer', 'Reviewer');
      INSERT INTO resources."Resource" VALUES ('challenge-id', '42', 'submitter'), ('challenge-id', '43', 'reviewer');
      INSERT INTO members.member VALUES (42, 'US', 'CA', 'GB'), (43, 'AU', 'AU', 'AU');
      INSERT INTO projects.projects
        (id, name, type, status, details, "lastActivityAt", "lastActivityUserId", "updatedAt", "createdBy", "updatedBy", "deletedAt")
      VALUES
        (9007199254740993, 'WIN project', 'app', 'active',
          '{"customer":"Customer","smu":"Europe","dealCloseDate":"2026-09-16","unrelated":true}', now(), '42', now(), 42, 42, NULL),
        (9007199254740994, 'Deleted project', 'app', 'active', '{}', now(), '42', now(), 42, 42, now());
      INSERT INTO projects.project_showcase_posts
        (id, title, content, status, "projectId", "createdById", "updatedById", "updatedAt", type, challenge,
          "businessImpact", "keyWin", "currentStatus", owner, "sendToWin", "challengeIds")
      VALUES
        (9007199254740993, 'Draft opt-in', 'Solution', 'DRAFT', 9007199254740993, 42, 42, now(),
          'Open Innovation', 'Challenge', 'Impact', 'Win', 'Delivered', 'Owner', true, ARRAY['challenge-id']),
        (9007199254740994, 'Published opt-in', 'Solution', 'PUBLISHED', 9007199254740993, 42, 42, now(),
          NULL, NULL, NULL, NULL, NULL, NULL, true, ARRAY[]::text[]),
        (9007199254740995, 'Not shared', 'Solution', 'PUBLISHED', 9007199254740993, 42, 42, now(),
          NULL, NULL, NULL, NULL, NULL, NULL, false, ARRAY[]::text[]),
        (9007199254740996, 'Archived', 'Solution', 'ARCHIVED', 9007199254740993, 42, 42, now(),
          NULL, NULL, NULL, NULL, NULL, NULL, true, ARRAY[]::text[]),
        (9007199254740997, 'Deleted project post', 'Solution', 'PUBLISHED', 9007199254740994, 42, 42, now(),
          NULL, NULL, NULL, NULL, NULL, NULL, true, ARRAY[]::text[]);
      INSERT INTO projects.project_post_industries (id, name) VALUES (9007199254740993, 'WIN industry');
      INSERT INTO projects.project_post_categories (id, name) VALUES (9007199254740993, 'WIN technology');
      INSERT INTO projects.project_showcase_post_industries ("projectShowcasePostId", "industryId")
        VALUES (9007199254740993, 9007199254740993);
      INSERT INTO projects.project_showcase_post_categories ("projectShowcasePostId", "categoryId")
        VALUES (9007199254740993, 9007199254740993);
      INSERT INTO projects.project_showcase_post_media ("projectShowcasePostId", type, url, "createdBy")
        VALUES (9007199254740993, 'image/png', 'https://example.com/win.png', 42);
      SAVEPOINT fixture;
    `);
  });

  afterEach(async () => { await db.query("ROLLBACK TO SAVEPOINT fixture"); });
  afterAll(async () => { await db.query("ROLLBACK"); await db.end(); });

  it("includes opted-in drafts and published posts, with complete metadata and precise IDs", async () => {
    const result = (await db.query(sql, [null, 100, 0])).rows[0];
    expect(result.total).toBe(2);
    expect(result.data).toHaveLength(2);
    expect(result.data[0]).toMatchObject({
      id: projectId, projectId, title: "Draft opt-in", type: "Open Innovation", content: "Solution",
      challenge: "Challenge", businessImpact: "Impact", keyWin: "Win", currentStatus: "Delivered", owner: "Owner",
      customer: "Customer", smu: "Europe", dealCloseDate: "2026-09-16", challengeIds: ["challenge-id"],
      project: { id: projectId, details: { unrelated: true } },
      challengeMetadata: [{
        challengeId: 'challenge-id', name: 'Linked challenge', numOfRegistrants: 3, numOfSubmissions: 2,
        track: 'Development', countries: ['US'], skills: [{ id: '11111111-1111-4111-8111-111111111111', name: 'Skill' }],
      }],
      industries: [{ id: projectId, name: "WIN industry" }],
      categories: [{ id: projectId, name: "WIN technology" }],
      media: [{ url: "https://example.com/win.png", createdBy: "42" }],
    });
  });

  it("reads project edits immediately and removes an opt-out from the result", async () => {
    await db.query(`UPDATE projects.projects SET details = details || '{"customer":"Updated","smu":"Others","smuOther":"Custom"}' WHERE id = $1`, [projectId]);
    expect((await db.query(sql, [projectId, 100, 0])).rows[0].data[0]).toMatchObject({
      customer: "Updated", smu: "Others", smuOther: "Custom",
    });
    await db.query('UPDATE projects.project_showcase_posts SET "sendToWin" = false WHERE id = $1', [projectId]);
    expect((await db.query(sql, [projectId, 100, 0])).rows[0].total).toBe(1);
  });

  it("paginates deterministically and returns a count even for an empty page", async () => {
    expect((await db.query(sql, [projectId, 1, 1])).rows[0].data[0].id).toBe("9007199254740994");
    expect((await db.query(sql, [projectId, 1, 2])).rows[0]).toEqual({ data: [], total: 2 });
    expect((await db.query(sql, ["1", 100, 0])).rows[0]).toEqual({ data: [], total: 0 });
  });
});
