import { NotFoundException } from "@nestjs/common";
import { Test, TestingModule } from "@nestjs/testing";
import { DbService } from "../../db/db.service";
import { MemberSearchService } from "./member-search.service";

describe("MemberSearchService", () => {
  let service: MemberSearchService;

  const mockDbService = {
    query: jest.fn(),
  };

  beforeEach(async () => {
    mockDbService.query.mockReset();

    const moduleRef: TestingModule = await Test.createTestingModule({
      providers: [
        MemberSearchService,
        { provide: DbService, useValue: mockDbService },
      ],
    }).compile();

    service = moduleRef.get<MemberSearchService>(MemberSearchService);
  });

  it("creates the service", () => {
    expect(service).toBeDefined();
  });

  it("runs data and count queries with default pagination and maps response", async () => {
    mockDbService.query
      .mockResolvedValueOnce([
        {
          id: "123",
          handle: "tourist",
          name: "",
          photoUrl: null,
          isRecentlyActive: undefined,
          isVerified: undefined,
          openToWork: undefined,
          location: "",
          matchedSkills: null,
          matchIndex: undefined,
        },
      ])
      .mockResolvedValueOnce([{ total: 1 }]);

    const result = await service.search({});

    expect(mockDbService.query).toHaveBeenCalledTimes(2);

    const dataSql = mockDbService.query.mock.calls[0][0] as string;
    const dataParams = mockDbService.query.mock.calls[0][1] as unknown[];
    const countSql = mockDbService.query.mock.calls[1][0] as string;
    const countParams = mockDbService.query.mock.calls[1][1] as unknown[];

    expect(dataSql).toContain("WITH recently_active AS");
    expect(dataSql).not.toContain("requested_skills AS");
    expect(dataSql).toContain(
      'ORDER BY "matchIndex" DESC NULLS LAST, m.handle ASC',
    );

    expect(countSql).toContain("SELECT COUNT(*)::integer AS total");

    expect(dataParams).toEqual([8, 0]);
    expect(countParams).toEqual([]);

    expect(result).toEqual({
      total: 1,
      page: 1,
      limit: 8,
      data: [
        {
          id: "123",
          handle: "tourist",
          name: "tourist",
          photoUrl: null,
          isRecentlyActive: false,
          isVerified: false,
          openToWork: false,
          location: "",
          matchedSkills: [],
          matchIndex: 0,
        },
      ],
    });
  });

  it("uses filter params for count query but excludes pagination params", async () => {
    mockDbService.query
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce([{ total: 0 }]);

    await service.search({
      countries: ["us"],
      page: 2,
      limit: 5,
      sortBy: "handle",
      sortOrder: "asc",
    });

    const dataSql = mockDbService.query.mock.calls[0][0] as string;
    const dataParams = mockDbService.query.mock.calls[0][1] as unknown[];
    const countParams = mockDbService.query.mock.calls[1][1] as unknown[];

    expect(dataSql).toContain(
      'ORDER BY m.handle ASC, "matchIndex" DESC NULLS LAST',
    );
    expect(dataSql).toContain('LOWER(m."homeCountryCode") = ANY($1::text[])');
    expect(dataParams).toEqual([["us"], 5, 5]);
    expect(countParams).toEqual([["us"]]);
  });

  it("treats empty countries as no country filter", async () => {
    mockDbService.query
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce([{ total: 0 }]);

    await service.search({ countries: [] });

    const dataSql = mockDbService.query.mock.calls[0][0] as string;
    const countParams = mockDbService.query.mock.calls[1][1] as unknown[];

    expect(dataSql).not.toContain('LOWER(m."homeCountryCode") = ANY(');
    expect(countParams).toEqual([]);
  });

  it("does not apply boolean filters when explicitly false", async () => {
    mockDbService.query
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce([{ total: 0 }]);

    await service.search({
      openToWork: false,
      recentlyActive: false,
      verifiedProfile: false,
    });

    const dataSql = mockDbService.query.mock.calls[0][0] as string;

    expect(dataSql).not.toContain('m."availableForGigs" = true');
    expect(dataSql).not.toContain(
      'EXISTS (SELECT 1 FROM recently_active ra WHERE ra.user_id = m."userId")',
    );
    expect(dataSql).not.toContain("COALESCE(m.verified, false) = true");
  });

  it("adds profileComplete CTE/join only when enabled and keeps count params free of pagination", async () => {
    mockDbService.query
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce([{ total: 0 }]);

    await service.search({
      countries: ["us"],
      profileComplete: true,
      page: 3,
      limit: 7,
    });

    const enabledDataSql = mockDbService.query.mock.calls[0][0] as string;
    const enabledDataParams = mockDbService.query.mock.calls[0][1] as unknown[];
    const enabledCountSql = mockDbService.query.mock.calls[1][0] as string;
    const enabledCountParams = mockDbService.query.mock.calls[1][1] as unknown[];

    expect(enabledDataSql).toContain("profile_complete_filtered AS (");
    expect(enabledDataSql).toContain(
      "INNER JOIN profile_complete_filtered pcf ON pcf.user_id = m.\"userId\"",
    );
    expect(enabledCountSql).toContain("FROM profile_complete_filtered pcf");
    expect(enabledCountSql).not.toContain(
      "INNER JOIN profile_complete_filtered pcf ON pcf.user_id = fm.user_id",
    );
    expect(enabledDataParams).toEqual([["us"], 7, 14]);
    expect(enabledCountParams).toEqual([["us"]]);

    mockDbService.query.mockReset();
    mockDbService.query
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce([{ total: 0 }]);

    await service.search({
      countries: ["us"],
      page: 3,
      limit: 7,
    });

    const disabledDataSql = mockDbService.query.mock.calls[0][0] as string;
    const disabledCountSql = mockDbService.query.mock.calls[1][0] as string;

    expect(disabledDataSql).not.toContain("profile_complete_filtered AS (");
    expect(disabledDataSql).not.toContain(
      "INNER JOIN profile_complete_filtered pcf ON pcf.user_id = m.\"userId\"",
    );
    expect(disabledCountSql).toContain("FROM filtered_members fm");
    expect(disabledCountSql).not.toContain("profile_complete_filtered pcf");
  });

  it("deduplicates skills and keeps last wins value when building skill query", async () => {
    const skillA = "550e8400-e29b-41d4-a716-446655440000";
    const skillB = "550e8400-e29b-41d4-a716-446655440001";

    mockDbService.query
      .mockResolvedValueOnce([{ id: skillA }, { id: skillB }])
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce([{ total: 0 }]);

    await service.search({
      skills: [
        { id: skillA, wins: 2 },
        { id: skillA, wins: 5 },
        { id: skillB },
      ],
      skillSearchType: "AND",
      limit: 3,
      page: 1,
    });

    expect(mockDbService.query).toHaveBeenCalledTimes(3);

    const validationSql = mockDbService.query.mock.calls[0][0] as string;
    const validationParams = mockDbService.query.mock.calls[0][1] as unknown[];
    const dataSql = mockDbService.query.mock.calls[1][0] as string;
    const dataParams = mockDbService.query.mock.calls[1][1] as unknown[];

    expect(validationSql).toContain("FROM skills.skill");
    expect(validationParams).toEqual([[skillA, skillB]]);

    expect(dataSql).toContain("requested_skills AS");
    expect(dataSql).toContain("INNER JOIN user_match_data umd");
    expect(dataParams).toContainEqual([skillA, skillB]);
    expect(dataParams).toContainEqual([5, 0]);
    expect(dataParams).toContain("AND");
    expect(dataParams).toContain(2);
  });

  it("throws NotFoundException when any requested skill does not exist", async () => {
    const missingSkill = "550e8400-e29b-41d4-a716-446655440003";

    mockDbService.query.mockResolvedValueOnce([]);

    await expect(
      service.search({
        skills: [{ id: missingSkill }],
      }),
    ).rejects.toThrow(NotFoundException);

    expect(mockDbService.query).toHaveBeenCalledTimes(1);
  });
});
