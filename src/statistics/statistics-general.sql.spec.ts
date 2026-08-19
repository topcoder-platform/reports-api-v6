import { SqlLoaderService } from "../common/sql-loader.service";

describe("General statistics SQL", () => {
  const sqlLoader = new SqlLoaderService();

  function expectSubmissionWins(sql: string) {
    expect(sql).toContain("FROM reviews.submission s");
    expect(sql).toContain("s.placement = 1");
    expect(sql).toContain('JOIN challenges."Challenge" c');
    expect(sql).toContain('LEFT JOIN challenges."ChallengeType" ct');
    expect(sql).toContain("NOT ct.name = ANY($1)");
    expect(sql).toContain(
      'SELECT DISTINCT\n    s."memberId"::text AS member_id',
    );
    expect(sql).not.toContain('members."memberStats"');
    expect(sql).not.toContain('challenges."ChallengeWinner"');
  }

  function expectMemberStatsWins(sql: string) {
    expect(sql).toContain('FROM members."memberStats" stats');
    expect(sql).toContain('FROM members."memberStatsHistory" history');
    expect(sql).toContain("history.placement = 1");
    expect(sql).toContain('stats."isPrivate" = false');
    expect(sql).toContain("SUM(COALESCE(stats.wins, history.wins, 0))");
    expect(sql).toContain('JOIN challenges."ChallengeTrack" track');
    expect(sql).not.toContain('challenges."ChallengeWinner"');
    expect(sql).not.toContain("reviews.submission");
  }

  it("returns at most three deterministically ranked winners per country", () => {
    const sql = sqlLoader.load(
      "reports/statistics/general/top-winners-by-country.sql",
    );

    expectSubmissionWins(sql);
    expect(sql).toContain("PARTITION BY country_code");
    expect(sql).toContain("ORDER BY wins DESC, handle ASC, user_id ASC");
    expect(sql).toContain("winner_rank <= 3");
    expect(sql).toContain('m."photoURL" AS photo_url');
    expect(sql).toContain('members."memberMaxRating"');
    expect(sql).toContain("'maxRating', max_rating");
    expect(sql).toContain('first_place_count AS "challenge_stats.count"');
  });

  it("aggregates owned skills and three deterministic top members", () => {
    const sql = sqlLoader.load(
      "reports/statistics/general/country-member-details.sql",
    );

    expect(sql).toContain("NULLIF(TRIM(m.\"homeCountryCode\"), '')");
    expect(sql).toContain("JOIN skills.user_skill user_skill");
    expect(sql).toContain("JOIN skills.user_skill_level skill_level");
    expect(sql).toContain(
      "LOWER(skill_level.name) IN ('verified', 'self-declared')",
    );
    expect(sql).toContain("COUNT(*)::bigint AS owned_count");
    expect(sql).not.toContain("user_skill_win_summary");
    expect(sql).toContain("'ownedCount', owned_count");
    expect(sql).toContain("JOIN skills.skill skill");
    expect(sql).toContain("skill.deleted_at IS NULL");
    expect(sql).toContain("ORDER BY owned_count DESC, name ASC, skill_id ASC");
    expect(sql).toContain("AS skills");
    expect(sql).not.toContain("skill_rank <= 3");
    expectMemberStatsWins(sql);
    expect(sql).toContain("ORDER BY wins DESC, handle ASC, user_id ASC");
    expect(sql).toContain("member_rank <= 3");
    expect(sql).toContain('countries.members_count AS "user.count"');
  });

  it("uses first place submissions for country totals", () => {
    const sql = sqlLoader.load(
      "reports/statistics/general/first-place-by-country.sql",
    );

    expectSubmissionWins(sql);
    expect(sql).toContain('first_place_count AS "challenge_stats.count"');
  });
});
