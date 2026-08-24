import { SqlLoaderService } from "../common/sql-loader.service";

describe("Expert skills statistics SQL", () => {
  const sqlLoader = new SqlLoaderService();

  it("aggregates category members, skills, and top win breakdown", () => {
    const sql = sqlLoader.load(
      "reports/statistics/expert-skills/category-stats.sql",
    );

    expect(sql).toContain("unnest($1::uuid[])");
    expect(sql).toContain("FROM skills.skill sk");
    expect(sql).toContain("FROM skills.user_skill us");
    expect(sql).toContain("FROM skills.skill_event se");
    expect(sql).toContain("challenge_win");
    expect(sql).toContain("gig_completion");
    expect(sql).toContain("ts.rn <= 3");
    expect(sql).not.toContain("NOT ILIKE 'Test Cat%'");
  });

  it("returns top members by category wins", () => {
    const sql = sqlLoader.load(
      "reports/statistics/expert-skills/category-members.sql",
    );

    expect(sql).toContain("sk.category_id = $1::uuid");
    expect(sql).toContain("JOIN members.member m");
    expect(sql).toContain('members."memberMaxRating"');
    expect(sql).toContain("ORDER BY cw.wins DESC, m.handle ASC");
    expect(sql).toContain("LIMIT $2");
  });
});
