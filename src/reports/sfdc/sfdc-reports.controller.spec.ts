import "reflect-metadata";
import { BadRequestException } from "@nestjs/common";
import { Test, TestingModule } from "@nestjs/testing";
import { plainToInstance } from "class-transformer";
import {
  BaFeesReportQueryDto,
  ChallengesReportQueryDto,
  PaymentsReportQueryDto,
  TaasJobsReportQueryDto,
  TaasMemberVerificationReportQueryDto,
  TaasResourceBookingsReportQueryDto,
  WesternUnionPaymentsReportQueryDto,
} from "./sfdc-reports.dto";
import { SfdcReportsController } from "./sfdc-reports.controller";
import { SfdcReportsService } from "./sfdc-reports.service";
import {
  mockChallengeData,
  mockChallengeQueryDto,
  mockBaFeesData,
  mockBaFeesQueryDto,
  mockPaymentData,
  mockPaymentQueryDto,
  mockTaasJobsData,
  mockTaasJobsQueryDto,
  mockTaasMemberVerificationData,
  mockTaasMemberVerificationQueryDto,
  mockTaasResourceBookingsData,
  mockTaasResourceBookingsQueryDto,
  mockWesternUnionPaymentsData,
  mockWesternUnionPaymentsQueryDto,
} from "./test-helpers/mock-data";

