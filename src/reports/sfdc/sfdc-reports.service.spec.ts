import { BadRequestException } from "@nestjs/common";
import { Test, TestingModule } from "@nestjs/testing";
import { SqlLoaderService } from "src/common/sql-loader.service";
import { DbService } from "../../db/db.service";
import {
  ChallengesFilterMode,
  ChallengesReportQueryDto,
  PaymentsReportQueryDto,
  TaasJobsReportQueryDto,
} from "./sfdc-reports.dto";
import { SfdcReportsService } from "./sfdc-reports.service";
import {
  mockChallengeData,
  mockChallengeQueryDto,
  mockBaFeesData,
  mockBaFeesQueryDto,
  mockPaymentData,
  mockPaymentQueryDto,
  normalizedChallengeData,
  normalizedPaymentData,
  mockSqlQuery,
  mockTaasJobsData,
  mockTaasJobsQueryDto,
  mockTaasMemberVerificationData,
  mockTaasMemberVerificationQueryDto,
  mockTaasResourceBookingsData,
  mockTaasResourceBookingsQueryDto,
  mockWesternUnionPaymentsData,
  mockWesternUnionPaymentsQueryDto,
} from "./test-helpers/mock-data";

describe("SfdcReportsService - getChallengesReport", () => {
  let service: SfdcReportsService;
  let moduleRef: TestingModule;

  const mockDbService = {
    query: jest.fn(),
  };

  const mockSqlLoaderService = {
    load: jest.fn(),
  };

  beforeEach(async () => {
    mockDbService.query.mockReset();
    mockSqlLoaderService.load.mockReset();
    mockDbService.query.mockResolvedValue(mockChallengeData);
    mockSqlLoaderService.load.mockReturnValue(mockSqlQuery);

    moduleRef = await Test.createTestingModule({
      providers: [
        SfdcReportsService,
        { provide: DbService, useValue: mockDbService },
        { provide: SqlLoaderService, useValue: mockSqlLoaderService },
      ],
    }).compile();

    service = moduleRef.get<SfdcReportsService>(SfdcReportsService);
  });

  it("creates the service", () => {
    expect(service).toBeDefined();
  });

  it("runs a billing account query successfully", async () => {
    const result = await service.getChallengesReport(
      mockChallengeQueryDto.billingAccount,
    );

    expect(mockSqlLoaderService.load).toHaveBeenCalledWith(
      "reports/sfdc/challenges.sql",
    );
    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      ["80001012"],
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
    expect(result).toEqual(normalizedChallengeData);
  });

  it("runs a challengeId query successfully", async () => {
    const filters: ChallengesReportQueryDto = {
      challengeIds: ["uuid1", "uuid2"],
      filterMode: ChallengesFilterMode.CHALLENGE,
    };

    await service.getChallengesReport(filters);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      undefined,
      undefined,
      ["uuid1", "uuid2"],
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
  });

  it("splits include/exclude billing account filters", async () => {
    await service.getChallengesReport({
      billingAccountIds: ["12345", "!67890"],
    });

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      ["12345"],
      ["67890"],
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
  });

  it("rejects challenge mode with billingAccountIds", async () => {
    await expect(
      service.getChallengesReport({
        billingAccountIds: ["12345"],
        challengeIds: ["uuid1"],
        filterMode: ChallengesFilterMode.CHALLENGE,
      }),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it("rejects derived challenge mode when billingAccountIds accompany challengeIds", async () => {
    await expect(
      service.getChallengesReport({
        billingAccountIds: ["12345"],
        challengeIds: ["uuid1"],
      }),
    ).rejects.toThrow(
      "billingAccountIds cannot be supplied when filterMode is 'challenge'.",
    );
  });

  it("rejects challenge mode without challengeIds", async () => {
    await expect(
      service.getChallengesReport({
        filterMode: ChallengesFilterMode.CHALLENGE,
      }),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it("rejects challenge mode when challengeIds is an empty array", async () => {
    await expect(
      service.getChallengesReport({
        filterMode: ChallengesFilterMode.CHALLENGE,
        challengeIds: [],
      }),
    ).rejects.toThrow(
      "challengeIds must be provided when filterMode is 'challenge'.",
    );
  });

  it("rejects billingAccount mode when challengeIds are supplied explicitly", async () => {
    await expect(
      service.getChallengesReport({
        filterMode: ChallengesFilterMode.BILLING_ACCOUNT,
        challengeIds: ["uuid1"],
      }),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it("passes optional filters in the right order", async () => {
    const filters: ChallengesReportQueryDto = {
      billingAccountIds: ["80001012"],
      challengeName: "Task Payment",
      challengeStatus: ["ACTIVE"],
      startDate: "2023-01-01T00:00:00.000Z",
      endDate: "2023-02-01T00:00:00.000Z",
      isTask: true,
      handles: ["user_01"],
      minAmount: 100,
      maxAmount: 200,
    };

    await service.getChallengesReport(filters);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      ["80001012"],
      undefined,
      undefined,
      "Task Payment",
      ["ACTIVE"],
      "2023-01-01T00:00:00.000Z",
      "2023-02-01T00:00:00.000Z",
      true,
      ["user_01"],
      100,
      200,
    ]);
  });

  it("defaults filterMode to billingAccount when billingAccountIds are provided", async () => {
    await service.getChallengesReport({ billingAccountIds: ["80001012"] });

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      ["80001012"],
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
  });

  it("defaults filterMode to challenge when only challengeIds are provided", async () => {
    await service.getChallengesReport({ challengeIds: ["uuid1", "uuid2"] });

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      undefined,
      undefined,
      ["uuid1", "uuid2"],
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
  });

  it("returns an empty array when the query has no results", async () => {
    mockDbService.query.mockResolvedValueOnce([]);

    const result = await service.getChallengesReport(
      mockChallengeQueryDto.billingAccount,
    );

    expect(result).toEqual([]);
  });

  it("propagates database errors", async () => {
    mockDbService.query.mockRejectedValueOnce(new Error("db error"));

    await expect(
      service.getChallengesReport(mockChallengeQueryDto.billingAccount),
    ).rejects.toThrow("db error");
  });
});

describe("SfdcReportsService - getPaymentsReport", () => {
  let service: SfdcReportsService;
  let moduleRef: TestingModule;

  const mockDbService = {
    query: jest.fn(),
  };

  const mockSqlLoaderService = {
    load: jest.fn(),
  };

  beforeEach(async () => {
    mockDbService.query.mockReset();
    mockSqlLoaderService.load.mockReset();
    mockDbService.query.mockResolvedValue(mockPaymentData);
    mockSqlLoaderService.load.mockReturnValue(mockSqlQuery);

    moduleRef = await Test.createTestingModule({
      providers: [
        SfdcReportsService,
        { provide: DbService, useValue: mockDbService },
        { provide: SqlLoaderService, useValue: mockSqlLoaderService },
      ],
    }).compile();

    service = moduleRef.get<SfdcReportsService>(SfdcReportsService);
  });

  it("loads the payments SQL file", async () => {
    await service.getPaymentsReport(mockPaymentQueryDto.minimal);

    expect(mockSqlLoaderService.load).toHaveBeenCalledWith(
      "reports/sfdc/payments.sql",
    );
  });

  it("runs a basic query successfully", async () => {
    const result = await service.getPaymentsReport(
      mockPaymentQueryDto.billingAccount,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      ["80001012"],
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
    expect(result).toEqual(normalizedPaymentData);
  });

  it("splits include/exclude billing account filters", async () => {
    await service.getPaymentsReport({
      billingAccountIds: ["12345", "!67890"],
    });

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      ["12345"],
      ["67890"],
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
  });

  it("passes all optional filters in the right order", async () => {
    await service.getPaymentsReport(mockPaymentQueryDto.full);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      ["80001012"],
      ["90000000"],
      ["e74c3e37-73c9-474e-a838-a38dd4738906"],
      ["user_01", "user_02"],
      "Task Payment for member",
      "2023-01-01T00:00:00.000Z",
      "2023-03-01T00:00:00.000Z",
      100,
      500,
      ["COMPLETED"],
      ["PROCESSING"],
    ]);
  });

  it("handles challengeStatus filter for cancel payment checks", async () => {
    await service.getPaymentsReport(mockPaymentQueryDto.challengeStatus);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      ["COMPLETED"],
      undefined,
    ]);
  });

  it("handles payment status filter", async () => {
    await service.getPaymentsReport(mockPaymentQueryDto.paymentStatus);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      ["ON_HOLD"],
    ]);
  });

  it("handles null challengeStatus for cancellable payments", async () => {
    await service.getPaymentsReport(mockPaymentQueryDto.nullChallengeStatus);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      [null as unknown as string],
      undefined,
    ]);
  });

  it("returns empty array when query has no results", async () => {
    mockDbService.query.mockResolvedValueOnce([]);

    const result = await service.getPaymentsReport(
      mockPaymentQueryDto.billingAccount,
    );

    expect(result).toEqual([]);
  });

  it("propagates database errors", async () => {
    mockDbService.query.mockRejectedValueOnce(
      new Error("db connection failed"),
    );

    await expect(
      service.getPaymentsReport(mockPaymentQueryDto.billingAccount),
    ).rejects.toThrow("db connection failed");
  });

  it("handles empty billingAccountIds array", async () => {
    await service.getPaymentsReport({
      billingAccountIds: [],
    } as PaymentsReportQueryDto);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
  });

  it("passes undefined for omitted optional filters", async () => {
    await service.getPaymentsReport(mockPaymentQueryDto.minimal);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
  });
});

