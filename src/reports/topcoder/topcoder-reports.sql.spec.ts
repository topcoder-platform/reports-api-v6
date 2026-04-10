import { SqlLoaderService } from "src/common/sql-loader.service";

describe("Topcoder report SQL", () => {
  const sqlLoader = new SqlLoaderService();

  it("uses profile-style country precedence for engagement data members", () => {
    const sql = sqlLoader.load("reports/topcoder/engagement-data-members.sql");

    expect(sql).toMatch(
      /COALESCE\(\s*home_code\.name,\s*home_id\.name,\s*comp_code\.name,\s*comp_id\.name,\s*NULLIF\(BTRIM\(m\."homeCountryCode"\), ''\),\s*NULLIF\(BTRIM\(m\."competitionCountryCode"\), ''\),\s*NULLIF\(BTRIM\(m\.country\), ''\)\s*\)\s+AS country/,
    );
  });
});
