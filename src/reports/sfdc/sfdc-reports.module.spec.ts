import { Test, TestingModule } from "@nestjs/testing";
import { CsvResponseInterceptor } from "src/common/interceptors/csv-response.interceptor";
import { CsvSerializer } from "src/common/csv/csv-serializer";
import { SqlLoaderService } from "src/common/sql-loader.service";
import { DbModule } from "../../db/db.module";
import { DbService } from "../../db/db.service";
import { SfdcReportsController } from "./sfdc-reports.controller";
import { SfdcReportsModule } from "./sfdc-reports.module";
import { SfdcReportsService } from "./sfdc-reports.service";

describe("SfdcReportsModule", () => {
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
    mockDbService.query.mockResolvedValue([]);
    mockSqlLoaderService.load.mockReturnValue("SELECT 1");

    moduleRef = await Test.createTestingModule({
      imports: [DbModule, SfdcReportsModule],
    })
      .overrideProvider(DbService)
      .useValue(mockDbService)
      .overrideProvider(SqlLoaderService)
      .useValue(mockSqlLoaderService)
      .compile();
  });

  it("wires up the controller and service", () => {
    expect(
      moduleRef.get<SfdcReportsController>(SfdcReportsController),
    ).toBeInstanceOf(SfdcReportsController);
    expect(
      moduleRef.get<SfdcReportsService>(SfdcReportsService),
    ).toBeInstanceOf(SfdcReportsService);
    expect(moduleRef.get<SqlLoaderService>(SqlLoaderService)).toBe(
      mockSqlLoaderService,
    );
    expect(moduleRef.get<CsvSerializer>(CsvSerializer)).toBeInstanceOf(
      CsvSerializer,
    );
    expect(
      moduleRef.get<CsvResponseInterceptor>(CsvResponseInterceptor),
    ).toBeInstanceOf(CsvResponseInterceptor);
  });

  it("injects mocked dependencies into the service", async () => {
    const service = moduleRef.get<SfdcReportsService>(SfdcReportsService);

    await service.getChallengesReport({ billingAccountIds: ["80001012"] });

    expect(mockSqlLoaderService.load).toHaveBeenCalledWith(
      "reports/sfdc/challenges.sql",
    );
    expect(mockDbService.query).toHaveBeenCalled();
  });

  it("injects mocked dependencies for payments report", async () => {
    const service = moduleRef.get<SfdcReportsService>(SfdcReportsService);

    await service.getPaymentsReport({ billingAccountIds: ["80001012"] });

    expect(mockSqlLoaderService.load).toHaveBeenCalledWith(
      "reports/sfdc/payments.sql",
    );
    expect(mockDbService.query).toHaveBeenCalled();
  });
});
