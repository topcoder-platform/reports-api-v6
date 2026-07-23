import { Test, TestingModule } from "@nestjs/testing";
import { CsvSerializer } from "../../common/csv/csv-serializer";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { DbModule } from "../../db/db.module";
import { DbService } from "../../db/db.service";
import { DashboardReportsController } from "./dashboard-reports.controller";
import { DashboardSlug } from "./dashboard-reports.dto";
import { DashboardReportsModule } from "./dashboard-reports.module";
import { DashboardReportsService } from "./dashboard-reports.service";
import { DashboardReportsGuard } from "./guards/dashboard-reports.guard";

describe("DashboardReportsModule", () => {
  let moduleRef: TestingModule;

  const db = {
    query: jest.fn(),
  };
  const sql = {
    load: jest.fn(),
  };

  beforeEach(async () => {
    db.query.mockReset().mockResolvedValue([]);
    sql.load.mockReset().mockReturnValue("SELECT 1");

    moduleRef = await Test.createTestingModule({
      imports: [DbModule, DashboardReportsModule],
    })
      .overrideProvider(DbService)
      .useValue(db)
      .overrideProvider(SqlLoaderService)
      .useValue(sql)
      .compile();
  });

  it("wires the controller, service, guard, and CSV serializer", () => {
    expect(moduleRef.get(DashboardReportsController)).toBeInstanceOf(
      DashboardReportsController,
    );
    expect(moduleRef.get(DashboardReportsService)).toBeInstanceOf(
      DashboardReportsService,
    );
    expect(moduleRef.get(DashboardReportsGuard)).toBeInstanceOf(
      DashboardReportsGuard,
    );
    expect(moduleRef.get(CsvSerializer)).toBeInstanceOf(CsvSerializer);
  });

  it("injects the shared database and SQL loader into the report service", async () => {
    const service = moduleRef.get(DashboardReportsService);

    await service.getDashboard(DashboardSlug.NewSignups, {
      startDate: "2026-01-01",
      endDate: "2026-02-01",
    });

    expect(sql.load).toHaveBeenCalledWith("reports/dashboard/new-signups.sql");
    expect(db.query).toHaveBeenCalledWith("SELECT 1", [
      "2026-01-01T00:00:00.000Z",
      "2026-02-01T00:00:00.000Z",
    ]);
  });
});
