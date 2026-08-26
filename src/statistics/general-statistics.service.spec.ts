import { ConfigService } from "@nestjs/config";
import { DbService } from "../db/db.service";
import { SqlLoaderService } from "../common/sql-loader.service";
import { GeneralStatisticsService } from "./general-statistics.service";

describe("GeneralStatisticsService", () => {
  const db = {
    query: jest.fn(),
  };
  const sql = {
    load: jest.fn().mockReturnValue("SELECT tooltip data"),
  };
  const config = {
    get: jest.fn().mockReturnValue('["Task","First2Finish"]'),
  };
  const service = new GeneralStatisticsService(
    db as unknown as DbService,
    sql as unknown as SqlLoaderService,
    config as unknown as ConfigService,
  );

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it("normalizes top winners and nullable profile fields", async () => {
    db.query.mockResolvedValue([
      {
        country_code: "IND",
        "challenge_stats.count": "42",
        rank: "2",
        top_winners: [
          {
            handle: "winner",
            maxRating: "1499",
            photoURL: null,
            wins: "12",
          },
          {
            handle: "newcomer",
            maxRating: null,
            photoURL: "https://example.com/avatar.png",
            wins: 5,
          },
        ],
      },
    ]);

    await expect(service.getTopWinnersByCountry()).resolves.toEqual([
      {
        "country.country_name": "India",
        "challenge_stats.count": 42,
        rank: 2,
        topWinners: [
          {
            handle: "winner",
            maxRating: 1499,
            photoURL: null,
            wins: 12,
          },
          {
            handle: "newcomer",
            maxRating: null,
            photoURL: "https://example.com/avatar.png",
            wins: 5,
          },
        ],
      },
    ]);
    expect(sql.load).toHaveBeenCalledWith(
      "reports/statistics/general/top-winners-by-country.sql",
    );
    expect(db.query).toHaveBeenCalledWith(
      "SELECT tooltip data",
      [["Task", "First2Finish"]],
    );
  });

  it("uses safe defaults when winner details are absent", async () => {
    db.query.mockResolvedValue([
      {
        country_code: null,
        "challenge_stats.count": null,
        rank: null,
        top_winners: null,
      },
    ]);

    await expect(service.getTopWinnersByCountry()).resolves.toEqual([
      {
        "country.country_name": "",
        "challenge_stats.count": 0,
        rank: null,
        topWinners: [],
      },
    ]);
    expect(db.query).toHaveBeenCalledWith(
      "SELECT tooltip data",
      [["Task", "First2Finish"]],
    );
  });

  it("normalizes country member, skill, and top-member details", async () => {
    db.query.mockResolvedValue([
      {
        country_code: "IND",
        "user.count": "730554",
        top_members: [
          {
            handle: "top-member",
            maxRating: "2200",
            photoURL: null,
            wins: "1768",
          },
          {
            handle: "third-member",
            maxRating: null,
            photoURL: null,
            wins: "100",
          },
        ],
        skills: [
          { count: "50", name: "JavaScript", ownedCount: "50" },
          { count: "30", name: "Python", ownedCount: "30" },
          { count: "20", name: "Swift", ownedCount: "20" },
        ],
      },
      {
        country_code: "IN",
        "user.count": "10",
        top_members: [
          {
            handle: "higher-winner",
            maxRating: "2400",
            photoURL: "https://example.com/higher.png",
            wins: "2000",
          },
          {
            handle: "second-member",
            maxRating: "2300",
            photoURL: null,
            wins: "1800",
          },
        ],
        skills: [
          { count: "10", name: "javascript", ownedCount: "10" },
          { count: "25", name: "Rust", ownedCount: "25" },
          { count: "15", name: "Go", ownedCount: "15" },
        ],
      },
    ]);

    await expect(service.getCountryMemberDetails()).resolves.toEqual([
      {
        "country.country_name": "India",
        "country.country_code": "IND",
        "user.count": 730564,
        rank: 1,
        skillsBreakdown: [
          { count: 60, name: "JavaScript", percentage: 40 },
          { count: 30, name: "Python", percentage: 20 },
          {
            count: 25,
            name: "Rust",
            percentage: 16.666666666666664,
          },
        ],
        totalSkills: 5,
        topMembers: [
          {
            handle: "higher-winner",
            maxRating: 2400,
            photoURL: "https://example.com/higher.png",
            wins: 2000,
          },
          {
            handle: "second-member",
            maxRating: 2300,
            photoURL: null,
            wins: 1800,
          },
          {
            handle: "top-member",
            maxRating: 2200,
            photoURL: null,
            wins: 1768,
          },
        ],
      },
    ]);
    expect(sql.load).toHaveBeenCalledWith(
      "reports/statistics/general/country-member-details.sql",
    );
    expect(db.query).toHaveBeenCalledWith(
      "SELECT tooltip data",
      [["Task", "First2Finish"]],
    );
  });
});
