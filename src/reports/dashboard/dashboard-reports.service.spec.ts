import { BadRequestException } from "@nestjs/common";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { DbService } from "../../db/db.service";
import {
  ChallengeParticipationDashboardDto,
  DashboardSlug,
  MemberPaymentByCustomerDashboardDto,
  MemberPaymentByMonthDashboardDto,
  MembersPaidDashboardDto,
  NewSignupsDashboardDto,
} from "./dashboard-reports.dto";
import {
  DashboardReportsService,
  resolveDashboardDateRange,
} from "./dashboard-reports.service";

const rangeQuery = {
  startDate: "2026-02-01T00:00:00.000Z",
  endDate: "2026-04-01T00:00:00.000Z",
};

const newSignupsRows = [
  {
    month: "2026-02-01",
    activated: "10",
    not_activated: "2",
    total_signups: "100",
    activated_members: "75",
    not_activated_members: "25",
    activation_rate: "75.0",
    peak_month: "2025-01-01",
    peak_month_signups: "20",
  },
  {
    month: "2026-03-01",
    activated: "8",
    not_activated: "3",
    total_signups: "100",
    activated_members: "75",
    not_activated_members: "25",
    activation_rate: "75.0",
    peak_month: "2025-01-01",
    peak_month_signups: "20",
  },
];

const membersPaidRows = [
  {
    month: "2026-02-01",
    taas: "3",
    task: "4",
    challenge: "5",
    engagement: "2",
    total_unique_members: "40",
    taas_unique_members: "8",
    task_unique_members: "13",
    challenge_unique_members: "24",
    engagement_unique_members: "7",
    peak_month: "2025-11-01",
    peak_month_unique_members: "15",
  },
];

const challengeParticipationRows = [
  {
    month: "2026-02-01",
    registrants: "12",
    submitters: "9",
    total_unique_registrants: "120",
    total_unique_submitters: "90",
    submission_rate: "75.0",
    peak_month: "2025-10-01",
    peak_month_registrants: "18",
  },
];

const memberPaymentByMonthRows = [
  {
    month: "2026-02-01",
    taas: "1250.50",
    task: "2400",
    challenge: "3750.25",
    engagement: "900",
  },
  {
    month: "2026-03-01",
    taas: "1500",
    task: "2100.75",
    challenge: "4200",
    engagement: "1100",
  },
];

const memberPaymentByCustomerRows = [
  {
    month: "2026-02-01",
    series_key: "customer-client-a",
    customer_id: "client-a",
    customer_label: "Customer A",
    amount: "5000.25",
  },
  {
    month: "2026-02-01",
    series_key: "other-customers",
    customer_id: null,
    customer_label: "Other Customers",
    amount: "1200",
  },
  {
    month: "2026-03-01",
    series_key: "customer-client-a",
    customer_id: "client-a",
    customer_label: "Customer A",
    amount: "6200",
  },
];

describe("resolveDashboardDateRange", () => {
  it("defaults to the latest six UTC calendar months", () => {
    expect(
      resolveDashboardDateRange({}, new Date("2026-07-23T16:45:00.000Z")),
    ).toEqual({
      startDate: "2026-02-01T00:00:00.000Z",
      endDate: "2026-08-01T00:00:00.000Z",
    });
  });

  it("normalizes explicit date-only bounds to ISO timestamps", () => {
    expect(
      resolveDashboardDateRange({
        startDate: "2026-01-01",
        endDate: "2026-05-01",
      }),
    ).toEqual({
      startDate: "2026-01-01T00:00:00.000Z",
      endDate: "2026-05-01T00:00:00.000Z",
    });
  });

  it("derives a missing bound by six calendar months with day clamping", () => {
    expect(
      resolveDashboardDateRange({
        startDate: "2026-08-31T12:30:00.000Z",
      }),
    ).toEqual({
      startDate: "2026-08-31T12:30:00.000Z",
      endDate: "2027-02-28T12:30:00.000Z",
    });

    expect(
      resolveDashboardDateRange({
        endDate: "2026-08-31T12:30:00.000Z",
      }),
    ).toEqual({
      startDate: "2026-02-28T12:30:00.000Z",
      endDate: "2026-08-31T12:30:00.000Z",
    });
  });

  it("rejects invalid and non-increasing ranges", () => {
    expect(() =>
      resolveDashboardDateRange({ startDate: "not-a-date" }),
    ).toThrow(BadRequestException);
    expect(() =>
      resolveDashboardDateRange({
        startDate: "2026-04-01",
        endDate: "2026-04-01",
      }),
    ).toThrow("endDate must be later than startDate.");
  });
});