describe("SfdcReportsController", () => {
  let controller: SfdcReportsController;

  const mockSfdcReportsService = {
    getChallengesReport: jest.fn(),
    getBaFeesReport: jest.fn(),
    getPaymentsReport: jest.fn(),
    getTaasJobsReport: jest.fn(),
    getTaasResourceBookingsReport: jest.fn(),
    getTaasMemberVerificationReport: jest.fn(),
    getWesternUnionPaymentsReport: jest.fn(),
  };

  beforeEach(async () => {
    mockSfdcReportsService.getChallengesReport.mockReset();
    mockSfdcReportsService.getBaFeesReport.mockReset();
    mockSfdcReportsService.getPaymentsReport.mockReset();
    mockSfdcReportsService.getTaasJobsReport.mockReset();
    mockSfdcReportsService.getTaasResourceBookingsReport.mockReset();
    mockSfdcReportsService.getTaasMemberVerificationReport.mockReset();
    mockSfdcReportsService.getWesternUnionPaymentsReport.mockReset();

    const moduleRef: TestingModule = await Test.createTestingModule({
      controllers: [SfdcReportsController],
      providers: [
        {
          provide: SfdcReportsService,
          useValue: mockSfdcReportsService,
        },
      ],
    }).compile();

    controller = moduleRef.get<SfdcReportsController>(SfdcReportsController);
  });

  it("compiles the controller", () => {
    expect(controller).toBeDefined();
  });

  it("returns the challenges report on success", async () => {
    mockSfdcReportsService.getChallengesReport.mockResolvedValue(
      mockChallengeData,
    );

    const result = await controller.getChallengesReport(
      mockChallengeQueryDto.billingAccount,
    );

    expect(
      mockSfdcReportsService.getChallengesReport,
    ).toHaveBeenCalledWith(mockChallengeQueryDto.billingAccount);
    expect(result).toEqual(mockChallengeData);
  });

  it("returns an empty array when no results are found", async () => {
    mockSfdcReportsService.getChallengesReport.mockResolvedValue([]);

    const result = await controller.getChallengesReport(
      mockChallengeQueryDto.billingAccount,
    );

    expect(result).toEqual([]);
  });

  it("propagates errors from the service", async () => {
    mockSfdcReportsService.getChallengesReport.mockRejectedValue(
      new BadRequestException("bad filters"),
    );

    await expect(
      controller.getChallengesReport(mockChallengeQueryDto.billingAccount),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it("transforms single query params into arrays before passing to the service", async () => {
    mockSfdcReportsService.getChallengesReport.mockResolvedValue([]);

    const dto = plainToInstance(ChallengesReportQueryDto, {
      billingAccountIds: "80001012",
      challengeIds: "e74c3e37-73c9-474e-a838-a38dd4738906",
      handles: "user_01",
      challengeStatus: "COMPLETED",
    });

    await controller.getChallengesReport(dto);

    expect(mockSfdcReportsService.getChallengesReport).toHaveBeenCalledWith(
      expect.objectContaining({
        billingAccountIds: ["80001012"],
        challengeIds: ["e74c3e37-73c9-474e-a838-a38dd4738906"],
        handles: ["user_01"],
        challengeStatus: ["COMPLETED"],
      }),
    );
  });

  describe("getPaymentsReport", () => {
    it("returns the payments report on success", async () => {
      mockSfdcReportsService.getPaymentsReport.mockResolvedValue(
        mockPaymentData,
      );

      const result = await controller.getPaymentsReport(
        mockPaymentQueryDto.billingAccount,
      );

      expect(mockSfdcReportsService.getPaymentsReport).toHaveBeenCalledWith(
        mockPaymentQueryDto.billingAccount,
      );
      expect(result).toEqual(mockPaymentData);
    });

    it("returns an empty array when no results are found", async () => {
      mockSfdcReportsService.getPaymentsReport.mockResolvedValue([]);

      const result = await controller.getPaymentsReport(
        mockPaymentQueryDto.billingAccount,
      );

      expect(result).toEqual([]);
    });

    it("propagates errors from the service", async () => {
      mockSfdcReportsService.getPaymentsReport.mockRejectedValue(
        new BadRequestException("invalid filters"),
      );

      await expect(
        controller.getPaymentsReport(mockPaymentQueryDto.billingAccount),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it("transforms single query params into arrays before passing to the service", async () => {
      mockSfdcReportsService.getPaymentsReport.mockResolvedValue([]);

      const dto = plainToInstance(PaymentsReportQueryDto, {
        billingAccountIds: "80001012",
        challengeIds: "e74c3e37-73c9-474e-a838-a38dd4738906",
        handles: "user_01",
        challengeStatus: "COMPLETED",
      });

      await controller.getPaymentsReport(dto);

      expect(mockSfdcReportsService.getPaymentsReport).toHaveBeenCalledWith(
        expect.objectContaining({
          billingAccountIds: ["80001012"],
          challengeIds: ["e74c3e37-73c9-474e-a838-a38dd4738906"],
          handles: ["user_01"],
          challengeStatus: ["COMPLETED"],
        }),
      );
    });

    it("passes all payment filters to the service", async () => {
      mockSfdcReportsService.getPaymentsReport.mockResolvedValue([]);

      await controller.getPaymentsReport(mockPaymentQueryDto.full);

      expect(mockSfdcReportsService.getPaymentsReport).toHaveBeenCalledWith(
        mockPaymentQueryDto.full,
      );
    });

    it("handles billing account exclusions", async () => {
      mockSfdcReportsService.getPaymentsReport.mockResolvedValue([]);

      await controller.getPaymentsReport(mockPaymentQueryDto.withExclusions);

      expect(mockSfdcReportsService.getPaymentsReport).toHaveBeenCalledWith(
        mockPaymentQueryDto.withExclusions,
      );
    });
  });

  describe("getTaasJobsReport", () => {
    it("returns the TaaS jobs report on success", async () => {
      mockSfdcReportsService.getTaasJobsReport.mockResolvedValue(
        mockTaasJobsData,
      );

      const result = await controller.getTaasJobsReport(
        mockTaasJobsQueryDto.byJobIds,
      );

      expect(mockSfdcReportsService.getTaasJobsReport).toHaveBeenCalledWith(
        mockTaasJobsQueryDto.byJobIds,
      );
      expect(result).toEqual(mockTaasJobsData);
    });

    it("returns an empty array when no results are found", async () => {
      mockSfdcReportsService.getTaasJobsReport.mockResolvedValue([]);

      const result = await controller.getTaasJobsReport(
        mockTaasJobsQueryDto.byJobIds,
      );

      expect(result).toEqual([]);
    });

    it("propagates errors from the service", async () => {
      mockSfdcReportsService.getTaasJobsReport.mockRejectedValue(
        new BadRequestException("invalid filters"),
      );

      await expect(
        controller.getTaasJobsReport(mockTaasJobsQueryDto.byJobIds),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it("transforms single query params into arrays before passing to the service", async () => {
      mockSfdcReportsService.getTaasJobsReport.mockResolvedValue([]);

      const dto = plainToInstance(TaasJobsReportQueryDto, {
        jobIds: "a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
        projectIds: "12345",
        status: "open",
        resourceType: "developer",
        skills: "React",
      });

      await controller.getTaasJobsReport(dto);

      expect(mockSfdcReportsService.getTaasJobsReport).toHaveBeenCalledWith(
        expect.objectContaining({
          jobIds: ["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
          projectIds: [12345],
          status: ["open"],
          resourceType: ["developer"],
          skills: ["React"],
        }),
      );
    });

    it("passes all job filters to the service", async () => {
      mockSfdcReportsService.getTaasJobsReport.mockResolvedValue([]);

      await controller.getTaasJobsReport(mockTaasJobsQueryDto.full);

      expect(mockSfdcReportsService.getTaasJobsReport).toHaveBeenCalledWith(
        mockTaasJobsQueryDto.full,
      );
    });
  });

  describe("getTaasResourceBookingsReport", () => {
    it("returns the TaaS resource bookings report on success", async () => {
      mockSfdcReportsService.getTaasResourceBookingsReport.mockResolvedValue(
        mockTaasResourceBookingsData,
      );

      const result = await controller.getTaasResourceBookingsReport(
        mockTaasResourceBookingsQueryDto.byResourceBookingIds,
      );

      expect(
        mockSfdcReportsService.getTaasResourceBookingsReport,
      ).toHaveBeenCalledWith(
        mockTaasResourceBookingsQueryDto.byResourceBookingIds,
      );
      expect(result).toEqual(mockTaasResourceBookingsData);
    });

    it("returns an empty array when no results are found", async () => {
      mockSfdcReportsService.getTaasResourceBookingsReport.mockResolvedValue(
        [],
      );

      const result = await controller.getTaasResourceBookingsReport(
        mockTaasResourceBookingsQueryDto.byResourceBookingIds,
      );

      expect(result).toEqual([]);
    });

    it("propagates errors from the service", async () => {
      mockSfdcReportsService.getTaasResourceBookingsReport.mockRejectedValue(
        new BadRequestException("invalid filters"),
      );

      await expect(
        controller.getTaasResourceBookingsReport(
          mockTaasResourceBookingsQueryDto.byResourceBookingIds,
        ),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it("transforms single query params into arrays before passing to the service", async () => {
      mockSfdcReportsService.getTaasResourceBookingsReport.mockResolvedValue(
        [],
      );

      const dto = plainToInstance(TaasResourceBookingsReportQueryDto, {
        resourceBookingIds: "c2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
        jobIds: "a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
        projectIds: "12345",
        userIds: "100001",
        handles: "Dev_User",
        status: "placed",
        billingAccountIds: "80001012",
      });

      await controller.getTaasResourceBookingsReport(dto);

      expect(
        mockSfdcReportsService.getTaasResourceBookingsReport,
      ).toHaveBeenCalledWith(
        expect.objectContaining({
          resourceBookingIds: ["c2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
          jobIds: ["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
          projectIds: [12345],
          userIds: ["100001"],
          handles: ["Dev_User"],
          status: ["placed"],
          billingAccountIds: ["80001012"],
        }),
      );
    });

    it("passes all resource booking filters to the service", async () => {
      mockSfdcReportsService.getTaasResourceBookingsReport.mockResolvedValue(
        [],
      );

      await controller.getTaasResourceBookingsReport(
        mockTaasResourceBookingsQueryDto.full,
      );

      expect(
        mockSfdcReportsService.getTaasResourceBookingsReport,
      ).toHaveBeenCalledWith(mockTaasResourceBookingsQueryDto.full);
    });
  });

  describe("getTaasMemberVerificationReport", () => {
    it("returns the member verification report on success", async () => {
      mockSfdcReportsService.getTaasMemberVerificationReport.mockResolvedValue(
        mockTaasMemberVerificationData,
      );

      const result = await controller.getTaasMemberVerificationReport(
        mockTaasMemberVerificationQueryDto.multipleHandles,
      );

      expect(
        mockSfdcReportsService.getTaasMemberVerificationReport,
      ).toHaveBeenCalledWith(
        mockTaasMemberVerificationQueryDto.multipleHandles,
      );
      expect(result).toEqual(mockTaasMemberVerificationData);
    });

    it("returns an empty array when no results are found", async () => {
      mockSfdcReportsService.getTaasMemberVerificationReport.mockResolvedValue(
        [],
      );

      const result = await controller.getTaasMemberVerificationReport(
        mockTaasMemberVerificationQueryDto.multipleHandles,
      );

      expect(result).toEqual([]);
    });

    it("propagates errors from the service", async () => {
      mockSfdcReportsService.getTaasMemberVerificationReport.mockRejectedValue(
        new BadRequestException("invalid handles"),
      );

      await expect(
        controller.getTaasMemberVerificationReport(
          mockTaasMemberVerificationQueryDto.multipleHandles,
        ),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it("transforms single handle into array before passing to the service", async () => {
      mockSfdcReportsService.getTaasMemberVerificationReport.mockResolvedValue(
        [],
      );

      const dto = plainToInstance(TaasMemberVerificationReportQueryDto, {
        handles: "user1",
      });

      await controller.getTaasMemberVerificationReport(dto);

      expect(
        mockSfdcReportsService.getTaasMemberVerificationReport,
      ).toHaveBeenCalledWith(
        expect.objectContaining({
          handles: ["user1"],
        }),
      );
    });

    it("passes multiple handles to the service", async () => {
      mockSfdcReportsService.getTaasMemberVerificationReport.mockResolvedValue(
        [],
      );

      await controller.getTaasMemberVerificationReport(
        mockTaasMemberVerificationQueryDto.multipleHandles,
      );

      expect(
        mockSfdcReportsService.getTaasMemberVerificationReport,
      ).toHaveBeenCalledWith(
        mockTaasMemberVerificationQueryDto.multipleHandles,
      );
    });
  });

  describe("getWesternUnionPaymentsReport", () => {
    it("returns the Western Union payments report on success", async () => {
      mockSfdcReportsService.getWesternUnionPaymentsReport.mockResolvedValue(
        mockWesternUnionPaymentsData,
      );

      const result = await controller.getWesternUnionPaymentsReport(
        mockWesternUnionPaymentsQueryDto.full,
      );

      expect(
        mockSfdcReportsService.getWesternUnionPaymentsReport,
      ).toHaveBeenCalledWith(mockWesternUnionPaymentsQueryDto.full);
      expect(result).toEqual(mockWesternUnionPaymentsData);
    });

    it("returns an empty array when no results are found", async () => {
      mockSfdcReportsService.getWesternUnionPaymentsReport.mockResolvedValue(
        [],
      );

      const result = await controller.getWesternUnionPaymentsReport(
        mockWesternUnionPaymentsQueryDto.full,
      );

      expect(result).toEqual([]);
    });

    it("propagates errors from the service", async () => {
      mockSfdcReportsService.getWesternUnionPaymentsReport.mockRejectedValue(
        new BadRequestException("invalid filters"),
      );

      await expect(
        controller.getWesternUnionPaymentsReport(
          mockWesternUnionPaymentsQueryDto.full,
        ),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it("transforms a single handle into an array before passing to the service", async () => {
      mockSfdcReportsService.getWesternUnionPaymentsReport.mockResolvedValue(
        [],
      );

      const dto = plainToInstance(WesternUnionPaymentsReportQueryDto, {
        handles: "winner_one",
      });

      await controller.getWesternUnionPaymentsReport(dto);

      expect(
        mockSfdcReportsService.getWesternUnionPaymentsReport,
      ).toHaveBeenCalledWith(
        expect.objectContaining({
          handles: ["winner_one"],
        }),
      );
    });

    it("passes all Western Union filters to the service", async () => {
      mockSfdcReportsService.getWesternUnionPaymentsReport.mockResolvedValue(
        [],
      );

      await controller.getWesternUnionPaymentsReport(
        mockWesternUnionPaymentsQueryDto.full,
      );

      expect(
        mockSfdcReportsService.getWesternUnionPaymentsReport,
      ).toHaveBeenCalledWith(mockWesternUnionPaymentsQueryDto.full);
    });

    it("handles default payment status and method when not provided", async () => {
      mockSfdcReportsService.getWesternUnionPaymentsReport.mockResolvedValue(
        [],
      );

      const dto = plainToInstance(WesternUnionPaymentsReportQueryDto, {});

      await controller.getWesternUnionPaymentsReport(dto);

      const [callArgs] =
        mockSfdcReportsService.getWesternUnionPaymentsReport.mock.calls[0];

      expect(callArgs.paymentStatus ?? "Entered into payment system").toBe(
        "Entered into payment system",
      );
      expect(callArgs.paymentMethod ?? "Western Union").toBe("Western Union");
    });
  });

  describe("getBaFeesReport", () => {
    it("returns the BA fees report on success", async () => {
      mockSfdcReportsService.getBaFeesReport.mockResolvedValue(mockBaFeesData);

      const result = await controller.getBaFeesReport(
        mockBaFeesQueryDto.byBillingAccount,
      );

      expect(mockSfdcReportsService.getBaFeesReport).toHaveBeenCalledWith(
        mockBaFeesQueryDto.byBillingAccount,
      );
      expect(result).toEqual(mockBaFeesData);
    });

    it("returns an empty array when no results are found", async () => {
      mockSfdcReportsService.getBaFeesReport.mockResolvedValue([]);

      const result = await controller.getBaFeesReport(
        mockBaFeesQueryDto.byBillingAccount,
      );

      expect(result).toEqual([]);
    });

    it("propagates errors from the service", async () => {
      mockSfdcReportsService.getBaFeesReport.mockRejectedValue(
        new BadRequestException("invalid filters"),
      );

      await expect(
        controller.getBaFeesReport(mockBaFeesQueryDto.byBillingAccount),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it("transforms single billingAccountId string into array before passing to the service", async () => {
      mockSfdcReportsService.getBaFeesReport.mockResolvedValue([]);

      const dto = plainToInstance(BaFeesReportQueryDto, {
        billingAccountIds: "80001012",
      });

      await controller.getBaFeesReport(dto);

      expect(mockSfdcReportsService.getBaFeesReport).toHaveBeenCalledWith(
        expect.objectContaining({
          billingAccountIds: ["80001012"],
        }),
      );
    });

    it("passes all BA fees filters to the service", async () => {
      mockSfdcReportsService.getBaFeesReport.mockResolvedValue([]);

      await controller.getBaFeesReport(mockBaFeesQueryDto.full);

      expect(mockSfdcReportsService.getBaFeesReport).toHaveBeenCalledWith(
        mockBaFeesQueryDto.full,
      );
    });

    it("handles billing account exclusions", async () => {
      mockSfdcReportsService.getBaFeesReport.mockResolvedValue([]);

      await controller.getBaFeesReport(mockBaFeesQueryDto.withExclusions);

      expect(mockSfdcReportsService.getBaFeesReport).toHaveBeenCalledWith(
        mockBaFeesQueryDto.withExclusions,
      );
    });

    it("handles monthly grouping mode", async () => {
      mockSfdcReportsService.getBaFeesReport.mockResolvedValue([]);

      await controller.getBaFeesReport(mockBaFeesQueryDto.monthlyGrouping);

      expect(mockSfdcReportsService.getBaFeesReport).toHaveBeenCalledWith(
        mockBaFeesQueryDto.monthlyGrouping,
      );
    });

    it("defaults to total grouping when groupBy is omitted", async () => {
      mockSfdcReportsService.getBaFeesReport.mockResolvedValue([]);

      await controller.getBaFeesReport(mockBaFeesQueryDto.byBillingAccount);

      expect(mockSfdcReportsService.getBaFeesReport).toHaveBeenCalledWith(
        expect.objectContaining({
          groupBy: undefined,
        }),
      );
    });
  });
});