describe("SfdcReportsService - getTaasJobsReport", () => {
  let service: SfdcReportsService;
  let moduleRef: TestingModule;

  const mockDbService = {
    query: jest.fn(),
  };

  const mockSqlLoaderService = {
    load: jest.fn(),
  };

  beforeEach(async () => {
    mockDbService.query.mockReset();
    mockSqlLoaderService.load.mockReset();
    mockDbService.query.mockResolvedValue(mockTaasJobsData);
    mockSqlLoaderService.load.mockReturnValue(mockSqlQuery);

    moduleRef = await Test.createTestingModule({
      providers: [
        SfdcReportsService,
        { provide: DbService, useValue: mockDbService },
        { provide: SqlLoaderService, useValue: mockSqlLoaderService },
      ],
    }).compile();

    service = moduleRef.get<SfdcReportsService>(SfdcReportsService);
  });

  it("creates the service", () => {
    expect(service).toBeDefined();
  });

  it("loads the taas jobs SQL file", async () => {
    await service.getTaasJobsReport(mockTaasJobsQueryDto.minimal);

    expect(mockSqlLoaderService.load).toHaveBeenCalledWith(
      "reports/sfdc/taas-jobs.sql",
    );
  });

  it("runs a basic query successfully", async () => {
    const result = await service.getTaasJobsReport(
      mockTaasJobsQueryDto.byJobIds,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      ["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
    expect(result).toEqual(mockTaasJobsData);
  });

  it("passes all optional filters in the right order", async () => {
    await service.getTaasJobsReport(mockTaasJobsQueryDto.full);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      [
        "a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
        "b3ccf4f7-6e6d-4df9-9d7a-90acd2e09c63",
      ],
      [12345, 67890],
      ["open", "assigned"],
      ["developer"],
      ["React", "TypeScript"],
      "2023-04-01",
      "2023-05-31",
      1,
      3,
    ]);
  });

  it("passes undefined for omitted optional filters", async () => {
    await service.getTaasJobsReport(mockTaasJobsQueryDto.minimal);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
  });

  it("treats empty arrays as undefined", async () => {
    await service.getTaasJobsReport({ jobIds: [] } as TaasJobsReportQueryDto);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
  });

  it("returns an empty array when the query has no results", async () => {
    mockDbService.query.mockResolvedValueOnce([]);

    const result = await service.getTaasJobsReport(
      mockTaasJobsQueryDto.byJobIds,
    );

    expect(result).toEqual([]);
  });

  it("propagates database errors", async () => {
    mockDbService.query.mockRejectedValueOnce(new Error("db error"));

    await expect(
      service.getTaasJobsReport(mockTaasJobsQueryDto.byJobIds),
    ).rejects.toThrow("db error");
  });
});

