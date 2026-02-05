import "reflect-metadata";
import { plainToInstance } from "class-transformer";
import { validate } from "class-validator";

import {
  BaFeesReportQueryDto,
  ChallengesFilterMode,
  ChallengesReportQueryDto,
  PaymentsReportQueryDto,
  TaasJobsReportQueryDto,
  TaasMemberVerificationReportQueryDto,
  TaasResourceBookingsReportQueryDto,
  WesternUnionPaymentsReportQueryDto,
} from "./sfdc-reports.dto";

const validateDto = async (input: Partial<ChallengesReportQueryDto>) => {
  const dto = plainToInstance(ChallengesReportQueryDto, input);
  const errors = await validate(dto);
  return { dto, errors };
};

const validatePaymentDto = async (input: Partial<PaymentsReportQueryDto>) => {
  const dto = plainToInstance(PaymentsReportQueryDto, input);
  const errors = await validate(dto);
  return { dto, errors };
};

const validateTaasJobsDto = async (input: Partial<TaasJobsReportQueryDto>) => {
  const dto = plainToInstance(TaasJobsReportQueryDto, input);
  const errors = await validate(dto);
  return { dto, errors };
};

const validateTaasResourceBookingsDto = async (
  input: Partial<TaasResourceBookingsReportQueryDto>,
) => {
  const dto = plainToInstance(TaasResourceBookingsReportQueryDto, input);
  const errors = await validate(dto);
  return { dto, errors };
};

const validateTaasMemberVerificationDto = async (
  input: Partial<TaasMemberVerificationReportQueryDto>,
) => {
  const dto = plainToInstance(TaasMemberVerificationReportQueryDto, input);
  const errors = await validate(dto);
  return { dto, errors };
};

const validateWesternUnionPaymentsDto = async (
  input: Partial<WesternUnionPaymentsReportQueryDto>,
) => {
  const dto = plainToInstance(WesternUnionPaymentsReportQueryDto, input);
  const errors = await validate(dto);
  return { dto, errors };
};

const validateBaFeesDto = async (input: Partial<BaFeesReportQueryDto>) => {
  const dto = plainToInstance(BaFeesReportQueryDto, input);
  const errors = await validate(dto);
  return { dto, errors };
};

