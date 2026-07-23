import { CsvSerializer } from "../../common/csv/csv-serializer";
import {
  DashboardExportRowDto,
  DashboardSlug,
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
    };
    service.getAllDashboards.mockResolvedValue(response);

    await expect(controller.getAllDashboards(query)).resolves.toBe(response);
    expect(service.getAllDashboards).toHaveBeenCalledWith(query);
  });

  it("delegates a selected detail dashboard", async () => {
    service.getDashboard.mockResolvedValue(newSignupsDashboard);

    await expect(
      controller.getDashboard(DashboardSlug.NewSignups, query),
    ).resolves.toBe(newSignupsDashboard);
    expect(service.getDashboard).toHaveBeenCalledWith(
      DashboardSlug.NewSignups,
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
    ];
    service.exportAllDashboards.mockResolvedValue(rows);

    await expect(controller.exportAllDashboards(query)).resolves.toBe(
      [
        "dashboard,month,activated,notActivated,taas,task,challenge,engagement",
        "new-signups,2026-02-01,10,2,,,,",
        "members-paid,2026-02-01,,,3,4,5,2",
      ].join("\n"),
    );
    expect(service.exportAllDashboards).toHaveBeenCalledWith(query);
  });

  it("serializes one selected dashboard as CSV", async () => {
    service.exportDashboard.mockResolvedValue([
      {
        dashboard: DashboardSlug.ChallengeParticipation,
        month: "2026-02-01",
        registrants: 12,
        submitters: 9,
      },
    ]);

    await expect(
      controller.exportDashboard(DashboardSlug.ChallengeParticipation, query),
    ).resolves.toBe(
      "dashboard,month,registrants,submitters\n" +
        "challenge-participation,2026-02-01,12,9",
    );
    expect(service.exportDashboard).toHaveBeenCalledWith(
      DashboardSlug.ChallengeParticipation,
      query,
    );
  });
});
