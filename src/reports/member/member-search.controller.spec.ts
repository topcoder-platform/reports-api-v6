import { BadRequestException } from "@nestjs/common";
import { Test, TestingModule } from "@nestjs/testing";
import { MemberSearchResponseDto } from "./dto/member-search-response.dto";
import { MemberSearchController } from "./member-search.controller";
import { MemberSearchService } from "./member-search.service";

describe("MemberSearchController", () => {
  let controller: MemberSearchController;

  const mockMemberSearchService = {
    search: jest.fn(),
  };

  beforeEach(async () => {
    mockMemberSearchService.search.mockReset();

    const moduleRef: TestingModule = await Test.createTestingModule({
      controllers: [MemberSearchController],
      providers: [
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

  it("propagates service errors", async () => {
    mockMemberSearchService.search.mockRejectedValue(
      new BadRequestException("Invalid request"),
    );

    await expect(controller.search({})).rejects.toBeInstanceOf(
      BadRequestException,
    );
  });
});
