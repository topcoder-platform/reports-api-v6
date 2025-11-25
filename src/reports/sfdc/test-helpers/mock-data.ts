import {
  ChallengesFilterMode,
  ChallengesReportQueryDto,
  ChallengesReportResponse,
  BaFeesReportQueryDto,
  BaFeesReportResponse,
  PaymentsReportQueryDto,
  PaymentsReportResponse,
  TaasJobsReportQueryDto,
  TaasJobsReportResponse,
  TaasMemberVerificationReportQueryDto,
  TaasMemberVerificationReportResponse,
  TaasResourceBookingsReportQueryDto,
  TaasResourceBookingsReportResponse,
  WesternUnionPaymentsReportQueryDto,
  WesternUnionPaymentsReportResponse,
} from "../sfdc-reports.dto";

export const mockChallengeData: ChallengesReportResponse[] = [
  {
    challengeId: "e74c3e37-73c9-474e-a838-a38dd4738906",
    challengeName: "Sample Challenge 1",
    billingAccountId: "80001012",
    challengeStatus: "COMPLETED",
    completeDate: "2023-01-15T00:00:00.000Z",
    paymentDate: "2023-01-16T00:00:00.000Z",
    isTask: false,
    challengeFee: 100.5,
    memberPayments: 500,
    lineItemAmount: 600.5,
    memberHandle: "user_01",
    memberFirstName: "John",
    memberLastName: "Doe",
  },
  {
    challengeId: "8d4a1ce9-6a58-4bf2-8c3b-c57a8b3a3f92",
    challengeName: "Task Payment for member",
    billingAccountId: "80001012",
    challengeStatus: "ACTIVE",
    completeDate: "2023-02-01T00:00:00.000Z",
    paymentDate: "2023-02-02T00:00:00.000Z",
    isTask: true,
    challengeFee: 75.25,
    memberPayments: 250,
    lineItemAmount: 325.25,
    memberHandle: "user_02",
    memberFirstName: "Jane",
    memberLastName: "Smith",
  },
];

export const mockChallengeQueryDto: Record<string, ChallengesReportQueryDto> = {
  minimal: {},
  billingAccount: {
    billingAccountIds: ["80001012"],
    filterMode: ChallengesFilterMode.BILLING_ACCOUNT,
  },
  challenge: {
    challengeIds: ["e74c3e37-73c9-474e-a838-a38dd4738906"],
    filterMode: ChallengesFilterMode.CHALLENGE,
  },
  full: {
    billingAccountIds: ["80001012", "!90000000"],
    filterMode: ChallengesFilterMode.BILLING_ACCOUNT,
    challengeName: "Task Payment for member",
    challengeStatus: ["COMPLETED", "ACTIVE"],
    startDate: "2023-01-01T00:00:00.000Z",
    endDate: "2023-03-01T00:00:00.000Z",
    isTask: true,
    handles: ["user_01", "user_02"],
    minAmount: 50,
    maxAmount: 1000,
  },
};

export const mockPaymentData: PaymentsReportResponse[] = [
  {
    paymentId: "f1b5e640-1de2-4a57-aad0-e6713e5b1c38",
    paymentDate: "2023-01-16T00:00:00.000Z",
    billingAccountId: "80001012",
    paymentStatus: "Paid",
    challengeFee: 150.75,
    paymentAmount: 500,
    challengeId: "e74c3e37-73c9-474e-a838-a38dd4738906",
    category: "Challenge Prizes",
    isTask: false,
    challengeName: "Sample Challenge 1",
    challengeStatus: "COMPLETED",
    winnerHandle: "user_01",
    winnerId: "123456",
    winnerFirstName: "John",
    winnerLastName: "Doe",
  },
  {
    paymentId: "8c7d0d7a-5bdc-4e78-8f4e-4a1e8c3b72df",
    paymentDate: "2023-02-05T00:00:00.000Z",
    billingAccountId: "90000000",
    paymentStatus: "Owed",
    challengeFee: 90.25,
    paymentAmount: 350,
    challengeId: "8d4a1ce9-6a58-4bf2-8c3b-c57a8b3a3f92",
    category: "Task Payments",
    isTask: true,
    challengeName: "Task Payment for member",
    challengeStatus: "ACTIVE",
    winnerHandle: "user_02",
    winnerId: "654321",
    winnerFirstName: "Jane",
    winnerLastName: "Smith",
  },
  {
    paymentId: "2d8c5a2b-3f3b-4c5a-9eaf-7dfffb9c2f2b",
    paymentDate: "2023-03-10T00:00:00.000Z",
    billingAccountId: "80001013",
    paymentStatus: "Paid",
    challengeFee: 120,
    paymentAmount: 425.5,
    challengeId: "6bc7a37d-37ad-4c52-a2f0-71fa2c84e6e3",
    category: "Marathon Match",
    isTask: false,
    challengeName: "Algo Payment",
    challengeStatus: null as unknown as string,
    winnerHandle: "user_cancel",
    winnerId: "789012",
    winnerFirstName: "Alex",
    winnerLastName: "Johnson",
  },
];

