import { BadRequestException } from "@nestjs/common";
import { INTERCEPTORS_METADATA } from "@nestjs/common/constants";
import { Test, TestingModule } from "@nestjs/testing";
import { CsvSerializer } from "../../common/csv/csv-serializer";
import { CsvResponseInterceptor } from "../../common/interceptors/csv-response.interceptor";
import { MemberSearchResponseDto } from "./dto/member-search-response.dto";
import { MemberSearchController } from "./member-search.controller";
import { MemberSearchService } from "./member-search.service";

describe("MemberSearchController", () => {
  let controller: MemberSearchController;

  const mockMemberSearchService = {
    exportOpenToWorkTalent: jest.fn(),
    getOpenToWorkTalent: jest.fn(),
    search: jest.fn(),
  };

  beforeEach(async () => {
    mockMemberSearchService.exportOpenToWorkTalent.mockReset();
    mockMemberSearchService.getOpenToWorkTalent.mockReset();
    mockMemberSearchService.search.mockReset();

    const moduleRef: TestingModule = await Test.createTestingModule({
      controllers: [MemberSearchController],
      providers: [
        CsvSerializer,
        CsvResponseInterceptor,
        {
          provide: MemberSearchService,
          useValue: mockMemberSearchService,
        },
      ],
    }).compile();

    controller = moduleRef.get<MemberSearchController>(MemberSearchController);
  });

  it("creates the controller", () => {
    expect(controller).toBeDefined();
  });

  it("delegates search requests to the service and returns response", async () => {
    const body = {
      countries: ["Australia"],
      sortBy: "handle" as const,
      sortOrder: "asc" as const,
      page: 2,
      limit: 2,
    };

    const response: MemberSearchResponseDto = {
      total: 1,
      page: 2,
      limit: 2,
      data: [
        {
          id: "123",
          handle: "tourist",
          name: "Gennady Korotkevich",
          photoUrl: null,
          isRecentlyActive: true,
          isVerified: true,
          openToWork: false,
          location: "Gomel Belarus",
          matchedSkills: [],
          matchIndex: 97,
        },
      ],
    };

    mockMemberSearchService.search.mockResolvedValue(response);

    const result = await controller.search(body);

    expect(mockMemberSearchService.search).toHaveBeenCalledWith(body);
    expect(result).toEqual(response);
  });

  it("delegates open-to-work Talent report requests to the service", async () => {
    const query = {
      page: 2,
      perPage: 10,
      role: "FULL_STACK_DEVELOPER",
    };
    const response = {
      totalMembers: 5,
      total: 2,
      page: 2,
      perPage: 10,
      roleCounts: [{ role: "FULL_STACK_DEVELOPER", count: 2 }],
      data: [],
    };

    mockMemberSearchService.getOpenToWorkTalent.mockResolvedValue(response);

    const result = await controller.getOpenToWorkTalent(query);

    expect(mockMemberSearchService.getOpenToWorkTalent).toHaveBeenCalledWith(
      query,
    );
    expect(result).toEqual(response);
  });

  it("delegates open-to-work Talent export requests to the service", async () => {
    const query = { role: "UX_DESIGNER" };
    const response = [
      {
        handle: "designer",
        firstName: "Design",
        lastName: "User",
        email: "designer@example.com",
        phone: "+15555550100",
      },
    ];

    mockMemberSearchService.exportOpenToWorkTalent.mockResolvedValue(response);

    const result = await controller.exportOpenToWorkTalent(query);

    expect(mockMemberSearchService.exportOpenToWorkTalent).toHaveBeenCalledWith(
      query,
    );
    expect(result).toEqual(response);
  });

  it("uses the CSV interceptor for the open-to-work Talent export endpoint", () => {
    const interceptors =
      Reflect.getMetadata(
        INTERCEPTORS_METADATA,
        MemberSearchController.prototype.exportOpenToWorkTalent,
      ) ?? [];

    expect(interceptors).toContain(CsvResponseInterceptor);
  });

  it("propagates service errors", async () => {
    mockMemberSearchService.search.mockRejectedValue(
      new BadRequestException("Invalid request"),
    );

    await expect(controller.search({})).rejects.toBeInstanceOf(
      BadRequestException,
    );
  });
});
