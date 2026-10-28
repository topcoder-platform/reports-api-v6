import { BadRequestException, ValidationPipe } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { DbService } from "../../db/db.service";
import { SalesReportDto } from "../sales/sales-reports.dto";
import { SalesReportsService } from "../sales/sales-reports.service";
import {
  SalesDashboardChartDto,
  SalesDashboardGroupBy,
  SalesDashboardQueryDto,
  SalesDashboardSection,
} from "./sales-dashboard.dto";
import { pipelineCharts } from "./sales-dashboard.pipeline";
import { SalesDashboardService } from "./sales-dashboard.service";

const range = {
  startDate: "2026-08-01T00:00:00Z",
  endDate: "2026-11-01T00:00:00Z",
};

/** @returns Synthetic won/open opportunities with categories and both date bases. Does not throw. */
function opportunities(): SalesReportDto {
  const labels = [
    "Amount",
    "Expected Revenue",
    "Probability",
    "Stage",
    "Close Date",
    "Created Date",
    "Offering Type",
    "Deal Category",
    "Customer Type",
  ];
  return {
    allData: true,
    columns: labels.map((label, i) => ({
      id: String(i),
      label,
      dataType: "string",
    })),
    rows: [
      [
        100,
        100,
        100,
        "Won - SOW Signed",
        "2026-08-01",
        "2026-09-01",
        "AI Training",
        "Direct",
        "New Customer",
      ],
      [
        200,
        200,
        100,
        "Won - SOW Signed",
        "2026-08-01",
        "2026-09-01",
        "Flexible Talent",
        "Partner",
        "New Project to Existing Customer",
      ],
      [
        300,
        90,
        50,
        "Proposal",
        "2026-09-01",
        "2026-10-01",
        "AI Training",
        "Direct",
        "Extension to Existing Project",
      ],
      [
        400,
        null,
        50,
        "Negotiation",
        "2026-09-01",
        "2026-10-01",
        "Flexible Talent",
        "Partner",
        "New Project at Existing Customer",
      ],
      [
        50,
        null,
        null,
        "Proposal",
        "2026-09-01",
        "2026-10-01",
        null,
        null,
        null,
      ],
      [
        10000,
        9000,
        90,
        "Proposal",
        "2026-11-01",
        "2026-11-01",
        "AI Training",
        "Direct",
        "New Customer",
      ],
    ].map((values, i) => ({
      id: String(i),
      cells: values.map((value) => ({
        value,
        label: value === null ? "" : String(value),
      })),
    })),
  } as SalesReportDto;
}

/** @param chart Monthly chart. @returns Per-month stack totals for conservation assertions. Does not throw. */
function totals(chart: SalesDashboardChartDto): number[] {
  return chart.months.map((month) =>
    Object.values(month.values).reduce<number>(
      (sum, value) => sum + (value ?? 0),
      0,
    ),
  );
}

/** @param chart Monthly chart. @param label Series label. @returns That series' values across months. Does not throw. */
function values(
  chart: SalesDashboardChartDto,
  label: string,
): Array<number | null> {
  const key = chart.series.find((series) => series.label === label)!.key;
  return chart.months.map((month) => month.values[key]);
}

/** @param snapshot Normalized Salesforce fixture. @returns Dashboard service without live database/network access. Does not throw. */
function service(snapshot: SalesReportDto): SalesDashboardService {
  return new SalesDashboardService(
    {} as DbService,
    new SqlLoaderService(),
    {
      getDashboardSnapshot: jest.fn().mockResolvedValue(snapshot),
    } as unknown as SalesReportsService,
    new ConfigService(),
  );
}