export const mockPaymentQueryDto: Record<string, PaymentsReportQueryDto> = {
  minimal: {},
  billingAccount: {
    billingAccountIds: ["80001012"],
  },
  withExclusions: {
    billingAccountIds: ["80001012", "!90000000"],
  },
  challengeStatus: {
    challengeStatus: ["COMPLETED"],
  },
  nullChallengeStatus: {
    challengeStatus: [null as unknown as string],
  },
  full: {
    billingAccountIds: ["80001012", "!90000000"],
    challengeIds: ["e74c3e37-73c9-474e-a838-a38dd4738906"],
    handles: ["user_01", "user_02"],
    challengeName: "Task Payment for member",
    startDate: "2023-01-01T00:00:00.000Z",
    endDate: "2023-03-01T00:00:00.000Z",
    minPaymentAmount: 100,
    maxPaymentAmount: 500,
    challengeStatus: ["COMPLETED"],
  },
};

export const mockBaFeesData: BaFeesReportResponse[] = [
  {
    billingAccountId: "80001012",
    totalFees: 1200.5,
    totalMemberPayments: 980.75,
    currentPaymentStatus: "Paid",
  },
  {
    billingAccountId: "90000000",
    totalFees: 850,
    totalMemberPayments: 700,
    currentPaymentStatus: "Owed",
  },
  {
    billingAccountId: "80001012",
    month: "2024-01",
    totalFees: 500,
    totalMemberPayments: 400,
    paymentCount: 15,
    earliestPaymentDate: "2024-01-02",
    latestPaymentDate: "2024-01-31",
    currentPaymentStatus: "Paid",
  },
];

export const mockBaFeesQueryDto: Record<string, BaFeesReportQueryDto> = {
  minimal: {},
  byBillingAccount: { billingAccountIds: ["80001012"] },
  withExclusions: { billingAccountIds: ["80001012", "!90000000"] },
  withDates: {
    startDate: "2023-01-01T00:00:00.000Z",
    endDate: "2023-12-31T23:59:59.000Z",
  },
  monthlyGrouping: { groupBy: "month", billingAccountIds: ["80001012"] },
  full: {
    billingAccountIds: ["80001012", "!90000000"],
    startDate: "2023-01-01T00:00:00.000Z",
    endDate: "2023-12-31T23:59:59.000Z",
    groupBy: "month",
  },
};

