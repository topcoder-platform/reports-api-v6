import { BadRequestException, ValidationPipe } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { DbService } from "../../db/db.service";
import { SalesReportDto } from "../sales/sales-reports.dto";
import {
  DEFAULT_REVENUE_COLUMNS,
  DEFAULT_REVENUE_FORECAST_COLUMNS,
  SalesReportsService,
} from "../sales/sales-reports.service";
import {
  SalesDashboardGroupBy,
  SalesDashboardQueryDto,
  SalesDashboardSection,
} from "./sales-dashboard.dto";
import { SalesDashboardService } from "./sales-dashboard.service";

const range = {
  startDate: "2026-04-01T00:00:00Z",
  endDate: "2027-04-01T00:00:00Z",
};

/** Builds synthetic revenue with old closures, fiscal boundaries, missing dates and an out-of-period row. */
function fixture(forecast: boolean): SalesReportDto {
  const fields = forecast
    ? DEFAULT_REVENUE_FORECAST_COLUMNS
    : DEFAULT_REVENUE_COLUMNS;
  return {
    allData: true,
    reportName: "Synthetic revenue",
    columns: [
      { id: fields.date, label: "Date", dataType: "date" },
      { id: fields.amount, label: "Amount", dataType: "currency" },
      {
        id: fields.closeDate,
        label: forecast
          ? "Opportunity: Close Date"
          : "Opportunity/Project Close Date",
        dataType: "date",
      },
      {
        id: "offering",
        label: "Opportunity: Engagement Offering Type",
        dataType: "picklist",
      },
      { id: "deal", label: "Opportunity: Deal Category", dataType: "picklist" },
      {
        id: forecast
          ? DEFAULT_REVENUE_FORECAST_COLUMNS.customerType
          : "__revenue_customer_type",
        label: "Opportunity: New Customer, or Follow-On Business?",
        dataType: "picklist",
      },
      { id: "customer", label: "Reporting Account", dataType: "string" },
    ],
    rows: [
      [
        "2026-04-01",
        100,
        "2021-03-31",
        "AI Training",
        "Topcoder Direct",
        "New Customer",
        "Customer A",
      ],
      [
        "2026-04-01",
        200,
        "2025-03-31",
        "Flexible Talent",
        "Wipro Direct",
        "New Project to Existing Customer",
        "Customer A",
      ],
      [
        "2026-05-01",
        300,
        "2025-04-01",
        "AI Training",
        "Topcoder Direct",
        "New Customer",
        "Customer B",
      ],
      [
        "2026-05-01",
        -25,
        "2026-03-31T23:59:59Z",
        null,
        null,
        null,
        "Customer B",
      ],
      [
        "2026-05-01",
        40,
        "2026-04-01T00:00:00Z",
        "AI Training",
        "Topcoder Direct",
        "New Customer",
        "Customer B",
      ],
      ["2026-05-01", 50, null, null, null, null, "Customer B"],
      ["2027-03-31", 60, "invalid", null, null, null, "Customer B"],
      [
        "2027-04-01",
        999,
        "2025-04-01",
        "AI Training",
        "Topcoder Direct",
        "New Customer",
        "Customer B",
      ],
    ].map((values, index) => ({
      id: String(index),
      cells: values.map((value) => ({
        value,
        label: value === null ? "" : String(value),
      })),
    })),
  } as SalesReportDto;
}

/** Instantiates the real aggregator with only its external report source mocked. */
function setup(report: SalesReportDto, settings = {}) {
  const getDashboardSnapshot = jest.fn().mockResolvedValue(report);
  const service = new SalesDashboardService(
    {} as DbService,
    new SqlLoaderService(),
    { getDashboardSnapshot } as unknown as SalesReportsService,
    new ConfigService(settings),
  );
  return { service, getDashboardSnapshot };
}

