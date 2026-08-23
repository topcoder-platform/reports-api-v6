import { NotFoundException } from "@nestjs/common";
import { Test, TestingModule } from "@nestjs/testing";
import { DbService } from "../../db/db.service";
import { ExpertSkillsService } from "./expert-skills.service";
import { StandardizedSkillsClient } from "./standardized-skills.client";

describe("ExpertSkillsService", () => {
  let service: ExpertSkillsService;

  const mockDbService = {
    query: jest.fn(),
  };
  const mockStandardizedSkillsClient = {
    fetchCategories: jest.fn(),
  };

  beforeEach(async () => {
    mockDbService.query.mockReset();
    mockStandardizedSkillsClient.fetchCategories.mockReset();

    const moduleRef: TestingModule = await Test.createTestingModule({
      providers: [
        ExpertSkillsService,
        { provide: DbService, useValue: mockDbService },
        {
          provide: StandardizedSkillsClient,
          useValue: mockStandardizedSkillsClient,
        },
      ],
    }).compile();

    service = moduleRef.get<ExpertSkillsService>(ExpertSkillsService);
  });

  it("creates the service", () => {
    expect(service).toBeDefined();
  });

  it("maps catalog categories to stats and normalized sizes", async () => {
    mockStandardizedSkillsClient.fetchCategories.mockResolvedValue([
      {
        id: "481b5ebc-2fe6-45ed-a90c-736936d458d7",
        name: "Programming and Development",
      },
      {
        id: "1f5ed3e8-8d22-44ea-b75d-ea85147a04da",
        name: "Scripting and Automation",
      },
    ]);
    mockDbService.query.mockResolvedValueOnce([
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
    const sql = mockDbService.query.mock.calls[0][0] as string;
    const params = mockDbService.query.mock.calls[0][1] as unknown[];

    expect(mockStandardizedSkillsClient.fetchCategories).toHaveBeenCalledTimes(
      1,
    );
    expect(sql).toContain("unnest($1::uuid[])");
    expect(sql).toContain("challenge_win");
    expect(sql).not.toContain("NOT ILIKE 'Test Cat%'");
    expect(params).toEqual([
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
    expect(result[0].color).toMatch(/^#[0-9A-F]{6}$/i);
    expect(result[0].icon).toMatch(/Icon$/);
    expect(result[1].name).toBe("Scripting and Automation");
    expect(result[1].size).toBe(3);
  });

  it("returns an empty list when the catalog has no categories", async () => {
    mockStandardizedSkillsClient.fetchCategories.mockResolvedValue([]);

    await expect(service.getCategories()).resolves.toEqual([]);
    expect(mockDbService.query).not.toHaveBeenCalled();
  });

  it("returns top members for a catalog category name", async () => {
    mockStandardizedSkillsClient.fetchCategories.mockResolvedValue([
      {
        id: "481b5ebc-2fe6-45ed-a90c-736936d458d7",
        name: "Programming and Development",
      },
    ]);
    mockDbService.query.mockResolvedValueOnce([
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
    const membersSql = mockDbService.query.mock.calls[0][0] as string;
    const membersParams = mockDbService.query.mock.calls[0][1] as unknown[];

    expect(membersSql).toContain("ORDER BY cw.wins DESC, m.handle ASC");
    expect(membersSql).toContain("LIMIT $2");
    expect(membersParams).toEqual([
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
    mockStandardizedSkillsClient.fetchCategories.mockResolvedValue([
      {
        id: "481b5ebc-2fe6-45ed-a90c-736936d458d7",
        name: "Programming and Development",
      },
    ]);

    await expect(
      service.getCategoryMembers("Test Cat QA 1"),
    ).rejects.toBeInstanceOf(NotFoundException);
    expect(mockDbService.query).not.toHaveBeenCalled();
  });
});
