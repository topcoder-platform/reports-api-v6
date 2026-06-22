import { SqlLoaderService } from "src/common/sql-loader.service";

describe("Challenge export SQL", () => {
  const sqlLoader = new SqlLoaderService();

  const challengeUserSqlPaths = [
    "reports/challenges/submitters.sql",
    "reports/challenges/valid-submitters.sql",
    "reports/challenges/winners.sql",
  ];

  it.each(challengeUserSqlPaths)(
    "uses completed, non-failed Marathon Match final scores in %s",
    (sqlPath) => {
      const sql = sqlLoader.load(sqlPath);

      expect(sql).toContain(`(c.status = 'COMPLETED') AS is_completed`);
      expect(sql).toContain("WHEN NOT cc.is_completed THEN NULL");
      expect(sql).toContain("TRUE AS has_final_review");
      expect(sql).toContain(`WHEN s.status IN (`);
      expect(sql).toContain("WHEN final_review.has_final_review THEN CASE");
      expect(sql).toContain(
        `WHEN final_review."aggregateScore" >= 0 THEN final_review."aggregateScore"`,
      );
      expect(sql).toContain(
        `WHEN s."finalScore"::double precision >= 0 THEN s."finalScore"::double precision`,
      );
    },
  );

  it.each(challengeUserSqlPaths)(
    "uses only non-failed Marathon Match provisional score fallbacks in %s",
    (sqlPath) => {
      const sql = sqlLoader.load(sqlPath);

      expect(sql).toContain(
        "WHEN provisional_review.provisional_score IS NOT NULL THEN provisional_review.provisional_score",
      );
      expect(sql).toContain(
        `WHEN s."initialScore"::double precision >= 0 THEN s."initialScore"::double precision`,
      );
      expect(sql).toContain(`'FAILED_REVIEW'`);
      expect(sql).toContain(`'DELETED'`);
    },
  );

  it.each(challengeUserSqlPaths)(
    "filters failed negative Marathon Match provisional scores in %s",
    (sqlPath) => {
      const sql = sqlLoader.load(sqlPath);

      expect(sql).toContain(`AND rs."aggregateScore" >= 0`);
    },
  );

  it.each([
    "reports/challenges/submitters.sql",
    "reports/challenges/valid-submitters.sql",
  ])("only ranks completed Marathon Match submissions in %s", (sqlPath) => {
    const sql = sqlLoader.load(sqlPath);

    expect(sql).toContain(
      "WHEN mlss.is_completed AND mlss.final_score_raw IS NOT NULL THEN ROW_NUMBER() OVER",
    );
    expect(sql).toMatch(
      /WHERE\s+\w+\.provisional_score IS NOT NULL\s+OR \w+\.final_score_raw IS NOT NULL/,
    );
    expect(sql).toMatch(
      /WHEN \w+\.is_marathon_match AND mrs\."finalRank" IS NULL THEN mrs\."provisionalScore"/,
    );
  });

  it("only returns Marathon Match winner finalRank for completed challenges", () => {
    const sql = sqlLoader.load("reports/challenges/winners.sql");

    expect(sql).toContain(
      "WHEN wm.is_marathon_match AND wm.is_completed THEN wm.placement",
    );
  });
});
