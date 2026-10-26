import { ConfigService } from "@nestjs/config";
import { Pool } from "pg";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { DbService } from "../../db/db.service";
import { ActiveMembersReportsService } from "./active-members-reports.service";
import {
  ActiveMemberActivityDto,
  DashboardSlug,
} from "./dashboard-reports.dto";
import { DashboardReportsService } from "./dashboard-reports.service";

jest.mock("pg", () => ({ Pool: jest.fn() }));
const range = {
  startDate: "2026-01-01T00:00:00.000Z",
  endDate: "2026-04-01T00:00:00.000Z",
};
const defaultExcludedProjectIds = ["1001120", "34654", "1001194"];

/**
 * Creates a dated activity fixture for aggregation and CSV regression tests.
 * @param id Unique event key.
 * @param memberId Member whose activity is counted.
 * @param date UTC event date.
 * @param activity Qualifying activity category.
 * @returns Activity fixture; does not throw.
 */
function event(
  id: string,
  memberId: string,
  date: string,
  activity: ActiveMemberActivityDto["activity"],
): ActiveMemberActivityDto {
  return {
    id,
    memberId,
    date,
    activity,
    handle: `member-${memberId}`,
    description: `Activity ${id}`,
  };
}

describe("ActiveMembersReportsService", () => {
  const db = { query: jest.fn() };
  const sql = { load: jest.fn((path: string) => path) };
  const pool = { query: jest.fn(), end: jest.fn() };
  let service: ActiveMembersReportsService;
  beforeEach(() => {
    jest.clearAllMocks();
    (Pool as unknown as jest.Mock).mockImplementation(() => pool);
    db.query.mockResolvedValue([]);
    pool.query.mockResolvedValue({ rows: [] });
    service = new ActiveMembersReportsService(
      db as unknown as DbService,
      sql as unknown as SqlLoaderService,
      new ConfigService({
        ENGAGEMENTS_DB_URL: "postgresql://example/engagements",
      }),
    );
  });

  it("unions all activities, deduplicates members across sources and months, and sorts newest first", async () => {
    const payment = event(
      "payment:1",
      "1",
      "2026-01-03T12:00:00.000Z",
      "payment",
    );
    const registration = event(
      "registration:1",
      "1",
      "2026-02-01T00:00:00.000Z",
      "challenge-registration",
    );
    const application = event(
      "application:1",
      "1",
      "2026-01-01T00:00:00.000Z",
      "engagement-application",
    );
    const acceptance = event(
      "acceptance:1",
      "2",
      "2026-01-20T00:00:00.000Z",
      "engagement-acceptance",
    );
    db.query.mockResolvedValue([payment, registration]);
    pool.query.mockResolvedValue({ rows: [application, acceptance] });
    await expect(service.load(range)).resolves.toEqual({
      dashboard: DashboardSlug.ActiveMembers,
      ...range,
      summary: { totalUniqueMembers: 2 },
      months: [
        {
          month: "2026-01-01",
          totalUniqueMembers: 2,
          activities: [acceptance, payment, application],
        },
        {
          month: "2026-02-01",
          totalUniqueMembers: 1,
          activities: [registration],
        },
        { month: "2026-03-01", totalUniqueMembers: 0, activities: [] },
      ],
    });
    expect(db.query).toHaveBeenCalledWith(
      "reports/dashboard/active-members.sql",
      [range.startDate, range.endDate, defaultExcludedProjectIds],
    );
    expect(pool.query).toHaveBeenCalledWith(
      "reports/dashboard/active-members-engagements.sql",
      [range.startDate, range.endDate, defaultExcludedProjectIds],
    );
  });

  it.each([
    ['[" 1 ", 2, ""]', ["1", "2"]],
    ["3, 4,,", ["3", "4"]],
    ["", []],
    ["[]", []],
  ])(
    "passes configured excluded project IDs %p to both activity queries",
    async (configured, expected) => {
      const configuredService = new ActiveMembersReportsService(
        db as unknown as DbService,
        sql as unknown as SqlLoaderService,
        new ConfigService({
          ENGAGEMENTS_DB_URL: "postgresql://example/engagements",
          REPORTS_ACTIVE_MEMBERS_EXCLUDED_PROJECT_IDS: configured,
        }),
      );
      await configuredService.load(range);
      expect(db.query).toHaveBeenCalledWith(expect.any(String), [
        range.startDate,
        range.endDate,
        expected,
      ]);
      expect(pool.query).toHaveBeenCalledWith(expect.any(String), [
        range.startDate,
        range.endDate,
        expected,
      ]);
    },
  );

  it("zero-fills partial-month ranges and reuses and closes the engagements pool", async () => {
    const query = {
      startDate: "2026-01-31T23:59:59.000Z",
      endDate: "2026-02-01T00:00:00.000Z",
    };
    const result = await service.load(query);
    await service.load(query);
    expect(result.months).toEqual([
      { month: "2026-01-01", totalUniqueMembers: 0, activities: [] },
    ]);
    expect(result.summary.totalUniqueMembers).toBe(0);
    expect(Pool).toHaveBeenCalledTimes(1);
    await service.onModuleDestroy();
    expect(pool.end).toHaveBeenCalledTimes(1);
  });

  it("fails explicitly instead of returning incomplete totals if engagements are unavailable", async () => {
    pool.query.mockRejectedValueOnce(new Error("database unavailable"));
    await expect(service.load(range)).rejects.toThrow("database unavailable");
    const unconfigured = new ActiveMembersReportsService(
      db as unknown as DbService,
      sql as unknown as SqlLoaderService,
      new ConfigService(),
    );
    await expect(unconfigured.load(range)).rejects.toThrow(
      "ENGAGEMENTS_DB_URL",
    );
  });

  it("routes the new dashboard and exports monthly totals and member details newest first", async () => {
    const activity = event(
      "payment:1",
      "1",
      "2026-01-03T12:00:00.000Z",
      "payment",
    );
    db.query.mockResolvedValue([activity]);
    const dashboards = new DashboardReportsService(
      db as unknown as DbService,
      sql as unknown as SqlLoaderService,
      service,
    );
    const response = await dashboards.getDashboard(
      DashboardSlug.ActiveMembers,
      range,
    );
    expect(response.dashboard).toBe(DashboardSlug.ActiveMembers);
    await expect(
      dashboards.exportDashboard(DashboardSlug.ActiveMembers, range),
    ).resolves.toEqual([
      {
        dashboard: DashboardSlug.ActiveMembers,
        month: "2026-03-01",
        totalUniqueMembers: 0,
      },
      {
        dashboard: DashboardSlug.ActiveMembers,
        month: "2026-02-01",
        totalUniqueMembers: 0,
      },
      {
        dashboard: DashboardSlug.ActiveMembers,
        month: "2026-01-01",
        totalUniqueMembers: 1,
        memberId: "1",
        handle: "member-1",
        activity: "payment",
        date: activity.date,
        description: activity.description,
      },
    ]);
  });
});