describe("Dashboard dimension breakdowns", () => {
  it.each(Object.values(SalesDashboardGroupBy))(
    "preserves won/open totals and expected weighting when grouping by %s",
    (groupBy) => {
      const report = opportunities();
      const { charts, notices } = pipelineCharts(
        report,
        range,
        range,
        "close",
        groupBy,
      );
      expect(charts).toHaveLength(3);
      expect(charts.every((chart) => chart.stacked)).toBe(true);
      expect(totals(charts[0])).toEqual([300, 0, 0]);
      expect(totals(charts[1])).toEqual([0, 290, 0]);
      expect(totals(charts[2])).toEqual([0, 750, 0]);
      expect(notices.join(" ")).toContain(
        "1 opportunities have neither Expected Revenue nor Probability",
      );
      const created = pipelineCharts(
        report,
        range,
        range,
        "created",
        groupBy,
      ).charts;
      expect(totals(created[0])).toEqual([0, 300, 0]);
      expect(totals(created[1])).toEqual([0, 0, 290]);
      expect(totals(created[2])).toEqual([0, 0, 750]);
      if (groupBy === SalesDashboardGroupBy.OfferingType) {
        expect(values(charts[0], "AI Training")).toEqual([100, 0, 0]);
        expect(values(charts[0], "Flexible Talent")).toEqual([200, 0, 0]);
        expect(values(charts[2], "Unknown")).toEqual([0, 50, 0]);
        expect(values(charts[1], "Flexible Talent")).toEqual([0, 200, 0]);
      }
      if (groupBy === SalesDashboardGroupBy.Stage) {
        expect(charts[2].series.map((series) => series.label)).toEqual([
          "Negotiation",
          "Proposal",
        ]);
        expect(values(charts[1], "Proposal")).toEqual([0, 90, 0]);
      }
      if (groupBy === SalesDashboardGroupBy.CustomerType) {
        expect(values(charts[0], "New Project at Existing Customer")).toEqual([
          200, 0, 0,
        ]);
        expect(values(charts[2], "New Project at Existing Customer")).toEqual([
          0, 400, 0,
        ]);
      }
    },
  );

  it("returns just the selected won breakdown and reports unavailable dimensions without substituting a total", async () => {
    const report = opportunities();
    const result = await service(report).load(SalesDashboardSection.Bookings, {
      ...range,
      groupBy: SalesDashboardGroupBy.DealCategory,
    });
    expect(result.charts).toHaveLength(1);
    expect(result.charts[0].series.map((series) => series.label)).toEqual([
      "Direct",
      "Partner",
    ]);
    report.columns[7].label = "Unrelated";
    const missing = await service(report).load(SalesDashboardSection.Bookings, {
      ...range,
      groupBy: SalesDashboardGroupBy.DealCategory,
    });
    expect(missing.charts).toEqual([]);
    expect(missing.notices.join(" ")).toContain(
      "Deal Category breakdown is unavailable",
    );
  });

  it("validates dimensions and restricts Stage to Pipeline", async () => {
    const pipe = new ValidationPipe({ transform: true, whitelist: true });
    await expect(
      pipe.transform(
        { groupBy: "invalid" },
        { type: "query", metatype: SalesDashboardQueryDto },
      ),
    ).rejects.toThrow(BadRequestException);
    for (const section of [
      SalesDashboardSection.Bookings,
      SalesDashboardSection.Revenue,
      SalesDashboardSection.Payments,
    ]) {
      await expect(
        service(opportunities()).load(section, {
          ...range,
          groupBy: SalesDashboardGroupBy.Stage,
        }),
      ).rejects.toThrow(BadRequestException);
    }
  });

  it("keeps every revenue category, corrections and unclassified rows while preserving customer totals", async () => {
    const types = [
      "New Customer",
      "New Project to Existing Customer",
      "New Project at Existing Customer",
      "Extension to Existing Project",
      "Others",
      null,
      "Others",
      "New Customer",
    ];
    const report = {
      allData: true,
      columns: [
        {
          id: "PSA_Revenue_Recognition__c.Date__c",
          label: "Date",
          dataType: "date",
        },
        {
          id: "PSA_Revenue_Recognition__c.Amount__c",
          label: "Amount",
          dataType: "currency",
        },
        {
          id: "offering",
          label: "Project Stream: Engagement Offering Type",
          dataType: "string",
        },
        { id: "deal", label: "Deal Category", dataType: "string" },
        {
          id: "__revenue_customer_type",
          label: "Customer Type",
          dataType: "picklist",
        },
        {
          id: "project",
          label: "Opportunity/Project Name",
          dataType: "string",
        },
        {
          id: "account",
          label: "Project Stream: Reporting Account",
          dataType: "string",
        },
      ],
      rows: types.map((type, i) => ({
        id: String(i),
        cells: [
          "2026-09-01",
          (i + 1) * 10,
          i === 0 ? null : `Offering ${i}`,
          i % 2 ? "Partner" : "Direct",
          type,
          i === 0 ? "TopGear" : "Project",
          i % 2 ? "Customer B" : "Customer A",
        ].map((value) => ({
          value,
          label: value == null ? "" : String(value),
        })),
      })),
    } as SalesReportDto;
    const dashboard = service(report);
    const byOffering = await dashboard.load(SalesDashboardSection.Revenue, {
      ...range,
      groupBy: SalesDashboardGroupBy.OfferingType,
    });
    expect(byOffering.charts).toHaveLength(1);
    expect(byOffering.charts[0].series).toHaveLength(8);
    expect(values(byOffering.charts[0], "TopGear Ops")).toEqual([0, 10, 0]);
    const byType = await dashboard.load(SalesDashboardSection.Revenue, {
      ...range,
      groupBy: SalesDashboardGroupBy.CustomerType,
    });
    expect(
      values(byType.charts[0], "New Project at Existing Customer"),
    ).toEqual([0, 50, 0]);
    expect(values(byType.charts[0], "Unknown")).toEqual([0, 60, 0]);
    expect(byType.notices.join(" ")).toContain("grouped as Unknown");
    const byDeal = await dashboard.load(SalesDashboardSection.Revenue, {
      ...range,
      groupBy: SalesDashboardGroupBy.DealCategory,
    });
    expect(values(byDeal.charts[0], "Direct")).toEqual([0, 160, 0]);
    for (const result of [byOffering, byType, byDeal]) {
      expect(totals(result.charts[0])).toEqual([0, 360, 0]);
      expect(result.customerRevenue).toEqual(byOffering.customerRevenue);
      expect(totals(result.customerRevenue!)).toEqual([0, 360, 0]);
    }
    report.columns[2].label = "Missing";
    const missing = await dashboard.load(SalesDashboardSection.Revenue, {
      ...range,
      groupBy: SalesDashboardGroupBy.OfferingType,
    });
    expect(missing.charts).toEqual([]);
    expect(missing.customerRevenue).toEqual(byOffering.customerRevenue);
    expect(missing.notices.join(" ")).toContain(
      "Offering Type breakdown is unavailable",
    );
  });
});
