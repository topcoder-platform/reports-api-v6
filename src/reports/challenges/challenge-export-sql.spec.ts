import { SqlLoaderService } from "src/common/sql-loader.service";

describe("Challenge export SQL", () => {
  const sqlLoader = new SqlLoaderService();

  it.each([
    "reports/challenges/submitters.sql",
    "reports/challenges/valid-submitters.sql",
    "reports/challenges/winners.sql",
  ])(
    "falls back to submission.finalScore in %s when no final review summary exists",
    (sqlPath) => {
      const sql = sqlLoader.load(sqlPath);

      expect(sql).toMatch(
        /COALESCE\(\s*final_review\."aggregateScore",\s*s\."finalScore"::double precision\s*\)\s+AS final_score_raw/,
      );
    },
  );
});