describe.each([
  SalesDashboardSection.Revenue,
  SalesDashboardSection.RevenueForecast,
])("%s fiscal closure", (section) => {
  const forecast = section === SalesDashboardSection.RevenueForecast;
  it("splits revenue by closure ending year without moving revenue months or losing unknowns/credits", async () => {
    const { service, getDashboardSnapshot } = setup(fixture(forecast));
    const result = await service.load(section, {
      ...range,
      groupBy: SalesDashboardGroupBy.FyClosure,
    });
    const chart = result.charts[0];
    expect(chart.id).toBe(section);
    expect(chart.months).toHaveLength(12);
    const totals = Object.fromEntries(
      chart.series.map((series) => [
        series.label,
        chart.months.reduce(
          (sum, month) => sum + (month.values[series.key] ?? 0),
          0,
        ),
      ]),
    );
    expect(totals).toEqual({
      FY21: 100,
      FY25: 200,
      FY26: 275,
      FY27: 40,
      Unknown: 110,
    });
    expect(
      Object.values(chart.months[0].values).reduce(
        (a, b) => (a ?? 0) + (b ?? 0),
        0,
      ),
    ).toBe(300);
    expect(
      Object.values(chart.months[11].values).reduce(
        (a, b) => (a ?? 0) + (b ?? 0),
        0,
      ),
    ).toBe(60);
    const fields = forecast
      ? DEFAULT_REVENUE_FORECAST_COLUMNS
      : DEFAULT_REVENUE_COLUMNS;
    expect(getDashboardSnapshot).toHaveBeenCalledWith(
      section,
      {
        column: fields.date,
        startDate: "2026-03-31",
        endDate: "2027-04-01",
      },
      expect.arrayContaining([fields.closeDate]),
      !forecast,
    );
    const byOffering = await service.load(section, {
      ...range,
      groupBy: SalesDashboardGroupBy.OfferingType,
    });
    expect(
      chart.months.map((month) =>
        Object.values(month.values).reduce<number>(
          (sum, n) => sum + (n ?? 0),
          0,
        ),
      ),
    ).toEqual(
      byOffering.charts[0].months.map((month) =>
        Object.values(month.values).reduce<number>(
          (sum, n) => sum + (n ?? 0),
          0,
        ),
      ),
    );
    expect(result.customerRevenue).toEqual(byOffering.customerRevenue);
  });

  it.each(["missing", "string"])(
    "reports an unavailable breakdown for a %s close-date field",
    async (type) => {
      const report = fixture(forecast);
      if (type === "missing") report.columns[2].id = "unrelated";
      else report.columns[2].dataType = type;
      const { service } = setup(report);
      const result = await service.load(section, {
        ...range,
        groupBy: SalesDashboardGroupBy.FyClosure,
      });
      expect(result.charts).toEqual([]);
      expect(result.notices.join(" ")).toContain(
        "FY Closure breakdown is unavailable",
      );
    },
  );

  it("keeps category filters, empty data and partial-source notices working", async () => {
    const report = fixture(forecast);
    report.allData = false;
    const { service } = setup(report);
    const result = await service.load(section, {
      ...range,
      groupBy: SalesDashboardGroupBy.FyClosure,
      offeringType: ["Flexible Talent"],
      dealCategory: ["Wipro-Direct"],
    });
    expect(result.charts[0].series.map((series) => series.label)).toEqual([
      "FY25",
    ]);
    expect(result.notices.join(" ")).toContain("incomplete revenue report");
    const empty = await service.load(section, {
      ...range,
      groupBy: SalesDashboardGroupBy.FyClosure,
      offeringType: ["Missing"],
    });
    expect(empty.charts[0].series).toEqual([]);
    expect(empty.charts[0].months).toHaveLength(12);
  });
});

it.each([
  SalesDashboardGroupBy.OfferingType,
  SalesDashboardGroupBy.DealCategory,
  SalesDashboardGroupBy.CustomerType,
])(
  "uses forecast fields for %s without the recognized revenue customer lookup",
  async (groupBy) => {
    const { service, getDashboardSnapshot } = setup(fixture(true));
    const result = await service.load(SalesDashboardSection.RevenueForecast, {
      ...range,
      groupBy,
    });
    expect(result.charts[0].id).toBe("revenue-forecast");
    expect(result.charts[0].series.length).toBeGreaterThan(1);
    expect(getDashboardSnapshot).toHaveBeenCalledWith(
      "revenue-forecast",
      expect.objectContaining({
        column: DEFAULT_REVENUE_FORECAST_COLUMNS.date,
      }),
      [DEFAULT_REVENUE_FORECAST_COLUMNS.customerType],
      false,
    );
    expect(result.customerRevenue).toBeUndefined();
  },
);

it("accepts fyClosure in DTO validation but rejects it outside revenue and forecast", async () => {
  const query = await new ValidationPipe({ transform: true }).transform(
    { ...range, groupBy: "fyClosure" },
    { type: "query", metatype: SalesDashboardQueryDto },
  );
  const { service, getDashboardSnapshot } = setup(fixture(true));
  for (const section of [
    SalesDashboardSection.Bookings,
    SalesDashboardSection.Pipeline,
    SalesDashboardSection.Payments,
    SalesDashboardSection.Talent,
  ]) {
    await expect(service.load(section, query)).rejects.toBeInstanceOf(
      BadRequestException,
    );
  }
  expect(getDashboardSnapshot).not.toHaveBeenCalled();
});

it("requires mappings for a custom forecast source and honors explicit fields", async () => {
  const settings = { SALESFORCE_REVENUE_FORECAST_REPORT_ID: "custom" };
  const report = fixture(true);
  const pending = await setup(report, settings).service.load(
    SalesDashboardSection.RevenueForecast,
    range,
  );
  expect(pending.charts).toEqual([]);
  expect(pending.notices[0]).toContain("pending");
  report.columns[2].id = "custom_close";
  const { service, getDashboardSnapshot } = setup(report, {
    ...settings,
    SALESFORCE_REVENUE_FORECAST_DATE_COLUMN:
      DEFAULT_REVENUE_FORECAST_COLUMNS.date,
    SALESFORCE_REVENUE_FORECAST_AMOUNT_COLUMN:
      DEFAULT_REVENUE_FORECAST_COLUMNS.amount,
    SALESFORCE_REVENUE_FORECAST_CLOSE_DATE_COLUMN: "custom_close",
  });
  const result = await service.load(SalesDashboardSection.RevenueForecast, {
    ...range,
    groupBy: SalesDashboardGroupBy.FyClosure,
  });
  expect(result.charts[0].series.map((series) => series.label)).toContain(
    "FY21",
  );
  expect(getDashboardSnapshot).toHaveBeenCalledWith(
    "revenue-forecast",
    expect.anything(),
    ["custom_close"],
    false,
  );
});
