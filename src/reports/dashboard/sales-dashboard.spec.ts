import {
  BadGatewayException,
  BadRequestException,
  ValidationPipe,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { DbService } from "../../db/db.service";
import { SalesReportDto } from "../sales/sales-reports.dto";
import { SalesReportsService } from "../sales/sales-reports.service";
import {
  SalesDashboardQueryDto,
  SalesDashboardSection,
} from "./sales-dashboard.dto";
import { pipelineCharts } from "./sales-dashboard.pipeline";
import { SalesDashboardService } from "./sales-dashboard.service";

const range = {
  startDate: "2026-08-01T00:00:00Z",
  endDate: "2026-11-01T00:00:00Z",
};

/** @returns A complete snapshot containing close/created dates, raw/converted amounts and stage values. Does not throw. */
function pipeline(): SalesReportDto {
  return {
    allData: true,
    columns: [
      "Amount",
      "Amount (converted)",
      "Expected Revenue",
      "Probability",
      "Stage",
      "Close Date",
      "Created Date",
    ].map((label, i) => ({ id: String(i), label, dataType: "string" })),
    rows: [
      [900, 100, null, 50, "Won - Closed", "2026-08-01", "2026-09-01"],
      [900, 300, 210, 10, "Won - SOW Signed", "2026-09-15", "2026-08-15"],
      [900, 999, 900, 90, "Proposal", "2026-11-01", "2026-11-01"],
    ].map((cells, i) => ({
      id: String(i),
      cells: cells.map((value) => ({
        value,
        label: value == null ? "" : String(value),
      })),
    })),
  } as SalesReportDto;
}

describe("Monthly sales dashboards", () => {
  it("uses every row, converted amounts, weighted fallback, exact won stages and half-open month ranges", () => {
    const { charts } = pipelineCharts(pipeline(), range, range, "close");
    expect(charts[0].months.map((m) => m.values.amount)).toEqual([100, 300, 0]);
    expect(charts[1].months.map((m) => m.values.amount)).toEqual([100, 0, 0]);
    expect(charts[2].months.map((m) => m.values.amount)).toEqual([50, 210, 0]);
    expect(
      charts[3].months.map((m) =>
        Object.values(m.values).reduce((a: number, b) => a + (b ?? 0), 0),
      ),
    ).toEqual([100, 300, 0]);
  });

  it("switches the pipeline date field and preserves empty months", () => {
    const { charts } = pipelineCharts(pipeline(), range, range, "created");
    expect(charts[0].months.map((m) => m.values.amount)).toEqual([300, 100, 0]);
  });

  it("labels incomplete data and missing dates/expected revenue rather than silently fabricating it", () => {
    const report = pipeline();
    report.allData = false;
    report.rows[0].cells[5].value = null;
    report.rows[1].cells[2].value = null;
    report.rows[1].cells[3].value = null;
    const { notices } = pipelineCharts(report, range, range, "close");
    expect(notices.join(" ")).toMatch(
      /incomplete.*no usable date.*neither Expected Revenue/,
    );
    report.columns = [];
    expect(() => pipelineCharts(report, range, range, "close")).toThrow(
      BadGatewayException,
    );
  });

  it("validates portal and date basis values at the API boundary", async () => {
    const pipe = new ValidationPipe({ transform: true, whitelist: true });
    await expect(
      pipe.transform(
        { portal: "other" },
        { type: "query", metatype: SalesDashboardQueryDto },
      ),
    ).rejects.toThrow(BadRequestException);
    await expect(
      pipe.transform(
        { dateBasis: "other" },
        { type: "query", metatype: SalesDashboardQueryDto },
      ),
    ).rejects.toThrow(BadRequestException);
  });

  const query = jest.fn();
  const getDashboardSnapshot = jest.fn();
  /** @param settings Optional server configuration. @returns Isolated service using mocked database and Salesforce transport. Does not throw. */
  function service(
    settings: Record<string, string> = {},
  ): SalesDashboardService {
    return new SalesDashboardService(
      { query } as unknown as DbService,
      new SqlLoaderService(),
      { getDashboardSnapshot } as unknown as SalesReportsService,
      new ConfigService(settings),
    );
  }
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it("keeps revenue pending without guessing a report and bounds expensive monthly queries", async () => {
    expect(await service().load(SalesDashboardSection.Revenue, range)).toEqual({
      charts: [],
      notices: [expect.stringContaining("pending")],
    });
    expect(getDashboardSnapshot).not.toHaveBeenCalled();
    await expect(
      service().load(SalesDashboardSection.Payments, {
        startDate: "2000-01-01",
        endDate: "2026-01-01",
      }),
    ).rejects.toThrow(BadRequestException);
    expect(query).not.toHaveBeenCalled();
  });

  it("uses explicit SFDC revenue mappings and reports partial data", async () => {
    getDashboardSnapshot.mockResolvedValue({
      ...pipeline(),
      allData: false,
      reportName: "Recognized revenue",
      columns: [
        { id: "date", dataType: "date" },
        { id: "recognized", dataType: "currency" },
      ],
      rows: [{ cells: [{ value: "2026-09-01" }, { value: 123.45 }] }],
    });
    const result = await service({
      SALESFORCE_REVENUE_REPORT_ID: "report",
      SALESFORCE_REVENUE_DATE_COLUMN: "date",
      SALESFORCE_REVENUE_AMOUNT_COLUMN: "recognized",
    }).load(SalesDashboardSection.Revenue, range);
    expect(getDashboardSnapshot).toHaveBeenCalledWith("revenue");
    expect(result.charts[0].months.map((m) => m.values.revenue)).toEqual([
      0, 123.45, 0,
    ]);
    expect(result.notices[0]).toMatch(/incomplete/);
  });

  it("passes Sales scope to SQL, omits TaaS series, and ranks customers before Other", async () => {
    query.mockResolvedValue([
      {
        month: "2026-09-01",
        kind: "type",
        payment_type: "challenge",
        amount: "70",
        members: "2",
      },
      ...Array.from({ length: 6 }, (_, i) => ({
        month: "2026-09-01",
        kind: "customer",
        customer_id: String(i),
        customer_label: `Client ${i}`,
        amount: String(i + 1),
      })),
    ]);
    const result = await service().load(SalesDashboardSection.Payments, {
      ...range,
      portal: "sales",
    });
    expect(query.mock.calls[0][1][2]).toBe(true);
    expect(result.charts[0].series.map((s) => s.key)).not.toContain("taas");
    expect(result.charts[1].months[1].values.challenge).toBe(2);
    expect(result.charts[2].series.map((s) => s.label)).toEqual([
      "Client 5",
      "Client 4",
      "Client 3",
      "Client 2",
      "Client 1",
      "Other Customers",
    ]);
    expect(result.charts[2].months[1].values.other).toBe(1);
    const reports = await service().load(SalesDashboardSection.Payments, range);
    expect(query.mock.calls[1][1][2]).toBe(false);
    expect(reports.charts[0].series[0].key).toBe("taas");
  });

  it("preserves unknown markup and exposes excluded unknown-payment counts", async () => {
    query.mockResolvedValue([
      { month: "2026-09-01", markup: "25", missing: "2" },
    ]);
    const result = await service().load(
      SalesDashboardSection.GrossMargin,
      range,
    );
    expect(result.charts[0].months.map((m) => m.values.markup)).toEqual([
      null,
      25,
      null,
    ]);
    expect(result.notices[0]).toMatch(/^2 payments/);
  });
});
