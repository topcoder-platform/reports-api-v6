import { SqlLoaderService } from "../../common/sql-loader.service";

describe("Dashboard report SQL", () => {
  const sqlLoader = new SqlLoaderService();

  it.each([
    "new-signups.sql",
    "members-paid.sql",
    "challenge-participation.sql",
  ])(
    "uses a half-open range and emits zero-filled calendar months: %s",
    (file) => {
      const sql = sqlLoader.load(`reports/dashboard/${file}`);

      expect(sql).toContain("$1::timestamptz");
      expect(sql).toContain("$2::timestamptz");
      expect(sql).toContain("GENERATE_SERIES");
      expect(sql).toContain("INTERVAL '1 microsecond'");
      expect(sql).toMatch(/activity_at|paid_at|create_date/);
      expect(sql).toContain("COALESCE(");
      expect(sql).toContain("ORDER BY m.month_start");
    },
  );

  it("splits signups by current identity activation status", () => {
    const sql = sqlLoader.load("reports/dashboard/new-signups.sql");

    expect(sql).toContain('FROM identity."user" u');
    expect(sql).toContain("u.status = 'A'");
    expect(sql).toContain("u.status <> 'A'");
    expect(sql).toContain("AS activation_rate");
    expect(sql).toContain("AS peak_month_signups");
  });

  it("counts paid members once per canonical payment bucket and month", () => {
    const sql = sqlLoader.load("reports/dashboard/members-paid.sql");

    expect(sql).toContain("p.payment_status = 'PAID'");
    expect(sql).toContain("w.type = 'PAYMENT'");
    expect(sql).toContain("COALESCE(p.date_paid, p.created_at)");
    expect(sql).toContain("w.category::text = 'TAAS_PAYMENT'");
    expect(sql).toContain("w.category::text = 'ENGAGEMENT_PAYMENT'");
    expect(sql).toContain("'TASK_REVIEW_PAYMENT'");
    expect(sql).toContain("'TASK_COPILOT_PAYMENT'");
    expect(sql).toContain(
      "w.category::text IS DISTINCT FROM 'TOPGEAR_PAYMENT'",
    );
    expect(sql).toMatch(/COUNT\(DISTINCT pe\.member_id\) FILTER/g);
  });

  it("counts registration and submission activity independently", () => {
    const sql = sqlLoader.load("reports/dashboard/challenge-participation.sql");

    expect(sql).toContain('FROM resources."Resource" r');
    expect(sql).toContain('JOIN resources."ResourceRole" rr');
    expect(sql).toContain("= 'submitter'");
    expect(sql).toContain("FROM reviews.submission s");
    expect(sql).toContain("s.status <> 'DELETED'");
    expect(sql).toContain('COALESCE(s."submittedDate", s."createdAt")');
    expect(sql).toContain("COUNT(DISTINCT re.member_id)");
    expect(sql).toContain("COUNT(DISTINCT se.member_id)");
    expect(sql).toContain("LEAST(");
  });
});
