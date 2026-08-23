import { NotFoundException } from "@nestjs/common";
import { Test, TestingModule } from "@nestjs/testing";
import { ExpertSkillsController } from "./expert-skills.controller";
import { ExpertSkillsService } from "./expert-skills.service";

describe("ExpertSkillsController", () => {
  let controller: ExpertSkillsController;

  const mockExpertSkillsService = {
    getCategories: jest.fn(),
    getCategoryMembers: jest.fn(),
  };

  beforeEach(async () => {
    mockExpertSkillsService.getCategories.mockReset();
    mockExpertSkillsService.getCategoryMembers.mockReset();

    const moduleRef: TestingModule = await Test.createTestingModule({
      controllers: [ExpertSkillsController],
      providers: [
        {
          provide: ExpertSkillsService,
          useValue: mockExpertSkillsService,
        },
      ],
    }).compile();

    controller = moduleRef.get<ExpertSkillsController>(ExpertSkillsController);
  });

  it("creates the controller", () => {
    expect(controller).toBeDefined();
  });

  it("delegates category requests to the service", async () => {
    const response = [
      {
        id: "481b5ebc-2fe6-45ed-a90c-736936d458d7",
        name: "Programming & Development",
        officialName: "Programming and Development",
        color: "#1B4F72",
        icon: "TerminalIcon",
        size: 10,
        totalMembers: 10,
        totalSkills: 5,
        skillsBreakdown: [{ name: "JavaScript", percentage: 40 }],
      },
    ];
    mockExpertSkillsService.getCategories.mockResolvedValue(response);

    await expect(controller.getCategories()).resolves.toEqual(response);
    expect(mockExpertSkillsService.getCategories).toHaveBeenCalledTimes(1);
  });

  it("delegates member requests with selectedcategory", async () => {
    const response = [
      {
        countryCode: "IN",
        countryName: "India",
        handle: "billzedison",
        name: "Honghan W",
        photoURL: null,
        rating: 2000,
        wins: 376,
      },
    ];
    mockExpertSkillsService.getCategoryMembers.mockResolvedValue(response);

    await expect(
      controller.getCategoryMembers({
        selectedcategory: "Programming & Development",
      }),
    ).resolves.toEqual(response);
    expect(mockExpertSkillsService.getCategoryMembers).toHaveBeenCalledWith(
      "Programming & Development",
    );
  });

  it("propagates missing category errors", async () => {
    mockExpertSkillsService.getCategoryMembers.mockRejectedValue(
      new NotFoundException("Skill category not found"),
    );

    await expect(
      controller.getCategoryMembers({ selectedcategory: "Unknown" }),
    ).rejects.toBeInstanceOf(NotFoundException);
  });
});