describe("SfdcReportsService - getTaasResourceBookingsReport", () => {
  let service: SfdcReportsService;
  let moduleRef: TestingModule;

  const mockDbService = {
    query: jest.fn(),
  };

  const mockSqlLoaderService = {
    load: jest.fn(),
  };

  beforeEach(async () => {
    mockDbService.query.mockReset();
    mockSqlLoaderService.load.mockReset();
    mockDbService.query.mockResolvedValue(mockTaasResourceBookingsData);
    mockSqlLoaderService.load.mockReturnValue(mockSqlQuery);

    moduleRef = await Test.createTestingModule({
      providers: [
        SfdcReportsService,
        { provide: DbService, useValue: mockDbService },
        { provide: SqlLoaderService, useValue: mockSqlLoaderService },
      ],
    }).compile();

    service = moduleRef.get<SfdcReportsService>(SfdcReportsService);
  });

  it("creates the service", () => {
    expect(service).toBeDefined();
  });

  it("loads the taas resource bookings SQL file", async () => {
    await service.getTaasResourceBookingsReport(
      mockTaasResourceBookingsQueryDto.minimal,
    );

    expect(mockSqlLoaderService.load).toHaveBeenCalledWith(
      "reports/sfdc/taas-resource-bookings.sql",
    );
  });

  it("runs a basic query successfully", async () => {
    const result = await service.getTaasResourceBookingsReport(
      mockTaasResourceBookingsQueryDto.byResourceBookingIds,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      ["c2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
    expect(result).toEqual(mockTaasResourceBookingsData);
  });

  it("lowercases handles for case-insensitive matching", async () => {
    await service.getTaasResourceBookingsReport(
      mockTaasResourceBookingsQueryDto.byHandles,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      undefined,
      undefined,
      undefined,
      undefined,
      ["user1", "user2"],
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
  });

  it("passes all optional filters in the right order", async () => {
    await service.getTaasResourceBookingsReport(
      mockTaasResourceBookingsQueryDto.full,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      [
        "c2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
        "d3ccf4f7-6e6d-4df9-9d7a-90acd2e09c63",
      ],
      [
        "a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
        "b3ccf4f7-6e6d-4df9-9d7a-90acd2e09c63",
      ],
      [12345, 67890],
      ["100001", "100002"],
      ["dev_user", "design_guru"],
      ["placed", "active"],
      ["80001012", "90001012"],
      "2023-04-01",
      "2023-06-30",
      90,
      2300,
    ]);
  });

  it("passes undefined for omitted optional filters", async () => {
    await service.getTaasResourceBookingsReport(
      mockTaasResourceBookingsQueryDto.minimal,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
    ]);
  });

  it("returns an empty array when the query has no results", async () => {
    mockDbService.query.mockResolvedValueOnce([]);

    const result = await service.getTaasResourceBookingsReport(
      mockTaasResourceBookingsQueryDto.byResourceBookingIds,
    );

    expect(result).toEqual([]);
  });

  it("propagates database errors", async () => {
    mockDbService.query.mockRejectedValueOnce(new Error("db error"));

    await expect(
      service.getTaasResourceBookingsReport(
        mockTaasResourceBookingsQueryDto.byResourceBookingIds,
      ),
    ).rejects.toThrow("db error");
  });
});

describe("SfdcReportsService - getTaasMemberVerificationReport", () => {
  let service: SfdcReportsService;
  let moduleRef: TestingModule;

  const mockDbService = {
    query: jest.fn(),
  };

  const mockSqlLoaderService = {
    load: jest.fn(),
  };

  beforeEach(async () => {
    mockDbService.query.mockReset();
    mockSqlLoaderService.load.mockReset();
    mockDbService.query.mockResolvedValue(mockTaasMemberVerificationData);
    mockSqlLoaderService.load.mockReturnValue(mockSqlQuery);

    moduleRef = await Test.createTestingModule({
      providers: [
        SfdcReportsService,
        { provide: DbService, useValue: mockDbService },
        { provide: SqlLoaderService, useValue: mockSqlLoaderService },
      ],
    }).compile();

    service = moduleRef.get<SfdcReportsService>(SfdcReportsService);
  });

  it("creates the service", () => {
    expect(service).toBeDefined();
  });

  it("loads the taas member verification SQL file", async () => {
    await service.getTaasMemberVerificationReport(
      mockTaasMemberVerificationQueryDto.singleHandle,
    );

    expect(mockSqlLoaderService.load).toHaveBeenCalledWith(
      "reports/sfdc/taas-member-verification.sql",
    );
  });

  it("runs a query with a single handle", async () => {
    const result = await service.getTaasMemberVerificationReport(
      mockTaasMemberVerificationQueryDto.singleHandle,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [["user1"]]);
    expect(result).toEqual(mockTaasMemberVerificationData);
  });

  it("lowercases handles for case-insensitive matching", async () => {
    await service.getTaasMemberVerificationReport({
      handles: ["User1", "USER2"],
    });

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      ["user1", "user2"],
    ]);
  });

  it("runs a query with multiple handles", async () => {
    await service.getTaasMemberVerificationReport(
      mockTaasMemberVerificationQueryDto.multipleHandles,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      ["user1", "user2", "user3"],
    ]);
  });

  it("returns an empty array when the query has no results", async () => {
    mockDbService.query.mockResolvedValueOnce([]);

    const result = await service.getTaasMemberVerificationReport(
      mockTaasMemberVerificationQueryDto.multipleHandles,
    );

    expect(result).toEqual([]);
  });

  it("propagates database errors", async () => {
    mockDbService.query.mockRejectedValueOnce(new Error("db error"));

    await expect(
      service.getTaasMemberVerificationReport(
        mockTaasMemberVerificationQueryDto.singleHandle,
      ),
    ).rejects.toThrow("db error");
  });
});