describe("ChallengesReportQueryDto validation", () => {
  it("accepts a minimal DTO with no filters", async () => {
    const { errors } = await validateDto({});
    expect(errors).toHaveLength(0);
  });

  it("accepts a DTO with all filters provided", async () => {
    const { errors } = await validateDto({
      billingAccountIds: ["80001012", "!90000000"],
      challengeIds: ["e74c3e37-73c9-474e-a838-a38dd4738906"],
      filterMode: ChallengesFilterMode.BILLING_ACCOUNT,
      challengeName: "Task Payment for member",
      challengeStatus: ["COMPLETED", "ACTIVE"],
      startDate: "2023-01-01T00:00:00.000Z",
      endDate: "2023-03-01T00:00:00.000Z",
      isTask: true,
      handles: ["user_01", "user_02"],
      minAmount: 50,
      maxAmount: 1000,
    });
    expect(errors).toHaveLength(0);
  });

  it("validates billingAccountIds as strings", async () => {
    const { errors } = await validateDto({
      billingAccountIds: ["80001012", "80001013"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms a single billingAccountId string into an array", async () => {
    const { dto, errors } = await validateDto({
      // @ts-expect-error intentional single value for transform check
      billingAccountIds: "80001012",
    });
    expect(errors).toHaveLength(0);
    expect(dto.billingAccountIds).toEqual(["80001012"]);
  });

  it("rejects empty billingAccountIds entries", async () => {
    const { errors } = await validateDto({ billingAccountIds: [""] });
    expect(errors.some((err) => err.property === "billingAccountIds")).toBe(
      true,
    );
  });

  it("rejects non-string billingAccountIds entries", async () => {
    const { errors } = await validateDto({
      billingAccountIds: [123 as unknown as string],
    });
    expect(errors.some((err) => err.property === "billingAccountIds")).toBe(
      true,
    );
  });

  it("accepts valid challengeIds", async () => {
    const { errors } = await validateDto({
      challengeIds: ["e74c3e37-73c9-474e-a838-a38dd4738906"],
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects empty challengeIds entries", async () => {
    const { errors } = await validateDto({ challengeIds: [""] });
    expect(errors.some((err) => err.property === "challengeIds")).toBe(true);
  });

  it.each([
    [ChallengesFilterMode.BILLING_ACCOUNT],
    [ChallengesFilterMode.CHALLENGE],
  ])("accepts filterMode %s", async (filterMode) => {
    const { errors } = await validateDto({ filterMode });
    expect(errors).toHaveLength(0);
  });

  it("rejects an invalid filterMode value", async () => {
    const { errors } = await validateDto({ filterMode: "invalid" as any });
    expect(errors.some((err) => err.property === "filterMode")).toBe(true);
  });

  it("accepts a non-empty challengeName", async () => {
    const { errors } = await validateDto({ challengeName: "Sample" });
    expect(errors).toHaveLength(0);
  });

  it("rejects an empty challengeName", async () => {
    const { errors } = await validateDto({ challengeName: "" });
    expect(errors.some((err) => err.property === "challengeName")).toBe(true);
  });

  it("accepts challengeStatus values", async () => {
    const { errors } = await validateDto({
      challengeStatus: ["COMPLETED", "ACTIVE"],
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects empty challengeStatus entries", async () => {
    const { errors } = await validateDto({ challengeStatus: [""] });
    expect(errors.some((err) => err.property === "challengeStatus")).toBe(true);
  });

  it("accepts ISO date strings for startDate and endDate", async () => {
    const { errors } = await validateDto({
      startDate: "2023-01-01T00:00:00.000Z",
      endDate: "2023-01-31T23:59:59.000Z",
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects invalid date strings", async () => {
    const { errors } = await validateDto({ startDate: "not-a-date" as any });
    expect(errors.some((err) => err.property === "startDate")).toBe(true);
  });

  it("accepts boolean isTask values", async () => {
    const { errors } = await validateDto({ isTask: false });
    expect(errors).toHaveLength(0);
  });

  it("accepts string isTask values that convert to boolean", async () => {
    const { dto, errors } = await validateDto({ isTask: "true" as any });
    expect(errors).toHaveLength(0);
    expect(dto.isTask).toBe(true);
  });

  it("rejects non-boolean isTask values when not transformable", async () => {
    const dto = new ChallengesReportQueryDto();
    (dto as any).isTask = "not-boolean";

    const errors = await validate(dto);
    expect(errors.some((err) => err.property === "isTask")).toBe(true);
  });

  it("rejects handles with empty entries", async () => {
    const { errors } = await validateDto({ handles: [""] });
    expect(errors.some((err) => err.property === "handles")).toBe(true);
  });

  it("accepts numeric amounts", async () => {
    const { errors } = await validateDto({ minAmount: 100, maxAmount: 1000 });
    expect(errors).toHaveLength(0);
  });

  it("transforms string amounts into numbers", async () => {
    const { dto, errors } = await validateDto({ minAmount: "100" as any });
    expect(errors).toHaveLength(0);
    expect(dto.minAmount).toBe(100);
  });

  it("rejects NaN amounts", async () => {
    const { errors } = await validateDto({ minAmount: NaN });
    expect(errors.some((err) => err.property === "minAmount")).toBe(true);
  });

  it("rejects infinite amounts", async () => {
    const { errors } = await validateDto({ maxAmount: Infinity });
    expect(errors.some((err) => err.property === "maxAmount")).toBe(true);
  });
});

describe("PaymentsReportQueryDto validation", () => {
  it("accepts a minimal DTO with no filters", async () => {
    const { errors } = await validatePaymentDto({});
    expect(errors).toHaveLength(0);
  });

  it("accepts a DTO with all filters provided", async () => {
    const { errors } = await validatePaymentDto({
      billingAccountIds: ["80001012", "!90000000"],
      challengeIds: ["e74c3e37-73c9-474e-a838-a38dd4738906"],
      handles: ["user_01", "user_02"],
      challengeName: "Task Payment for member",
      startDate: "2023-01-01T00:00:00.000Z",
      endDate: "2023-03-01T00:00:00.000Z",
      minPaymentAmount: 100,
      maxPaymentAmount: 1000,
      challengeStatus: ["COMPLETED", "ACTIVE"],
      status: ["ON_HOLD", "PROCESSING"],
    });
    expect(errors).toHaveLength(0);
  });

  it("validates billingAccountIds as strings", async () => {
    const { errors } = await validatePaymentDto({
      billingAccountIds: ["80001012", "80001013"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms a single billingAccountId string into an array", async () => {
    const { dto, errors } = await validatePaymentDto({
      // @ts-expect-error intentional single value for transform check
      billingAccountIds: "80001012",
    });
    expect(errors).toHaveLength(0);
    expect(dto.billingAccountIds).toEqual(["80001012"]);
  });

  it("rejects empty billingAccountIds entries", async () => {
    const { errors } = await validatePaymentDto({ billingAccountIds: [""] });
    expect(errors.some((err) => err.property === "billingAccountIds")).toBe(
      true,
    );
  });

  it("rejects non-string billingAccountIds entries", async () => {
    const { errors } = await validatePaymentDto({
      billingAccountIds: [123 as unknown as string],
    });
    expect(errors.some((err) => err.property === "billingAccountIds")).toBe(
      true,
    );
  });

  it("accepts valid challengeIds", async () => {
    const { errors } = await validatePaymentDto({
      challengeIds: ["uuid1", "uuid2"],
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects empty challengeIds entries", async () => {
    const { errors } = await validatePaymentDto({ challengeIds: [""] });
    expect(errors.some((err) => err.property === "challengeIds")).toBe(true);
  });

  it("transforms single challengeId into array", async () => {
    const { dto, errors } = await validatePaymentDto({
      // @ts-expect-error intentional single value for transform check
      challengeIds: "uuid1",
    });
    expect(errors).toHaveLength(0);
    expect(dto.challengeIds).toEqual(["uuid1"]);
  });

  it("accepts valid handles", async () => {
    const { errors } = await validatePaymentDto({
      handles: ["user1", "user2"],
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects empty handles entries", async () => {
    const { errors } = await validatePaymentDto({ handles: [""] });
    expect(errors.some((err) => err.property === "handles")).toBe(true);
  });

  it("accepts non-empty challengeName", async () => {
    const { errors } = await validatePaymentDto({
      challengeName: "Task Payment",
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects empty challengeName", async () => {
    const { errors } = await validatePaymentDto({ challengeName: "" });
    expect(errors.some((err) => err.property === "challengeName")).toBe(true);
  });

  it("accepts ISO date strings for startDate and endDate", async () => {
    const { errors } = await validatePaymentDto({
      startDate: "2023-01-01T00:00:00.000Z",
      endDate: "2023-01-31T23:59:59.000Z",
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects invalid date strings", async () => {
    const { errors } = await validatePaymentDto({
      startDate: "not-a-date",
    });
    expect(errors.some((err) => err.property === "startDate")).toBe(true);
  });

  it("accepts numeric payment amounts", async () => {
    const { errors } = await validatePaymentDto({
      minPaymentAmount: 100,
      maxPaymentAmount: 1000,
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms string amounts into numbers", async () => {
    const { dto, errors } = await validatePaymentDto({
      // @ts-expect-error intentional single value for transform check
      minPaymentAmount: "100",
    });
    expect(errors).toHaveLength(0);
    expect(dto.minPaymentAmount).toBe(100);
  });

  it("rejects NaN amounts", async () => {
    const { errors } = await validatePaymentDto({ minPaymentAmount: NaN });
    expect(errors.some((err) => err.property === "minPaymentAmount")).toBe(
      true,
    );
  });

  it("rejects infinite amounts", async () => {
    const { errors } = await validatePaymentDto({
      maxPaymentAmount: Infinity,
    });
    expect(errors.some((err) => err.property === "maxPaymentAmount")).toBe(
      true,
    );
  });

  it("accepts challengeStatus values", async () => {
    const { errors } = await validatePaymentDto({
      challengeStatus: ["COMPLETED", "ACTIVE"],
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects empty challengeStatus entries", async () => {
    const { errors } = await validatePaymentDto({ challengeStatus: [""] });
    expect(errors.some((err) => err.property === "challengeStatus")).toBe(true);
  });

  it("transforms single challengeStatus into array", async () => {
    const { dto, errors } = await validatePaymentDto({
      // @ts-expect-error intentional single value for transform check
      challengeStatus: "COMPLETED",
    });
    expect(errors).toHaveLength(0);
    expect(dto.challengeStatus).toEqual(["COMPLETED"]);
  });

  it("accepts payment status values", async () => {
    const { errors } = await validatePaymentDto({
      status: ["ON_HOLD", "PROCESSING"],
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects empty payment status entries", async () => {
    const { errors } = await validatePaymentDto({ status: [""] });
    expect(errors.some((err) => err.property === "status")).toBe(true);
  });

  it("transforms single payment status into array", async () => {
    const { dto, errors } = await validatePaymentDto({
      // @ts-expect-error intentional single value for transform check
      status: "PROCESSING",
    });
    expect(errors).toHaveLength(0);
    expect(dto.status).toEqual(["PROCESSING"]);
  });
});

describe("TaasJobsReportQueryDto validation", () => {
  it("accepts a minimal DTO with no filters", async () => {
    const { errors } = await validateTaasJobsDto({});
    expect(errors).toHaveLength(0);
  });

  it("accepts a DTO with all filters provided", async () => {
    const { errors } = await validateTaasJobsDto({
      jobIds: ["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
      projectIds: [12345, 67890],
      status: ["open", "assigned"],
      resourceType: ["developer"],
      skills: ["React", "TypeScript"],
      startDate: "2023-04-01",
      endDate: "2023-05-31",
      minPositions: 1,
      maxPositions: 3,
    });
    expect(errors).toHaveLength(0);
  });

  it("validates jobIds as UUID strings", async () => {
    const { errors } = await validateTaasJobsDto({
      jobIds: ["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single jobId string into array", async () => {
    const { dto, errors } = await validateTaasJobsDto({
      // @ts-expect-error intentional single value for transform check
      jobIds: "a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
    });
    expect(errors).toHaveLength(0);
    expect(dto.jobIds).toEqual(["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"]);
  });

  it("rejects empty jobIds entries", async () => {
    const { errors } = await validateTaasJobsDto({ jobIds: [""] });
    expect(errors.some((err) => err.property === "jobIds")).toBe(true);
  });

  it("validates projectIds as numbers", async () => {
    const { errors } = await validateTaasJobsDto({
      projectIds: [12345, 67890],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single projectId string into number array", async () => {
    const { dto, errors } = await validateTaasJobsDto({
      // @ts-expect-error intentional single value for transform check
      projectIds: "12345",
    });
    expect(errors).toHaveLength(0);
    expect(dto.projectIds).toEqual([12345]);
  });

  it("rejects non-numeric projectIds", async () => {
    const { errors } = await validateTaasJobsDto({
      projectIds: ["abc"] as any,
    });
    expect(errors.some((err) => err.property === "projectIds")).toBe(true);
  });

  it("validates status as strings", async () => {
    const { errors } = await validateTaasJobsDto({
      status: ["open", "assigned"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single status into array", async () => {
    const { dto, errors } = await validateTaasJobsDto({
      // @ts-expect-error intentional single value for transform check
      status: "open",
    });
    expect(errors).toHaveLength(0);
    expect(dto.status).toEqual(["open"]);
  });

  it("rejects empty status entries", async () => {
    const { errors } = await validateTaasJobsDto({ status: [""] });
    expect(errors.some((err) => err.property === "status")).toBe(true);
  });

  it("validates resourceType as strings", async () => {
    const { errors } = await validateTaasJobsDto({
      resourceType: ["designer", "developer"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single resourceType into array", async () => {
    const { dto, errors } = await validateTaasJobsDto({
      // @ts-expect-error intentional single value for transform check
      resourceType: "developer",
    });
    expect(errors).toHaveLength(0);
    expect(dto.resourceType).toEqual(["developer"]);
  });

  it("validates skills as strings", async () => {
    const { errors } = await validateTaasJobsDto({
      skills: ["React", "Node.js"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single skill into array", async () => {
    const { dto, errors } = await validateTaasJobsDto({
      // @ts-expect-error intentional single value for transform check
      skills: "React",
    });
    expect(errors).toHaveLength(0);
    expect(dto.skills).toEqual(["React"]);
  });

  it("accepts ISO date strings for startDate and endDate", async () => {
    const { errors } = await validateTaasJobsDto({
      startDate: "2023-04-01",
      endDate: "2023-05-31",
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects invalid date strings", async () => {
    const { errors } = await validateTaasJobsDto({
      startDate: "invalid-date" as any,
    });
    expect(errors.some((err) => err.property === "startDate")).toBe(true);
  });

  it("accepts numeric minPositions and maxPositions", async () => {
    const { errors } = await validateTaasJobsDto({
      minPositions: 1,
      maxPositions: 3,
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms string positions into numbers", async () => {
    const { dto, errors } = await validateTaasJobsDto({
      // @ts-expect-error intentional single value for transform check
      minPositions: "1",
    });
    expect(errors).toHaveLength(0);
    expect(dto.minPositions).toBe(1);
  });

  it("rejects NaN positions", async () => {
    const { errors } = await validateTaasJobsDto({ minPositions: NaN });
    expect(errors.some((err) => err.property === "minPositions")).toBe(true);
  });

  it("rejects infinite positions", async () => {
    const { errors } = await validateTaasJobsDto({ maxPositions: Infinity });
    expect(errors.some((err) => err.property === "maxPositions")).toBe(true);
  });
});

describe("TaasResourceBookingsReportQueryDto validation", () => {
  it("accepts a minimal DTO with no filters", async () => {
    const { errors } = await validateTaasResourceBookingsDto({});
    expect(errors).toHaveLength(0);
  });

  it("accepts a DTO with all filters provided", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      resourceBookingIds: ["c2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
      jobIds: ["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
      projectIds: [12345],
      userIds: ["100001"],
      handles: ["dev_user"],
      status: ["placed", "active"],
      billingAccountIds: ["80001012"],
      startDate: "2023-04-01",
      endDate: "2023-06-30",
      minCustomerRate: 90,
      maxCustomerRate: 2300,
    });
    expect(errors).toHaveLength(0);
  });

  it("validates resourceBookingIds as UUID strings", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      resourceBookingIds: ["c2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single resourceBookingId into array", async () => {
    const { dto, errors } = await validateTaasResourceBookingsDto({
      // @ts-expect-error intentional single value for transform check
      resourceBookingIds: "c2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
    });
    expect(errors).toHaveLength(0);
    expect(dto.resourceBookingIds).toEqual([
      "c2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
    ]);
  });

  it("rejects empty resourceBookingIds entries", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      resourceBookingIds: [""],
    });
    expect(errors.some((err) => err.property === "resourceBookingIds")).toBe(
      true,
    );
  });

  it("validates jobIds as UUID strings", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      jobIds: ["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single jobId into array", async () => {
    const { dto, errors } = await validateTaasResourceBookingsDto({
      // @ts-expect-error intentional single value for transform check
      jobIds: "a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
    });
    expect(errors).toHaveLength(0);
    expect(dto.jobIds).toEqual(["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"]);
  });

  it("validates projectIds as numbers", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      projectIds: [12345, 67890],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single projectId string into number array", async () => {
    const { dto, errors } = await validateTaasResourceBookingsDto({
      // @ts-expect-error intentional single value for transform check
      projectIds: "12345",
    });
    expect(errors).toHaveLength(0);
    expect(dto.projectIds).toEqual([12345]);
  });

  it("validates userIds as strings", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      userIds: ["100001", "100002"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single userId into array", async () => {
    const { dto, errors } = await validateTaasResourceBookingsDto({
      // @ts-expect-error intentional single value for transform check
      userIds: "100001",
    });
    expect(errors).toHaveLength(0);
    expect(dto.userIds).toEqual(["100001"]);
  });

  it("validates handles as strings", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      handles: ["user1", "user2"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single handle into array", async () => {
    const { dto, errors } = await validateTaasResourceBookingsDto({
      // @ts-expect-error intentional single value for transform check
      handles: "user1",
    });
    expect(errors).toHaveLength(0);
    expect(dto.handles).toEqual(["user1"]);
  });

  it("rejects empty handles entries", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      handles: [""],
    });
    expect(errors.some((err) => err.property === "handles")).toBe(true);
  });

  it("validates status as strings", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      status: ["placed", "active"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single status into array", async () => {
    const { dto, errors } = await validateTaasResourceBookingsDto({
      // @ts-expect-error intentional single value for transform check
      status: "placed",
    });
    expect(errors).toHaveLength(0);
    expect(dto.status).toEqual(["placed"]);
  });

  it("validates billingAccountIds as strings", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      billingAccountIds: ["80001012", "90001012"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single billingAccountId into array", async () => {
    const { dto, errors } = await validateTaasResourceBookingsDto({
      // @ts-expect-error intentional single value for transform check
      billingAccountIds: "80001012",
    });
    expect(errors).toHaveLength(0);
    expect(dto.billingAccountIds).toEqual(["80001012"]);
  });

  it("splits comma-delimited billingAccountIds", async () => {
    const { dto, errors } = await validateTaasResourceBookingsDto({
      // @ts-expect-error intentional single value for transform check
      billingAccountIds: "80001012,80002012 , 80003012",
    });
    expect(errors).toHaveLength(0);
    expect(dto.billingAccountIds).toEqual(["80001012", "80002012", "80003012"]);
  });

  it("accepts ISO date strings for startDate and endDate", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      startDate: "2023-04-01",
      endDate: "2023-06-30",
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects invalid date strings", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      endDate: "invalid-date" as any,
    });
    expect(errors.some((err) => err.property === "endDate")).toBe(true);
  });

  it("accepts numeric minCustomerRate and maxCustomerRate", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      minCustomerRate: 90,
      maxCustomerRate: 2300,
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms string rates into numbers", async () => {
    const { dto, errors } = await validateTaasResourceBookingsDto({
      // @ts-expect-error intentional single value for transform check
      minCustomerRate: "90",
    });
    expect(errors).toHaveLength(0);
    expect(dto.minCustomerRate).toBe(90);
  });

  it("rejects NaN rates", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      minCustomerRate: NaN,
    });
    expect(errors.some((err) => err.property === "minCustomerRate")).toBe(true);
  });

  it("rejects infinite rates", async () => {
    const { errors } = await validateTaasResourceBookingsDto({
      maxCustomerRate: Infinity,
    });
    expect(errors.some((err) => err.property === "maxCustomerRate")).toBe(true);
  });
});

describe("TaasMemberVerificationReportQueryDto validation", () => {
  it("accepts a DTO with single handle", async () => {
    const { errors } = await validateTaasMemberVerificationDto({
      handles: ["user1"],
    });
    expect(errors).toHaveLength(0);
  });

  it("accepts a DTO with multiple handles", async () => {
    const { errors } = await validateTaasMemberVerificationDto({
      handles: ["user1", "user2", "user3"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single handle string into array", async () => {
    const { dto, errors } = await validateTaasMemberVerificationDto({
      // @ts-expect-error intentional single value for transform check
      handles: "user1",
    });
    expect(errors).toHaveLength(0);
    expect(dto.handles).toEqual(["user1"]);
  });

  it("rejects empty handles array", async () => {
    const { errors } = await validateTaasMemberVerificationDto({ handles: [] });
    expect(errors.some((err) => err.property === "handles")).toBe(true);
  });

  it("rejects empty handle entries", async () => {
    const { errors } = await validateTaasMemberVerificationDto({
      handles: [""],
    });
    expect(errors.some((err) => err.property === "handles")).toBe(true);
  });

  it("rejects non-string handles", async () => {
    const { errors } = await validateTaasMemberVerificationDto({
      handles: [123 as any],
    });
    expect(errors.some((err) => err.property === "handles")).toBe(true);
  });

  it("rejects missing handles field", async () => {
    const { errors } = await validateTaasMemberVerificationDto({});
    expect(errors.some((err) => err.property === "handles")).toBe(true);
  });
});

describe("WesternUnionPaymentsReportQueryDto validation", () => {
  it("accepts a minimal DTO with no filters", async () => {
    const { errors } = await validateWesternUnionPaymentsDto({});
    expect(errors).toHaveLength(0);
  });

  it("accepts a DTO with all filters provided", async () => {
    const { errors } = await validateWesternUnionPaymentsDto({
      paymentStatus: "Paid",
      paymentMethod: "Western Union",
      startDate: "2023-01-01",
      endDate: "2023-03-31",
      handles: ["user1", "user2"],
    });
    expect(errors).toHaveLength(0);
  });

  it("validates paymentStatus as string", async () => {
    const { errors } = await validateWesternUnionPaymentsDto({
      paymentStatus: "Paid",
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects empty paymentStatus", async () => {
    const { errors } = await validateWesternUnionPaymentsDto({
      paymentStatus: "",
    });
    expect(errors.some((err) => err.property === "paymentStatus")).toBe(true);
  });

  it("validates paymentMethod as string", async () => {
    const { errors } = await validateWesternUnionPaymentsDto({
      paymentMethod: "Western Union",
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects empty paymentMethod", async () => {
    const { errors } = await validateWesternUnionPaymentsDto({
      paymentMethod: "",
    });
    expect(errors.some((err) => err.property === "paymentMethod")).toBe(true);
  });

  it("accepts ISO date strings for startDate and endDate", async () => {
    const { errors } = await validateWesternUnionPaymentsDto({
      startDate: "2023-01-01",
      endDate: "2023-03-31",
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects invalid date strings", async () => {
    const { errors } = await validateWesternUnionPaymentsDto({
      startDate: "invalid-date" as any,
    });
    expect(errors.some((err) => err.property === "startDate")).toBe(true);
  });

  it("validates handles as strings", async () => {
    const { errors } = await validateWesternUnionPaymentsDto({
      handles: ["user1", "user2"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms single handle into array", async () => {
    const { dto, errors } = await validateWesternUnionPaymentsDto({
      // @ts-expect-error intentional single value for transform check
      handles: "user1",
    });
    expect(errors).toHaveLength(0);
    expect(dto.handles).toEqual(["user1"]);
  });

  it("rejects empty handles entries", async () => {
    const { errors } = await validateWesternUnionPaymentsDto({
      handles: [""],
    });
    expect(errors.some((err) => err.property === "handles")).toBe(true);
  });
});

describe("BaFeesReportQueryDto validation", () => {
  it("accepts a minimal DTO with no filters", async () => {
    const { errors } = await validateBaFeesDto({});
    expect(errors).toHaveLength(0);
  });

  it("accepts a DTO with all filters provided", async () => {
    const { errors } = await validateBaFeesDto({
      billingAccountIds: ["80001012", "!90000000"],
      startDate: "2023-01-01T00:00:00.000Z",
      endDate: "2023-12-31T23:59:59.000Z",
      groupBy: "month",
    });
    expect(errors).toHaveLength(0);
  });

  it("validates billingAccountIds as strings", async () => {
    const { errors } = await validateBaFeesDto({
      billingAccountIds: ["80001012", "90000000"],
    });
    expect(errors).toHaveLength(0);
  });

  it("transforms a single billingAccountId string into an array", async () => {
    const { dto, errors } = await validateBaFeesDto({
      // @ts-expect-error intentional single value for transform check
      billingAccountIds: "80001012",
    });
    expect(errors).toHaveLength(0);
    expect(dto.billingAccountIds).toEqual(["80001012"]);
  });

  it("rejects empty billingAccountIds entries", async () => {
    const { errors } = await validateBaFeesDto({
      billingAccountIds: [""],
    });
    expect(errors.some((err) => err.property === "billingAccountIds")).toBe(
      true,
    );
  });

  it("rejects non-string billingAccountIds entries", async () => {
    const { errors } = await validateBaFeesDto({
      billingAccountIds: [123 as unknown as string],
    });
    expect(errors.some((err) => err.property === "billingAccountIds")).toBe(
      true,
    );
  });

  it("accepts ISO date strings for startDate and endDate", async () => {
    const { errors } = await validateBaFeesDto({
      startDate: "2023-01-01T00:00:00.000Z",
      endDate: "2023-12-31T23:59:59.000Z",
    });
    expect(errors).toHaveLength(0);
  });

  it("rejects invalid date strings", async () => {
    const { errors } = await validateBaFeesDto({
      startDate: "not-a-date" as any,
    });
    expect(errors.some((err) => err.property === "startDate")).toBe(true);
  });

  it.each([["total"], ["month"]])(
    "accepts valid groupBy values: %s",
    async (groupBy) => {
      const { errors } = await validateBaFeesDto({
        groupBy: groupBy as BaFeesReportQueryDto["groupBy"],
      });
      expect(errors).toHaveLength(0);
    },
  );

  it("rejects invalid groupBy values", async () => {
    const { errors } = await validateBaFeesDto({
      groupBy: "invalid" as any,
    });
    expect(errors.some((err) => err.property === "groupBy")).toBe(true);
  });

  it("defaults groupBy to total when omitted", async () => {
    const { errors } = await validateBaFeesDto({
      billingAccountIds: ["80001012"],
    });
    expect(errors).toHaveLength(0);
  });
});
