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
import {
  categoryColumn,
  CATEGORY_LABELS,
  offeringLabel,
} from "./sales-dashboard.categories";
import { pipelineCharts } from "./sales-dashboard.pipeline";
import { SalesDashboardService } from "./sales-dashboard.service";

const talentQuery = jest.fn();
jest.mock("pg", () => ({
  Pool: jest
    .fn()
    .mockImplementation(() => ({
      query: (...args: unknown[]) => talentQuery(...args),
    })),
}));

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
  it("separates won bookings from open pipeline and expected bookings, preferring converted amounts", () => {
    const report = pipeline();
    report.rows.push({
      ...report.rows[2],
      cells: report.rows[2].cells.map((c) => ({ ...c })),
    });
    report.rows[2].cells[5].value = "2026-10-01";
    report.rows[2].cells[2].value = null;
    const { charts } = pipelineCharts(report, range, range, "close");
    expect(charts.map((c) => c.id)).toEqual([
      "closed-won",
      "expected-revenue",
      "pipeline-stage",
    ]);
    expect(charts[0].months.map((m) => m.values.amount)).toEqual([100, 300, 0]);
    expect(charts[1].months.map((m) => m.values.amount)).toEqual([0, 0, 899.1]);
    expect(charts[2].series.map((s) => s.label)).toEqual(["Proposal"]);
    expect(
      charts[2].months.map((m) =>
        Object.values(m.values).reduce((a: number, b) => a + (b ?? 0), 0),
      ),
    ).toEqual([0, 0, 999]);
    expect(
      pipelineCharts(report, range, range, "created").charts[0].months.map(
        (m) => m.values.amount,
      ),
    ).toEqual([300, 100, 0]);
  });

  it("builds all won-booking breakdowns from category metadata, preserving blanks and date grouping", () => {
    const report = pipeline();
    const labels = [
      "Engagement Offering Type",
      "Deal Category",
      "New Customer or Follow-on Business?",
    ];
    report.columns.push(
      ...labels.map((label, i) => ({
        id: `category-${i}`,
        label,
        dataType: "string",
      })),
    );
    const values = [
      ["AI Training", "Wipro Direct", "New Customer"],
      ["", "Topcoder Direct", "Follow-on"],
      ["Not won", "Not won", "Not won"],
    ];
    report.rows.forEach((row, i) =>
      row.cells.push(...values[i].map((value) => ({ value, label: value }))),
    );
    const { charts, notices } = pipelineCharts(report, range, range, "close");
    expect(notices).toEqual([]);
    expect(charts.slice(3).map((c) => c.id)).toEqual([
      "won-offering",
      "won-deal-category",
      "won-customer-type",
    ]);
    charts.slice(3).forEach((chart) => {
      expect(chart.series.some((series) => series.label === "Not won")).toBe(
        false,
      );
      expect(
        chart.months.map((m) =>
          Object.values(m.values).reduce((a: number, b) => a + (b ?? 0), 0),
        ),
      ).toEqual([100, 300, 0]);
    });
    expect(charts[3].series.map((c) => c.label)).toEqual([
      "AI Training",
      "Unknown",
    ]);
    expect(
      pipelineCharts(report, range, range, "created").charts[3].months.map(
        (m) =>
          Object.values(m.values).reduce((a: number, b) => a + (b ?? 0), 0),
      ),
    ).toEqual([300, 100, 0]);
  });

  it("labels incomplete data and missing dates/expected values without flagging won rows' unused forecasts", () => {
    const report = pipeline();
    report.allData = false;
    report.rows[0].cells[5].value = null;
    report.rows[1].cells[2].value = null;
    report.rows[1].cells[3].value = null;
    report.rows[2].cells[2].value = null;
    report.rows[2].cells[3].value = null;
    const { notices } = pipelineCharts(report, range, range, "close");
    expect(notices.join(" ")).toMatch(
      /incomplete.*no usable date.*1 opportunities have neither Expected Revenue/,
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
    talentQuery.mockResolvedValue({ rows: [] });
  });
  afterEach(() => {
    jest.useRealTimers();
  });

  const overridden = { SALESFORCE_REVENUE_REPORT_ID: "00O1K00000A7UGEUA3" };

  it("keeps an overridden revenue report pending without guessing column mappings and bounds expensive monthly queries", async () => {
    expect(
      await service(overridden).load(SalesDashboardSection.Revenue, range),
    ).toEqual({
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

  it.each([undefined, "00O1K00000A7UGEUA3"])(
    "uses explicit SFDC revenue mappings and reports partial data with report override %s",
    async (reportId) => {
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
        ...(reportId ? { SALESFORCE_REVENUE_REPORT_ID: reportId } : {}),
        SALESFORCE_REVENUE_DATE_COLUMN: "date",
        SALESFORCE_REVENUE_AMOUNT_COLUMN: "recognized",
      }).load(SalesDashboardSection.Revenue, range);
      expect(getDashboardSnapshot).toHaveBeenCalledWith("revenue", {
        column: "date",
        startDate: "2026-07-31",
        endDate: "2026-11-01",
      });
      expect(result.charts[0].months.map((m) => m.values.revenue)).toEqual([
        0, 123.45, 0,
      ]);
      expect(result.notices[0]).toMatch(/incomplete/);
    },
  );

  it.each<Record<string, string>>([
    { SALESFORCE_REVENUE_DATE_COLUMN: "date" },
    { SALESFORCE_REVENUE_AMOUNT_COLUMN: "recognized" },
  ])(
    "keeps revenue pending when only one column is configured: %j",
    async (settings) => {
      const result = await service({ ...overridden, ...settings }).load(
        SalesDashboardSection.Revenue,
        range,
      );
      expect(result.charts).toEqual([]);
      expect(result.notices[0]).toMatch(/pending/);
      expect(getDashboardSnapshot).not.toHaveBeenCalled();
    },
  );

  it("charts the confirmed revenue report by default, by offering and account category", async () => {
    const ids = [
      "PSA_Revenue_Recognition__c.Date__c",
      "PSA_Revenue_Recognition__c.Amount__c",
      "offering-field",
      "deal-field",
    ];
    const types = ["date", "currency", "string", "string"];
    const rows: Array<[string, number, string, string]> = [
      ["2026-08-31", 0.1, "Challenge", "Through Wipro"],
      ["2026-08-31", 0.2, "Challenge", " Wipro Internal - Ignore"],
      ["2026-10-31", 50, "License", ""],
      ["2026-11-01", 999, "License", "External revenue"],
      ...["A", "B", "C", "D", "E", "F"].map(
        (type, i): [string, number, string, string] => [
          "2026-09-30",
          10 - i,
          type,
          "External revenue",
        ],
      ),
    ];
    getDashboardSnapshot.mockResolvedValue({
      allData: true,
      reportName: "Accounts Monthly revenue File",
      columns: ids.map((id, i) => ({
        id,
        label: [
          "Date",
          "Gross Amount",
          "Project Stream: Engagement Offering Type",
          "Deal Category",
        ][i],
        dataType: types[i],
      })),
      rows: rows.map((cells) => ({
        cells: cells.map((value) => ({ value, label: String(value) })),
      })),
    });
    const result = await service().load(SalesDashboardSection.Revenue, range);
    expect(getDashboardSnapshot).toHaveBeenCalledWith("revenue", {
      column: ids[0],
      startDate: "2026-07-31",
      endDate: "2026-11-01",
    });
    const [total, offering, category] = result.charts;
    expect(result.notices).toEqual([]);
    expect(total.months.map((m) => m.values.revenue)).toEqual([0.3, 45, 50]);
    expect(offering.series.map((s) => s.label)).toEqual([
      "License",
      "A",
      "B",
      "C",
      "D",
      "Other",
    ]);
    expect(offering.months[1].values.other).toBe(5 + 6);
    expect(offering.months[0].values.other).toBe(0.3);
    expect(category.description).toBe(
      "Monthly bookings stacked by Deal Category.",
    );
    expect(category.series.map((s) => s.label)).toEqual([
      "Unknown",
      "External revenue",
      "Wipro Internal - Ignore",
      "Through Wipro",
    ]);
  });

  it("omits a revenue breakdown whose column the report lacks, with a notice", async () => {
    getDashboardSnapshot.mockResolvedValue({
      allData: true,
      reportName: "Recognized revenue",
      columns: [
        { id: "date", dataType: "date" },
        { id: "recognized", dataType: "currency" },
      ],
      rows: [{ cells: [{ value: "2026-09-01" }, { value: 1 }] }],
    });
    const result = await service({
      ...overridden,
      SALESFORCE_REVENUE_DATE_COLUMN: "date",
      SALESFORCE_REVENUE_AMOUNT_COLUMN: "recognized",
      SALESFORCE_REVENUE_CATEGORY_COLUMN: "category",
    }).load(SalesDashboardSection.Revenue, range);
    expect(result.charts.map((c) => c.id)).toEqual(["revenue"]);
    expect(result.notices).toEqual([
      "Bookings by offering is unavailable: the report has no Engagement Offering Type column.",
      "Bookings by account category is unavailable: the report has no category column.",
    ]);
  });

  it.each([
    ["close", "CLOSE_DATE"],
    ["created", "CREATED_DATE"],
  ] as const)(
    "runs the pipeline over every charted month by %s date, not the saved fiscal year",
    async (dateBasis, column) => {
      jest.useFakeTimers({ now: Date.parse("2026-10-22T00:00:00Z") });
      getDashboardSnapshot.mockResolvedValue(pipeline());
      await service().load(SalesDashboardSection.Pipeline, { dateBasis });
      expect(getDashboardSnapshot).toHaveBeenCalledWith("pipeline", {
        column,
        startDate: "2026-04-30",
        endDate: "2027-05-01",
      });
    },
  );

  it("rejects incompatible revenue column mappings instead of producing misleading totals", async () => {
    getDashboardSnapshot.mockResolvedValue(pipeline());
    await expect(
      service({
        SALESFORCE_REVENUE_DATE_COLUMN: "5",
        SALESFORCE_REVENUE_AMOUNT_COLUMN: "0",
      }).load(SalesDashboardSection.Revenue, range),
    ).rejects.toThrow(BadGatewayException);
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
    expect(result.customerPayments?.series.map((c) => c.label)).toEqual(
      Array.from({ length: 6 }, (_, i) => `Client ${i}`),
    );
    expect(
      Object.values(result.customerPayments!.months[1].values).reduce(
        (a: number, b) => a + (b ?? 0),
        0,
      ),
    ).toBe(21);
    expect(result.customerPayments!.months[0].values).toEqual(
      Object.fromEntries(
        result.customerPayments!.series.map((c) => [c.key, 0]),
      ),
    );
    const reports = await service().load(SalesDashboardSection.Payments, range);
    expect(query.mock.calls[1][1][2]).toBe(false);
    expect(reports.charts[0].series[0].key).toBe("taas");
  });

  it.each(["sales", "reports"] as const)(
    "scopes %s talent before distinct counts, including an empty customer list",
    async (portal) => {
      query.mockResolvedValue([{ project_id: "123" }]);
      const api = service({ ENGAGEMENTS_DB_URL: "postgres://unused" });
      await api.load(SalesDashboardSection.Talent, { ...range, portal });
      expect(talentQuery.mock.calls[0][1][2]).toEqual(
        portal === "sales" ? ["123"] : null,
      );
      expect(query).toHaveBeenCalledTimes(portal === "sales" ? 1 : 0);
      query.mockResolvedValue([]);
      await api.load(SalesDashboardSection.Talent, { ...range, portal });
      expect(talentQuery.mock.calls[1][1][2]).toEqual(
        portal === "sales" ? [] : null,
      );
    },
  );

  it("uses engagement offering/deal fields instead of old Type/Account Category and corrects only blank offerings", async () => {
    const columns = [
      { id: "date", label: "Date", dataType: "date" },
      { id: "amount", label: "Gross Amount", dataType: "currency" },
      { id: "old-type", label: "Type", dataType: "string" },
      {
        id: "offering",
        label: "Project Stream: Engagement Offering Type",
        dataType: "string",
      },
      {
        id: "old-category",
        label: "Project Stream: Account Category",
        dataType: "string",
      },
      { id: "deal", label: "Deal Category", dataType: "string" },
      {
        id: "project",
        label: "Project Stream: Opportunity/Project Name",
        dataType: "string",
      },
    ];
    const rows = [
      ["TopGear", null, 10],
      ["Multiple App Enhancements 5", "", 20],
      ["Multiple App Enhancement 5", "-", 30],
      ["TopGear", "AI Training", 40],
      ["Unmapped", null, -5],
    ];
    const report = {
      allData: true,
      columns,
      rows: rows.map(([project, offering, amount]) => ({
        cells: [
          "2026-09-30",
          amount,
          "Wrong offering",
          offering,
          "Wrong category",
          "Topcoder Direct",
          project,
        ].map((value) => ({
          value,
          label: value == null ? "-" : String(value),
        })),
      })),
    } as SalesReportDto;
    expect(categoryColumn(report, CATEGORY_LABELS.offering)).toBe(3);
    expect(offeringLabel(report.rows[3], 3, 6)).toBe("AI Training");
    getDashboardSnapshot.mockResolvedValue(report);
    const result = await service({
      SALESFORCE_REVENUE_DATE_COLUMN: "date",
      SALESFORCE_REVENUE_AMOUNT_COLUMN: "amount",
    }).load(SalesDashboardSection.Revenue, range);
    const [total, offering, category] = result.charts;
    expect(total.months[1].values.revenue).toBe(95);
    expect(
      Object.fromEntries(
        offering.series.map((c) => [c.label, offering.months[1].values[c.key]]),
      ),
    ).toEqual({
      "TopGear Ops": 10,
      "Flexible Talent": 50,
      "AI Training": 40,
      Unknown: -5,
    });
    expect(category.series.map((c) => c.label)).toEqual(["Topcoder Direct"]);
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