describe("SfdcReportsService - getWesternUnionPaymentsReport", () => {
  let service: SfdcReportsService;
  let moduleRef: TestingModule;

  const mockDbService = {
    query: jest.fn(),
  };

  const mockSqlLoaderService = {
    load: jest.fn(),
  };

  beforeEach(async () => {
    mockDbService.query.mockReset();
    mockSqlLoaderService.load.mockReset();
    mockDbService.query.mockResolvedValue(mockWesternUnionPaymentsData);
    mockSqlLoaderService.load.mockReturnValue(mockSqlQuery);

    moduleRef = await Test.createTestingModule({
      providers: [
        SfdcReportsService,
        { provide: DbService, useValue: mockDbService },
        { provide: SqlLoaderService, useValue: mockSqlLoaderService },
      ],
    }).compile();

    service = moduleRef.get<SfdcReportsService>(SfdcReportsService);
  });

  it("creates the service", () => {
    expect(service).toBeDefined();
  });

  it("loads the western union payments SQL file", async () => {
    await service.getWesternUnionPaymentsReport(
      mockWesternUnionPaymentsQueryDto.minimal,
    );

    expect(mockSqlLoaderService.load).toHaveBeenCalledWith(
      "reports/sfdc/western-union-payments.sql",
    );
  });

  it("runs a basic query with defaults", async () => {
    const result = await service.getWesternUnionPaymentsReport(
      mockWesternUnionPaymentsQueryDto.minimal,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      "Entered into payment system",
      "Western Union",
      undefined,
      undefined,
      undefined,
    ]);
    expect(result).toEqual(mockWesternUnionPaymentsData);
  });

  it("lowercases handles for case-insensitive matching", async () => {
    await service.getWesternUnionPaymentsReport(
      mockWesternUnionPaymentsQueryDto.withHandles,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      "Entered into payment system",
      "Western Union",
      undefined,
      undefined,
      mockWesternUnionPaymentsQueryDto.withHandles.handles?.map((handle) =>
        handle.toLowerCase(),
      ),
    ]);
  });

  it("passes all optional filters in the right order", async () => {
    await service.getWesternUnionPaymentsReport(
      mockWesternUnionPaymentsQueryDto.full,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      "Paid",
      "Western Union",
      "2023-01-01",
      "2023-03-31",
      ["winner_one", "winner_two"],
    ]);
  });

  it("uses custom paymentStatus when provided", async () => {
    await service.getWesternUnionPaymentsReport(
      mockWesternUnionPaymentsQueryDto.withPaymentStatus,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      "Paid",
      "Western Union",
      undefined,
      undefined,
      undefined,
    ]);
  });

  it("uses custom paymentMethod when provided", async () => {
    await service.getWesternUnionPaymentsReport(
      mockWesternUnionPaymentsQueryDto.withPaymentMethod,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      "Entered into payment system",
      "Western Union",
      undefined,
      undefined,
      undefined,
    ]);
  });

  it("returns an empty array when the query has no results", async () => {
    mockDbService.query.mockResolvedValueOnce([]);

    const result = await service.getWesternUnionPaymentsReport(
      mockWesternUnionPaymentsQueryDto.full,
    );

    expect(result).toEqual([]);
  });

  it("propagates database errors", async () => {
    mockDbService.query.mockRejectedValueOnce(new Error("db error"));

    await expect(
      service.getWesternUnionPaymentsReport(
        mockWesternUnionPaymentsQueryDto.full,
      ),
    ).rejects.toThrow("db error");
  });
});

