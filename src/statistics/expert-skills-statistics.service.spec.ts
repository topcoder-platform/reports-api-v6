import { NotFoundException } from "@nestjs/common";
import { DbService } from "../db/db.service";
import { SqlLoaderService } from "../common/sql-loader.service";
import { ExpertSkillsStatisticsService } from "./expert-skills-statistics.service";

describe("ExpertSkillsStatisticsService", () => {
  const db = {
    query: jest.fn(),
  };
  const sql = {
    load: jest.fn().mockReturnValue("SELECT expert skills"),
  };
  const service = new ExpertSkillsStatisticsService(
    db as unknown as DbService,
    sql as unknown as SqlLoaderService,
  );

  beforeEach(() => {
    jest.clearAllMocks();
    sql.load.mockReturnValue("SELECT expert skills");
  });

  it("maps catalog categories to stats and normalized sizes", async () => {
    db.query
      .mockResolvedValueOnce([
        {
          id: "481b5ebc-2fe6-45ed-a90c-736936d458d7",
          name: "Programming and Development",
        },
        {
          id: "1f5ed3e8-8d22-44ea-b75d-ea85147a04da",
          name: "Scripting and Automation",
        },
      ])
      .mockResolvedValueOnce([
        {
          id: "481b5ebc-2fe6-45ed-a90c-736936d458d7",
          totalMembers: 101,
          totalSkills: 50,
          totalWins: 10000,
          skillsBreakdown: [{ name: "JavaScript", percentage: 40 }],
        },
        {
          id: "1f5ed3e8-8d22-44ea-b75d-ea85147a04da",
          totalMembers: 10,
          totalSkills: 4,
          totalWins: 4,
          skillsBreakdown: [],
        },
      ]);

    const result = await service.getCategories();

    expect(sql.load).toHaveBeenCalledWith(
      "reports/statistics/expert-skills/categories.sql",
    );
    expect(sql.load).toHaveBeenCalledWith(
      "reports/statistics/expert-skills/category-stats.sql",
    );
    expect(db.query).toHaveBeenNthCalledWith(1, "SELECT expert skills");
    expect(db.query).toHaveBeenNthCalledWith(2, "SELECT expert skills", [
      [
        "481b5ebc-2fe6-45ed-a90c-736936d458d7",
        "1f5ed3e8-8d22-44ea-b75d-ea85147a04da",
      ],
    ]);
    expect(result[0]).toEqual(
      expect.objectContaining({
        id: "481b5ebc-2fe6-45ed-a90c-736936d458d7",
        name: "Programming and Development",
        officialName: "Programming and Development",
        size: 10,
        totalMembers: 101,
        totalSkills: 50,
      }),
    );
    expect(result[0].color).toBe("#1B4F72");
    expect(result[0].icon).toBe("terminal");
    expect(result[1].name).toBe("Scripting and Automation");
    expect(result[1].icon).toBe("integration_instructions");
    expect(result[1].size).toBe(3);
  });

  it("returns an empty list when the catalog has no categories", async () => {
    db.query.mockResolvedValueOnce([]);

    await expect(service.getCategories()).resolves.toEqual([]);
    expect(sql.load).toHaveBeenCalledWith(
      "reports/statistics/expert-skills/categories.sql",
    );
    expect(sql.load).not.toHaveBeenCalledWith(
      "reports/statistics/expert-skills/category-stats.sql",
    );
  });

  it("returns top members for a catalog category name", async () => {
    db.query
      .mockResolvedValueOnce([
        {
          id: "481b5ebc-2fe6-45ed-a90c-736936d458d7",
          name: "Programming and Development",
        },
      ])
      .mockResolvedValueOnce([
        {
          handle: "billzedison",
          firstName: "Honghan",
          lastName: "Wu",
          photoUrl: null,
          countryCode: "IND",
          rating: 2000,
          wins: 376,
        },
      ]);

    const result = await service.getCategoryMembers(
      "Programming & Development",
    );

    expect(sql.load).toHaveBeenCalledWith(
      "reports/statistics/expert-skills/categories.sql",
    );
    expect(sql.load).toHaveBeenCalledWith(
      "reports/statistics/expert-skills/category-members.sql",
    );
    expect(db.query).toHaveBeenNthCalledWith(2, "SELECT expert skills", [
      "481b5ebc-2fe6-45ed-a90c-736936d458d7",
      100,
    ]);
    expect(result).toEqual([
      {
        countryCode: "IN",
        countryName: "India",
        handle: "billzedison",
        name: "Honghan W",
        photoURL: null,
        rating: 2000,
        wins: 376,
      },
    ]);
  });

  it("throws when the selected category is not in the catalog", async () => {
    db.query.mockResolvedValueOnce([
      {
        id: "481b5ebc-2fe6-45ed-a90c-736936d458d7",
        name: "Programming and Development",
      },
    ]);

    await expect(
      service.getCategoryMembers("Test Cat QA 1"),
    ).rejects.toBeInstanceOf(NotFoundException);
    expect(db.query).toHaveBeenCalledTimes(1);
  });
});
