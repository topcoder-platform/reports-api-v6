import { CsvSerializer } from "../../common/csv/csv-serializer";
import {
  DashboardExportRowDto,
  DashboardSlug,
  MemberPaymentByCustomerDashboardDto,
  NewSignupsDashboardDto,
} from "./dashboard-reports.dto";
import { DashboardReportsController } from "./dashboard-reports.controller";
import { DashboardReportsService } from "./dashboard-reports.service";

const query = {
  startDate: "2026-02-01T00:00:00.000Z",
  endDate: "2026-04-01T00:00:00.000Z",
};

const newSignupsDashboard: NewSignupsDashboardDto = {
  dashboard: DashboardSlug.NewSignups,
  ...query,
  months: [{ month: "2026-02-01", activated: 10, notActivated: 2 }],
  summary: {
    totalSignups: 12,
    activatedMembers: 10,
    notActivatedMembers: 2,
    activationRate: 83.3,
    peakMonth: "2026-02-01",
    peakMonthSignups: 12,
  },
};

const memberPaymentByCustomerDashboard: MemberPaymentByCustomerDashboardDto = {
  dashboard: DashboardSlug.MemberPaymentByCustomer,
  ...query,
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
        "customer-client-a": 5000,
        "other-customers": 1000,
      },
    },
  ],
};

describe("DashboardReportsController", () => {
  let controller: DashboardReportsController;
  let service: {
    getAllDashboards: jest.Mock;
    getDashboard: jest.Mock;
    exportAllDashboards: jest.Mock;
    exportDashboard: jest.Mock;
  };

  beforeEach(() => {
    service = {
      getAllDashboards: jest.fn(),
      getDashboard: jest.fn(),
      exportAllDashboards: jest.fn(),
      exportDashboard: jest.fn(),
    };
    controller = new DashboardReportsController(
      service as unknown as DashboardReportsService,
      new CsvSerializer(),
    );
  });

  it("delegates the aggregate landing response", async () => {
    const response = {
      newSignups: newSignupsDashboard,
      membersPaid: {},
      challengeParticipation: {},
      memberPaymentByMonth: {},
      memberPaymentByCustomer: memberPaymentByCustomerDashboard,
    };
    service.getAllDashboards.mockResolvedValue(response);

    await expect(controller.getAllDashboards(query)).resolves.toBe(response);
    expect(service.getAllDashboards).toHaveBeenCalledWith(query);
  });

  it("delegates a selected detail dashboard", async () => {
    service.getDashboard.mockResolvedValue(memberPaymentByCustomerDashboard);

    await expect(
      controller.getDashboard(DashboardSlug.MemberPaymentByCustomer, query),
    ).resolves.toBe(memberPaymentByCustomerDashboard);
    expect(service.getDashboard).toHaveBeenCalledWith(
      DashboardSlug.MemberPaymentByCustomer,
      query,
    );
  });

  it("serializes all-dashboard export rows as one flat CSV", async () => {
    const rows: DashboardExportRowDto[] = [
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
        amount: 5000,
      },
    ];
    service.exportAllDashboards.mockResolvedValue(rows);

    await expect(controller.exportAllDashboards(query)).resolves.toBe(
      [
        "dashboard,month,activated,notActivated,taas,task,challenge,engagement,customer,amount",
        "new-signups,2026-02-01,10,2,,,,,,",
        "members-paid,2026-02-01,,,3,4,5,2,,",
        "member-payment-by-month,2026-02-01,,,1000,2000,3000,4000,,",
        "member-payment-by-customer,2026-02-01,,,,,,,Customer A,5000",
      ].join("\n"),
    );
    expect(service.exportAllDashboards).toHaveBeenCalledWith(query);
  });

  it("serializes one selected dashboard as CSV", async () => {
    service.exportDashboard.mockResolvedValue([
      {
        dashboard: DashboardSlug.MemberPaymentByCustomer,
        month: "2026-02-01",
        customer: "Customer A",
        amount: 5000,
      },
      {
        dashboard: DashboardSlug.MemberPaymentByCustomer,
        month: "2026-02-01",
        customer: "Other Customers",
        amount: 1000,
      },
    ]);

    await expect(
      controller.exportDashboard(DashboardSlug.MemberPaymentByCustomer, query),
    ).resolves.toBe(
      "dashboard,month,customer,amount\n" +
        "member-payment-by-customer,2026-02-01,Customer A,5000\n" +
        "member-payment-by-customer,2026-02-01,Other Customers,1000",
    );
    expect(service.exportDashboard).toHaveBeenCalledWith(
      DashboardSlug.MemberPaymentByCustomer,
      query,
    );
  });
});
