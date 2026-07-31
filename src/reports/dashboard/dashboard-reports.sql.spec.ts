import { SqlLoaderService } from "../../common/sql-loader.service";

describe("Dashboard report SQL", () => {
  const sqlLoader = new SqlLoaderService();

  it.each([
    "new-signups.sql",
    "members-paid.sql",
    "challenge-participation.sql",
    "member-payment-by-month.sql",
    "member-payment-by-customer.sql",
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

  it("counts projected members once per canonical payment bucket and month", () => {
    const sql = sqlLoader.load("reports/dashboard/members-paid.sql");

    expect(sql).toContain("MAX(p.version) AS max_version");
    expect(sql).toContain("lpv.max_version = p.version");
    expect(sql).toContain("p.payment_status IS DISTINCT FROM 'CANCELLED'");
    expect(sql).toContain("w.type = 'PAYMENT'");
    expect(sql).toContain("p.created_at AS activity_at");
    expect(sql).not.toContain("p.payment_status = 'PAID'");
    expect(sql).not.toContain("p.date_paid");
    expect(sql).toContain("w.category::text = 'TAAS_PAYMENT'");
    expect(sql).toContain("w.category::text = 'ENGAGEMENT_PAYMENT'");
    expect(sql).toContain("'TASK_REVIEW_PAYMENT'");
    expect(sql).toContain("'TASK_COPILOT_PAYMENT'");
    expect(sql).toContain(
      "w.category::text IS DISTINCT FROM 'TOPGEAR_PAYMENT'",
    );
    expect(sql).toMatch(/COUNT\(DISTINCT pe\.member_id\) FILTER/g);
  });

  it("sums latest paid-member values by canonical payment bucket", () => {
    const sql = sqlLoader.load("reports/dashboard/member-payment-by-month.sql");

    expect(sql).toContain("MAX(p.version) AS max_version");
    expect(sql).toContain("lpv.max_version = p.version");
    expect(sql).toContain("p.payment_status = 'PAID'");
    expect(sql).toContain("w.type = 'PAYMENT'");
    expect(sql).toContain("COALESCE(p.date_paid, p.created_at)");
    expect(sql).toContain(
      "COALESCE(p.gross_amount, p.total_amount, 0) AS amount",
    );
    expect(sql).toContain("w.category::text = 'TAAS_PAYMENT'");
    expect(sql).toContain("w.category::text = 'ENGAGEMENT_PAYMENT'");
    expect(sql).toContain("'TASK_REVIEW_PAYMENT'");
    expect(sql).toContain(
      "w.category::text IS DISTINCT FROM 'TOPGEAR_PAYMENT'",
    );
    expect(sql).toMatch(/SUM\(pe\.amount\) FILTER/g);
  });

  it("ranks five clients once and zero-fills an Other Customers series", () => {
    const sql = sqlLoader.load(
      "reports/dashboard/member-payment-by-customer.sql",
    );

    expect(sql).toContain("MAX(p.version) AS max_version");
    expect(sql).toContain("p.payment_status = 'PAID'");
    expect(sql).toContain(
      "COALESCE(p.gross_amount, p.total_amount, 0) AS amount",
    );
    expect(sql).toContain('LEFT JOIN challenges."ChallengeBilling" cb');
    expect(sql).toContain(
      'LEFT JOIN "billing-accounts"."BillingAccount" payment_ba',
    );
    expect(sql).toContain(
      'LEFT JOIN "billing-accounts"."BillingAccount" challenge_ba',
    );
    expect(sql).toContain('LEFT JOIN "billing-accounts"."Client" cl');
    expect(sql).toContain("payment_ba.id::text");
    expect(sql).toContain("challenge_ba.id::text");
    expect(sql).toContain("TRIM(LEADING '0'");
    expect(sql).toContain(
      'COALESCE(payment_ba."clientId", challenge_ba."clientId")',
    );
    expect(sql).not.toContain("::integer");
    expect(sql).toContain("ROW_NUMBER() OVER");
    expect(sql).toContain("ct.total_amount DESC");
    expect(sql).toContain("WHERE rc.series_order <= 5");
    expect(sql).toContain("'other-customers' AS series_key");
    expect(sql).toContain("'Other Customers' AS customer_label");
    expect(sql).toContain("CROSS JOIN series s");
    expect(sql).toContain("COALESCE(ma.amount, 0) AS amount");
  });

  it("counts registrants and linked submitters by challenge completion cohort", () => {
    const sql = sqlLoader.load("reports/dashboard/challenge-participation.sql");

    expect(sql).toContain('FROM challenges."Challenge" c');
    expect(sql).toContain('JOIN challenges."ChallengeType" ct');
    expect(sql).toContain(
      "ct.name IN ('Challenge', 'Marathon Match', 'First2Finish')",
    );
    expect(sql).toContain('FROM challenges."ChallengePhase" cp');
    expect(sql).toContain('lp."actualEndDate" AS activity_at');
    expect(sql).toContain('ORDER BY cp."scheduledEndDate" DESC');
    expect(sql).toContain('JOIN resources."Resource" r');
    expect(sql).toContain('JOIN resources."ResourceRole" rr');
    expect(sql).toContain("= 'submitter'");
    expect(sql).toContain("FROM reviews.submission s");
    expect(sql).toContain('s."challengeId" = re.challenge_id');
    expect(sql).toContain('s."memberId" = re.member_id');
    expect(sql).toContain("s.status <> 'DELETED'");
    expect(sql).not.toContain('r."createdAt" AS activity_at');
    expect(sql).not.toContain('COALESCE(s."submittedDate", s."createdAt")');
    expect(sql).toContain("COUNT(DISTINCT re.member_id)");
    expect(sql).toContain("COUNT(DISTINCT se.member_id)");
    expect(sql).toContain("LEAST(");
  });
});