export const mockTaasJobsData: TaasJobsReportResponse[] = [
  {
    jobId: "a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
    projectId: 12345,
    externalId: "EXT-1001",
    title: "Frontend Developer",
    description: "Build UI components for dashboards",
    status: "open",
    resourceType: "developer",
    rateType: "hourly",
    skills: ["React", "TypeScript"],
    numPositions: 2,
    startDate: "2023-04-01",
    duration: 12,
    workload: "full-time",
    minSalary: 60,
    maxSalary: 85,
    hoursPerWeek: 40,
    currency: "USD",
    createdAt: "2023-03-15T10:00:00.000Z",
    updatedAt: "2023-03-20T12:30:00.000Z",
  },
  {
    jobId: "b3ccf4f7-6e6d-4df9-9d7a-90acd2e09c63",
    projectId: 67890,
    externalId: "EXT-2002",
    title: "UI/UX Designer",
    description: "Design mobile-first experiences",
    status: "assigned",
    resourceType: "designer",
    rateType: "weekly",
    skills: { primary: ["Figma"], secondary: ["UX Research", "Prototyping"] },
    numPositions: 1,
    startDate: "2023-05-10",
    duration: 8,
    workload: "part-time",
    minSalary: 2000,
    maxSalary: 2500,
    hoursPerWeek: 25,
    currency: "EUR",
    createdAt: "2023-04-01T09:00:00.000Z",
    updatedAt: "2023-04-05T15:45:00.000Z",
  },
  {
    jobId: "c4dd05f8-7f7e-4ef0-b8eb-a1bde3f1ad74",
    projectId: 24680,
    externalId: "EXT-3003",
    title: "Backend Engineer",
    description: "Maintain microservices and APIs",
    status: "closed",
    resourceType: "developer",
    rateType: "hourly",
    skills: ["Node.js", "PostgreSQL"],
    numPositions: 3,
    startDate: "2023-02-01",
    duration: 16,
    workload: "full-time",
    minSalary: 70,
    maxSalary: 95,
    hoursPerWeek: 40,
    currency: "USD",
    createdAt: "2023-01-10T08:30:00.000Z",
    updatedAt: "2023-02-15T11:15:00.000Z",
  },
];