describe("SfdcReportsService - getBaFeesReport", () => {
  let service: SfdcReportsService;
  let moduleRef: TestingModule;

  const mockDbService = {
    query: jest.fn(),
  };

  const mockSqlLoaderService = {
    load: jest.fn(),
  };

  beforeEach(async () => {
    mockDbService.query.mockReset();
    mockSqlLoaderService.load.mockReset();
    mockDbService.query.mockResolvedValue(mockBaFeesData);
    mockSqlLoaderService.load.mockReturnValue(mockSqlQuery);

    moduleRef = await Test.createTestingModule({
      providers: [
        SfdcReportsService,
        { provide: DbService, useValue: mockDbService },
        { provide: SqlLoaderService, useValue: mockSqlLoaderService },
      ],
    }).compile();

    service = moduleRef.get<SfdcReportsService>(SfdcReportsService);
  });

  it("creates the service", () => {
    expect(service).toBeDefined();
  });

  it("loads ba-fees.sql for total grouping (default)", async () => {
    await service.getBaFeesReport(mockBaFeesQueryDto.byBillingAccount);

    expect(mockSqlLoaderService.load).toHaveBeenCalledWith(
      "reports/sfdc/ba-fees.sql",
    );
  });

  it("loads ba-fees-monthly.sql for month grouping", async () => {
    await service.getBaFeesReport(mockBaFeesQueryDto.monthlyGrouping);

    expect(mockSqlLoaderService.load).toHaveBeenCalledWith(
      "reports/sfdc/ba-fees-monthly.sql",
    );
  });

  it("runs a basic query successfully", async () => {
    const result = await service.getBaFeesReport(
      mockBaFeesQueryDto.byBillingAccount,
    );

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      null,
      null,
      ["80001012"],
      null,
    ]);
    expect(result).toEqual(mockBaFeesData);
  });

  it("splits include/exclude billing account filters", async () => {
    await service.getBaFeesReport(mockBaFeesQueryDto.withExclusions);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      null,
      null,
      ["80001012"],
      ["90000000"],
    ]);
  });

  it("passes all optional filters in the right order", async () => {
    await service.getBaFeesReport(mockBaFeesQueryDto.full);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      "2023-01-01T00:00:00.000Z",
      "2023-12-31T23:59:59.000Z",
      ["80001012"],
      ["90000000"],
    ]);
  });

  it("passes null for omitted optional filters", async () => {
    await service.getBaFeesReport(mockBaFeesQueryDto.minimal);

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      null,
      null,
      null,
      null,
    ]);
  });

  it("handles empty billingAccountIds array", async () => {
    await service.getBaFeesReport({ billingAccountIds: [] });

    expect(mockDbService.query).toHaveBeenCalledWith(mockSqlQuery, [
      null,
      null,
      null,
      null,
    ]);
  });

  it("returns an empty array when the query has no results", async () => {
    mockDbService.query.mockResolvedValueOnce([]);

    const result = await service.getBaFeesReport(mockBaFeesQueryDto.full);

    expect(result).toEqual([]);
  });

  it("propagates database errors", async () => {
    mockDbService.query.mockRejectedValueOnce(new Error("db error"));

    await expect(
      service.getBaFeesReport(mockBaFeesQueryDto.full),
    ).rejects.toThrow("db error");
  });
});
