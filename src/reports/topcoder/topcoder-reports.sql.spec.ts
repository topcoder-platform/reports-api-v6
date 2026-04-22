import { SqlLoaderService } from "src/common/sql-loader.service";

describe("Topcoder report SQL", () => {
  const sqlLoader = new SqlLoaderService();

  it("resolves engagement data countries from profile location codes instead of the stale legacy field", () => {
    const sql = sqlLoader.load("reports/topcoder/engagement-data-members.sql");

    expect(sql).toMatch(
      /COALESCE\(\s*NULLIF\(BTRIM\(home_lookup_code\.name\), ''\),\s*NULLIF\(BTRIM\(home_lookup_id\.name\), ''\),\s*NULLIF\(BTRIM\(home_identity_alpha3\.country_name\), ''\),\s*NULLIF\(BTRIM\(home_identity_code\.country_name\), ''\),\s*NULLIF\(BTRIM\(home_identity_alpha2\.country_name\), ''\)\s*\)\s+AS home_country/,
    );
    expect(sql).toMatch(
      /COALESCE\(\s*NULLIF\(BTRIM\(comp_lookup_code\.name\), ''\),\s*NULLIF\(BTRIM\(comp_lookup_id\.name\), ''\),\s*NULLIF\(BTRIM\(comp_identity_alpha3\.country_name\), ''\),\s*NULLIF\(BTRIM\(comp_identity_code\.country_name\), ''\),\s*NULLIF\(BTRIM\(comp_identity_alpha2\.country_name\), ''\)\s*\)\s+AS competition_country/,
    );
    expect(sql).not.toMatch(/NULLIF\(BTRIM\(m\.country\), ''\)/);
  });
});