export const mockTaasJobsQueryDto: Record<string, TaasJobsReportQueryDto> = {
  minimal: {},
  byJobIds: {
    jobIds: ["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
  },
  byProjectIds: {
    projectIds: [12345],
  },
  byStatus: {
    status: ["open", "assigned"],
  },
  bySkills: {
    skills: ["React", "TypeScript"],
  },
  full: {
    jobIds: [
      "a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
      "b3ccf4f7-6e6d-4df9-9d7a-90acd2e09c63",
    ],
    projectIds: [12345, 67890],
    status: ["open", "assigned"],
    resourceType: ["developer"],
    skills: ["React", "TypeScript"],
    startDate: "2023-04-01",
    endDate: "2023-05-31",
    minPositions: 1,
    maxPositions: 3,
  },
};

export const mockTaasResourceBookingsData: TaasResourceBookingsReportResponse[] =
  [
    {
      resourceBookingId: "c2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
      jobId: "a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
      projectId: 12345,
      userId: "100001",
      userHandle: "dev_user",
      firstName: "Dev",
      lastName: "User",
      status: "placed",
      startDate: "2023-04-01",
      endDate: "2023-07-01",
      memberRate: 70,
      customerRate: 95,
      rateType: "hourly",
      billingAccountId: "80001012",
      createdAt: "2023-03-20T10:00:00.000Z",
      updatedAt: "2023-03-25T12:00:00.000Z",
    },
    {
      resourceBookingId: "d3ccf4f7-6e6d-4df9-9d7a-90acd2e09c63",
      jobId: "b3ccf4f7-6e6d-4df9-9d7a-90acd2e09c63",
      projectId: 67890,
      userId: "100002",
      userHandle: "design_guru",
      firstName: "Design",
      lastName: "Guru",
      status: "active",
      startDate: "2023-05-15",
      endDate: "2023-07-15",
      memberRate: 1800,
      customerRate: 2200,
      rateType: "weekly",
      billingAccountId: "90001012",
      createdAt: "2023-04-10T09:30:00.000Z",
      updatedAt: "2023-04-18T16:45:00.000Z",
    },
    {
      resourceBookingId: "e4dd05f8-7f7e-4ef0-b8eb-a1bde3f1ad74",
      jobId: "c4dd05f8-7f7e-4ef0-b8eb-a1bde3f1ad74",
      projectId: 24680,
      userId: "100003",
      userHandle: "api_builder",
      firstName: "Api",
      lastName: "Builder",
      status: "closed",
      startDate: "2023-02-10",
      endDate: "2023-04-10",
      memberRate: 80,
      customerRate: 110,
      rateType: "hourly",
      billingAccountId: "80001013",
      createdAt: "2023-01-15T08:15:00.000Z",
      updatedAt: "2023-02-20T14:20:00.000Z",
    },
  ];

export const mockTaasResourceBookingsQueryDto: Record<
  string,
  TaasResourceBookingsReportQueryDto
> = {
  minimal: {},
  byResourceBookingIds: {
    resourceBookingIds: ["c2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
  },
  byJobIds: {
    jobIds: ["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
  },
  byProjectIds: {
    projectIds: [12345],
  },
  byUserIds: {
    userIds: ["100001"],
  },
  byHandles: {
    handles: ["User1", "USER2"],
  },
  byStatus: {
    status: ["placed", "active"],
  },
  byBillingAccountIds: {
    billingAccountIds: ["80001012"],
  },
  full: {
    resourceBookingIds: [
      "c2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
      "d3ccf4f7-6e6d-4df9-9d7a-90acd2e09c63",
    ],
    jobIds: [
      "a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52",
      "b3ccf4f7-6e6d-4df9-9d7a-90acd2e09c63",
    ],
    projectIds: [12345, 67890],
    userIds: ["100001", "100002"],
    handles: ["dev_user", "design_guru"],
    status: ["placed", "active"],
    billingAccountIds: ["80001012", "90001012"],
    startDate: "2023-04-01",
    endDate: "2023-06-30",
    minCustomerRate: 90,
    maxCustomerRate: 2300,
  },
};

export const mockTaasMemberVerificationData: TaasMemberVerificationReportResponse[] =
  [
    {
      handle: "user1",
      userId: "100001",
      verified: true,
      verificationStatus: "Verified",
    },
    {
      handle: "user2",
      userId: "100002",
      verified: false,
      verificationStatus: "Unverified",
    },
    {
      handle: "user3",
      userId: "100003",
      verified: true,
      verificationStatus: "Verified",
    },
  ];

export const mockTaasMemberVerificationQueryDto: Record<
  string,
  TaasMemberVerificationReportQueryDto
> = {
  singleHandle: {
    handles: ["user1"],
  },
  multipleHandles: {
    handles: ["user1", "user2", "user3"],
  },
};

export const mockWesternUnionPaymentsData: WesternUnionPaymentsReportResponse[] =
  [
    {
      paymentId: "f5b6c740-2ef3-4b68-aad1-f7824e6c2c49",
      handle: "winner_one",
      grossAmount: 500,
      referenceId: "ref-001",
      description: "Design Contest",
      paymentStatus: "Entered into payment system",
      paymentDate: "2023-01-15",
    },
    {
      paymentId: "a6c7d851-3ff4-5c79-bbe2-07835f7d3d5a",
      handle: "winner_two",
      grossAmount: 750,
      referenceId: "ref-002",
      description: "Development Challenge",
      paymentStatus: "Paid",
      paymentDate: "2023-02-10",
    },
    {
      paymentId: "b7d8e962-40f5-6d8a-9cf3-18946b8e4e6b",
      handle: "winner_three",
      grossAmount: 620.5,
      referenceId: "ref-003",
      description: "Bug Bash",
      paymentStatus: "On hold",
      paymentDate: "2023-03-05",
    },
  ];

export const mockWesternUnionPaymentsQueryDto: Record<
  string,
  WesternUnionPaymentsReportQueryDto
> = {
  minimal: {},
  withPaymentStatus: {
    paymentStatus: "Paid",
  },
  withPaymentMethod: {
    paymentMethod: "Western Union",
  },
  withDates: {
    startDate: "2023-01-01",
    endDate: "2023-03-31",
  },
  withHandles: {
    handles: ["Winner_One", "WINNER_TWO"],
  },
  full: {
    paymentStatus: "Paid",
    paymentMethod: "Western Union",
    startDate: "2023-01-01",
    endDate: "2023-03-31",
    handles: ["winner_one", "winner_two"],
  },
};

export const mockSqlQuery =
  'SELECT * FROM "challenges"."Challenge" WHERE challengeId = ANY($1)';
