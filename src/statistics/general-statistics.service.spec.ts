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
  const service = new GeneralStatisticsService(
    db as unknown as DbService,
    sql as unknown as SqlLoaderService,
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
  });

  it("normalizes country member, skill, and top-member details", async () => {
    db.query.mockResolvedValue([
      {
        country_code: "IND",
        "user.count": "730554",
        top_member: {
          handle: "top-member",
          maxRating: "2200",
          photoURL: null,
          wins: "1768",
        },
        skills: [
          { count: "40", name: "JavaScript" },
          { count: "30", name: "Python" },
          { count: "15", name: "Swift" },
        ],
      },
      {
        country_code: "IN",
        "user.count": "10",
        top_member: {
          handle: "higher-winner",
          maxRating: "2400",
          photoURL: "https://example.com/higher.png",
          wins: "2000",
        },
        skills: [
          { count: "10", name: "javascript" },
          { count: "25", name: "Rust" },
          { count: "20", name: "Go" },
        ],
      },
    ]);

    await expect(service.getCountryMemberDetails()).resolves.toEqual([
      {
        "country.country_name": "India",
        "country.country_code": "IND",
        "user.count": 730564,
        rank: 1,
        skillAssignments: 140,
        topMember: {
          handle: "higher-winner",
          maxRating: 2400,
          photoURL: "https://example.com/higher.png",
          wins: 2000,
        },
        topSkills: [
          { count: 50, name: "JavaScript" },
          { count: 30, name: "Python" },
          { count: 25, name: "Rust" },
        ],
        totalSkills: 5,
      },
    ]);
    expect(sql.load).toHaveBeenCalledWith(
      "reports/statistics/general/country-member-details.sql",
    );
  });
});