describe("DashboardReportsService", () => {
  let service: DashboardReportsService;
  let db: { query: jest.Mock };
  let sql: { load: jest.Mock };

  beforeEach(() => {
    sql = {
      load: jest.fn((path: string) => path),
    };
    db = {
      query: jest.fn((query: string) => {
        switch (query) {
          case "reports/dashboard/new-signups.sql":
            return Promise.resolve(newSignupsRows);
          case "reports/dashboard/members-paid.sql":
            return Promise.resolve(membersPaidRows);
          case "reports/dashboard/challenge-participation.sql":
            return Promise.resolve(challengeParticipationRows);
          case "reports/dashboard/member-payment-by-month.sql":
            return Promise.resolve(memberPaymentByMonthRows);
          case "reports/dashboard/member-payment-by-customer.sql":
            return Promise.resolve(memberPaymentByCustomerRows);
          default:
            return Promise.resolve([]);
        }
      }),
    };
    service = new DashboardReportsService(
      db as unknown as DbService,
      sql as unknown as SqlLoaderService,
    );
  });

  it("loads and maps all dashboard responses with one shared range", async () => {
    await expect(service.getAllDashboards(rangeQuery)).resolves.toEqual({
      newSignups: {
        dashboard: DashboardSlug.NewSignups,
        ...rangeQuery,
        months: [
          {
            month: "2026-02-01",
            activated: 10,
            notActivated: 2,
          },
          {
            month: "2026-03-01",
            activated: 8,
            notActivated: 3,
          },
        ],
        summary: {
          totalSignups: 100,
          activatedMembers: 75,
          notActivatedMembers: 25,
          activationRate: 75,
          peakMonth: "2025-01-01",
          peakMonthSignups: 20,
        },
      },
      membersPaid: {
        dashboard: DashboardSlug.MembersPaid,
        ...rangeQuery,
        months: [
          {
            month: "2026-02-01",
            taas: 3,
            task: 4,
            challenge: 5,
            engagement: 2,
          },
        ],
        summary: {
          totalUniqueMembers: 40,
          taasUniqueMembers: 8,
          taskUniqueMembers: 13,
          challengeUniqueMembers: 24,
          engagementUniqueMembers: 7,
          peakMonth: "2025-11-01",
          peakMonthUniqueMembers: 15,
        },
      },
      challengeParticipation: {
        dashboard: DashboardSlug.ChallengeParticipation,
        ...rangeQuery,
        months: [
          {
            month: "2026-02-01",
            registrants: 12,
            submitters: 9,
          },
        ],
        summary: {
          totalUniqueRegistrants: 120,
          totalUniqueSubmitters: 90,
          submissionRate: 75,
          peakMonth: "2025-10-01",
          peakMonthRegistrants: 18,
        },
      },
      memberPaymentByMonth: {
        dashboard: DashboardSlug.MemberPaymentByMonth,
        ...rangeQuery,
        months: [
          {
            month: "2026-02-01",
            taas: 1250.5,
            task: 2400,
            challenge: 3750.25,
            engagement: 900,
          },
          {
            month: "2026-03-01",
            taas: 1500,
            task: 2100.75,
            challenge: 4200,
            engagement: 1100,
          },
        ],
      },
      memberPaymentByCustomer: {
        dashboard: DashboardSlug.MemberPaymentByCustomer,
        ...rangeQuery,
        series: [
          {
            key: "customer-client-a",
            label: "Customer A",
            customerId: "client-a",
          },
          {
            key: "other-customers",
            label: "Other Customers",
            customerId: null,
          },
        ],
        months: [
          {
            month: "2026-02-01",
            values: {
              "customer-client-a": 5000.25,
              "other-customers": 1200,
            },
          },
          {
            month: "2026-03-01",
            values: {
              "customer-client-a": 6200,
              "other-customers": 0,
            },
          },
        ],
      },
    });

    expect(sql.load.mock.calls).toEqual([
      ["reports/dashboard/new-signups.sql"],
      ["reports/dashboard/members-paid.sql"],
      ["reports/dashboard/challenge-participation.sql"],
      ["reports/dashboard/member-payment-by-month.sql"],
      ["reports/dashboard/member-payment-by-customer.sql"],
    ]);
    expect(db.query).toHaveBeenCalledTimes(5);
    expect(db.query).toHaveBeenCalledWith("reports/dashboard/new-signups.sql", [
      rangeQuery.startDate,
      rangeQuery.endDate,
    ]);
  });

  it("loads only the requested detail dashboard", async () => {
    const result = await service.getDashboard(
      DashboardSlug.MemberPaymentByCustomer,
      rangeQuery,
    );

    expect(result.dashboard).toBe(DashboardSlug.MemberPaymentByCustomer);
    expect(sql.load).toHaveBeenCalledTimes(1);
    expect(sql.load).toHaveBeenCalledWith(
      "reports/dashboard/member-payment-by-customer.sql",
    );
  });

  it("rejects an unsupported dashboard discriminator", async () => {
    await expect(
      service.getDashboard("unknown" as DashboardSlug, rangeQuery),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it("returns a safe empty summary when a query returns no rows", async () => {
    db.query.mockResolvedValueOnce([]);

    await expect(
      service.getDashboard(DashboardSlug.NewSignups, rangeQuery),
    ).resolves.toEqual({
      dashboard: DashboardSlug.NewSignups,
      ...rangeQuery,
      months: [],
      summary: {
        totalSignups: 0,
        activatedMembers: 0,
        notActivatedMembers: 0,
        activationRate: 0,
        peakMonth: null,
        peakMonthSignups: 0,
      },
    });
  });

  it("flattens all dashboard month data for CSV serialization", async () => {
    const dashboards = {
      newSignups: {
        dashboard: DashboardSlug.NewSignups,
        ...rangeQuery,
        months: [{ month: "2026-02-01", activated: 10, notActivated: 2 }],
        summary: {
          totalSignups: 12,
          activatedMembers: 10,
          notActivatedMembers: 2,
          activationRate: 83.3,
          peakMonth: "2026-02-01",
          peakMonthSignups: 12,
        },
      } satisfies NewSignupsDashboardDto,
      membersPaid: {
        dashboard: DashboardSlug.MembersPaid,
        ...rangeQuery,
        months: [
          {
            month: "2026-02-01",
            taas: 3,
            task: 4,
            challenge: 5,
            engagement: 2,
          },
        ],
        summary: {
          totalUniqueMembers: 10,
          taasUniqueMembers: 3,
          taskUniqueMembers: 4,
          challengeUniqueMembers: 5,
          engagementUniqueMembers: 2,
          peakMonth: "2026-02-01",
          peakMonthUniqueMembers: 10,
        },
      } satisfies MembersPaidDashboardDto,
      challengeParticipation: {
        dashboard: DashboardSlug.ChallengeParticipation,
        ...rangeQuery,
        months: [{ month: "2026-02-01", registrants: 12, submitters: 9 }],
        summary: {
          totalUniqueRegistrants: 12,
          totalUniqueSubmitters: 9,
          submissionRate: 75,
          peakMonth: "2026-02-01",
          peakMonthRegistrants: 12,
        },
      } satisfies ChallengeParticipationDashboardDto,
      memberPaymentByMonth: {
        dashboard: DashboardSlug.MemberPaymentByMonth,
        ...rangeQuery,
        months: [
          {
            month: "2026-02-01",
            taas: 1000,
            task: 2000,
            challenge: 3000,
            engagement: 4000,
          },
        ],
      } satisfies MemberPaymentByMonthDashboardDto,
      memberPaymentByCustomer: {
        dashboard: DashboardSlug.MemberPaymentByCustomer,
        ...rangeQuery,
        series: [
          {
            key: "customer-client-a",
            label: "Customer A",
            customerId: "client-a",
          },
          {
            key: "other-customers",
            label: "Other Customers",
            customerId: null,
          },
        ],
        months: [
          {
            month: "2026-02-01",
            values: {
              "customer-client-a": 6500,
              "other-customers": 3500,
            },
          },
        ],
      } satisfies MemberPaymentByCustomerDashboardDto,
    };
    jest.spyOn(service, "getAllDashboards").mockResolvedValue(dashboards);

    await expect(service.exportAllDashboards(rangeQuery)).resolves.toEqual([
      {
        dashboard: DashboardSlug.NewSignups,
        month: "2026-02-01",
        activated: 10,
        notActivated: 2,
      },
      {
        dashboard: DashboardSlug.MembersPaid,
        month: "2026-02-01",
        taas: 3,
        task: 4,
        challenge: 5,
        engagement: 2,
      },
      {
        dashboard: DashboardSlug.ChallengeParticipation,
        month: "2026-02-01",
        registrants: 12,
        submitters: 9,
      },
      {
        dashboard: DashboardSlug.MemberPaymentByMonth,
        month: "2026-02-01",
        taas: 1000,
        task: 2000,
        challenge: 3000,
        engagement: 4000,
      },
      {
        dashboard: DashboardSlug.MemberPaymentByCustomer,
        month: "2026-02-01",
        customer: "Customer A",
        amount: 6500,
      },
      {
        dashboard: DashboardSlug.MemberPaymentByCustomer,
        month: "2026-02-01",
        customer: "Other Customers",
        amount: 3500,
      },
    ]);
  });
});
