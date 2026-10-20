import {
  BadGatewayException,
  BadRequestException,
  Injectable,
  OnModuleDestroy,
  ServiceUnavailableException,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { Pool } from "pg";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { DbService } from "../../db/db.service";
import { SalesReportsService } from "../sales/sales-reports.service";
import {
  DashboardDateRange,
  resolveDashboardDateRange,
} from "./dashboard-reports.service";
import {
  SalesDashboardChartDto,
  SalesDashboardDto,
  SalesDashboardQueryDto,
  SalesDashboardSection,
} from "./sales-dashboard.dto";
import { monthlyChart, pipelineCharts } from "./sales-dashboard.pipeline";

type PaymentRow = {
  month: string;
  kind: string;
  payment_type: string;
  customer_id: string | null;
  customer_label: string | null;
  amount: string;
  members: string;
};

/** Builds the monthly business views shared by Reports and Sales, keeping source failures independent. */
@Injectable()
export class SalesDashboardService implements OnModuleDestroy {
  private engagementsPool?: Pool;

  /** @param db Main reporting connection. @param sql SQL loader. @param sales Shared SFDC snapshots. @param config Source configuration. Does not throw. */
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
    private readonly sales: SalesReportsService,
    private readonly config: ConfigService,
  ) {}

  /** @returns Resolves after releasing the optional engagements pool. @throws Pool shutdown errors. */
  async onModuleDestroy(): Promise<void> {
    await this.engagementsPool?.end();
  }

  /**
   * Dispatches an independently requested section to its data source.
   * @param section Validated section identifier.
   * @param query Portal, date basis and optional UTC range, limited to 24 months.
   * @returns Charts plus source limitations; unconfigured revenue returns an explicit notice.
   * @throws BadRequestException for oversized ranges; database or sanitized Salesforce errors otherwise.
   */
  async load(
    section: SalesDashboardSection,
    query: SalesDashboardQueryDto,
  ): Promise<SalesDashboardDto> {
    const range = resolveDashboardDateRange(query);
    if (
      Date.parse(range.endDate) - Date.parse(range.startDate) >
      732 * 86400000
    )
      throw new BadRequestException(
        "Choose a range of no more than 24 months.",
      );
    switch (section) {
      case SalesDashboardSection.Pipeline: {
        const now = new Date();
        const pipelineRange =
          query.startDate || query.endDate
            ? range
            : {
                startDate: new Date(
                  Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - 3, 1),
                ).toISOString(),
                endDate: new Date(
                  Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + 7, 1),
                ).toISOString(),
              };
        return pipelineCharts(
          await this.sales.getDashboardSnapshot("pipeline"),
          pipelineRange,
          range,
          query.dateBasis ?? "close",
        );
      }
      case SalesDashboardSection.Revenue:
        return this.revenue(range);
      case SalesDashboardSection.Payments:
        return this.payments(range, query.portal === "sales");
      case SalesDashboardSection.Talent:
        return this.talent(range);
      case SalesDashboardSection.GrossMargin:
        return this.grossMargin(range);
    }
  }

  /**
   * Groups the configured Salesforce revenue report by its explicitly selected date and amount fields.
   * @param range Half-open UTC range.
   * @returns A monthly revenue chart, or a pending-configuration notice; incomplete sources are labelled.
   * @throws BadGatewayException for invalid source fields; sanitized upstream errors propagate.
   */
  private async revenue(range: DashboardDateRange): Promise<SalesDashboardDto> {
    const dateColumn = this.config.get<string>(
      "SALESFORCE_REVENUE_DATE_COLUMN",
    );
    const amountColumn = this.config.get<string>(
      "SALESFORCE_REVENUE_AMOUNT_COLUMN",
    );
    if (
      !this.config.get<string>("SALESFORCE_REVENUE_REPORT_ID") ||
      !dateColumn ||
      !amountColumn
    ) {
      return {
        charts: [],
        notices: [
          "Revenue report pending: the Salesforce report and its monthly date and revenue columns have not been configured.",
        ],
      };
    }
    const report = await this.sales.getDashboardSnapshot("revenue");
    const dateIndex = report.columns.findIndex(
      (c) => c.id === dateColumn && ["date", "datetime"].includes(c.dataType),
    );
    const amountIndex = report.columns.findIndex(
      (c) =>
        c.id === amountColumn && ["currency", "double"].includes(c.dataType),
    );
    if (dateIndex < 0 || amountIndex < 0)
      throw new BadGatewayException(
        "The configured revenue columns are missing or have incompatible types.",
      );
    const chart = monthlyChart(range, {
      id: "revenue",
      title: "Revenue report",
      description: `Monthly revenue from ${report.reportName}.`,
      unit: "currency",
      stacked: false,
      series: [{ key: "revenue", label: "Revenue" }],
    });
    const currencies = new Set<string>();
    let skipped = 0;
    report.rows.forEach((row) => {
      const raw = row.cells[dateIndex].value;
      const time =
        typeof raw === "number"
          ? raw
          : typeof raw === "string"
            ? Date.parse(raw)
            : NaN;
      const amount = row.cells[amountIndex].value;
      if (!Number.isFinite(time) || typeof amount !== "number") {
        skipped++;
        return;
      }
      if (
        time < Date.parse(range.startDate) ||
        time >= Date.parse(range.endDate)
      )
        return;
      const currency = row.cells[amountIndex].currencyCode;
      if (currency) currencies.add(currency);
      const month = chart.months.find(
        (m) => m.month === new Date(time).toISOString().slice(0, 7) + "-01",
      );
      if (month) month.values.revenue = (month.values.revenue ?? 0) + amount;
    });
    const notices = report.allData
      ? []
      : [
          "Salesforce returned an incomplete revenue report. Totals include only returned rows.",
        ];
    if (skipped)
      notices.push(
        `${skipped} revenue rows have no usable date or amount and are excluded.`,
      );
    if (currencies.size > 1 || [...currencies].some((code) => code !== "USD"))
      notices.push(
        `Source currencies: ${[...currencies].join(", ")}. No currency conversion is applied.`,
      );
    return { charts: [chart], notices };
  }

  /**
   * Aggregates scoped payment events by type and customer, with customer ranking after filtering.
   * @param range Half-open UTC reporting range.
   * @param customerOnly Excludes TaaS, Topcoder and payments without a linked customer in Sales.
   * @returns Payment values, distinct paid members per type, and the top five customers plus Other.
   * @throws Propagates database errors.
   */
  private async payments(
    range: DashboardDateRange,
    customerOnly: boolean,
  ): Promise<SalesDashboardDto> {
    const rows = await this.db.query<PaymentRow>(
      this.sql.load("reports/dashboard/sales-payments.sql"),
      [range.startDate, range.endDate, customerOnly],
    );
    const types = [
      ...(!customerOnly ? [{ key: "taas", label: "TaaS" }] : []),
      { key: "task", label: "Task" },
      { key: "challenge", label: "Challenge" },
      { key: "engagement", label: "Engagement" },
    ];
    const charts = [
      monthlyChart(range, {
        id: "payment-type",
        title: "Member payments by type",
        description: "Payment values by payment creation month.",
        unit: "currency",
        stacked: true,
        series: types,
      }),
      monthlyChart(range, {
        id: "members-paid",
        title: "Members paid by type",
        description:
          "Unique members within each payment type and creation month.",
        unit: "count",
        stacked: true,
        series: types,
      }),
    ];
    const totals = new Map<
      string,
      { key: string; label: string; total: number }
    >();
    rows
      .filter(
        (row) =>
          row.kind === "customer" && row.customer_id && row.customer_label,
      )
      .forEach((row) => {
        const key = JSON.stringify([row.customer_id, row.customer_label]);
        const entry = totals.get(key) ?? {
          key,
          label: row.customer_label!,
          total: 0,
        };
        entry.total += Number(row.amount);
        totals.set(key, entry);
      });
    const top = [...totals.values()]
      .sort((a, b) => b.total - a.total || a.key.localeCompare(b.key))
      .slice(0, 5);
    const customerChart = monthlyChart(range, {
      id: "payment-customer",
      title: "Member payments by customer",
      description:
        "Top five customers in this period; remaining customers are grouped as Other.",
      unit: "currency",
      stacked: true,
      series: [
        ...top.map(({ key, label }) => ({ key, label })),
        { key: "other", label: "Other Customers" },
      ],
    });
    rows.forEach((row) => {
      if (row.kind === "type") {
        charts.forEach((chart, index) => {
          const month = chart.months.find((m) => m.month === row.month);
          if (month && chart.series.some((s) => s.key === row.payment_type))
            month.values[row.payment_type] = Number(
              index === 0 ? row.amount : row.members,
            );
        });
      } else {
        const key = JSON.stringify([row.customer_id, row.customer_label]);
        const selected = top.some((c) => c.key === key) ? key : "other";
        const month = customerChart.months.find((m) => m.month === row.month);
        if (month)
          month.values[selected] =
            (month.values[selected] ?? 0) + Number(row.amount);
      }
    });
    return { charts: [...charts, customerChart], notices: [] };
  }

  /**
   * Reads actual assignment acceptance and ending dates from the engagement database.
   * @param range Half-open UTC range.
   * @returns Distinct monthly newly assigned, completed and ongoing member counts.
   * @throws ServiceUnavailableException if the engagement connection is missing; query failures propagate.
   */
  private async talent(range: DashboardDateRange): Promise<SalesDashboardDto> {
    if (!this.engagementsPool) {
      const connectionString = this.config.get<string>("ENGAGEMENTS_DB_URL");
      if (!connectionString)
        throw new ServiceUnavailableException(
          "The engagements reporting connection is not configured.",
        );
      this.engagementsPool = new Pool({ connectionString });
    }
    const result = await this.engagementsPool.query<{
      month: string;
      newly_assigned: string;
      completed: string;
      ongoing: string;
    }>(this.sql.load("reports/dashboard/sales-talent.sql"), [
      range.startDate,
      range.endDate,
    ]);
    const chart = monthlyChart(range, {
      id: "flexible-talent",
      title: "Flexible talent",
      description:
        "Unique members newly assigned or completed during the month, and ongoing at month end (today for the current month). Legacy assignments use their start date when acceptance is unknown.",
      unit: "count",
      stacked: false,
      series: [
        { key: "newlyAssigned", label: "Newly assigned" },
        { key: "completed", label: "Completed" },
        { key: "ongoing", label: "Ongoing" },
      ],
    });
    chart.months = result.rows.map((row) => ({
      month: row.month,
      values: {
        newlyAssigned: Number(row.newly_assigned),
        completed: Number(row.completed),
        ongoing: Number(row.ongoing),
      },
    }));
    return { charts: [chart], notices: [] };
  }

  /**
   * Averages stored markup fractions equally across payments created each month.
   * @param range Half-open UTC range; all payment types and statuses participate in both portals.
   * @returns Percentages (not fee/revenue ratios); unknown markup is shown as unavailable.
   * @throws Propagates database errors.
   */
  private async grossMargin(
    range: DashboardDateRange,
  ): Promise<SalesDashboardDto> {
    const rows = await this.db.query<{
      month: string;
      markup: string | null;
      missing: string;
    }>(this.sql.load("reports/dashboard/sales-gross-margin.sql"), [
      range.startDate,
      range.endDate,
    ]);
    const chart: SalesDashboardChartDto = monthlyChart(range, {
      id: "gross-margin",
      title: "Gross margin",
      description:
        "Average markup percentage across all payments created in each month. Each payment is weighted equally; unknown markup is excluded.",
      unit: "percent",
      stacked: false,
      series: [{ key: "markup", label: "Average markup" }],
    });
    chart.months.forEach((month) => {
      const row = rows.find((r) => r.month === month.month);
      month.values.markup = row?.markup == null ? null : Number(row.markup);
    });
    const missing = rows.reduce((sum, row) => sum + Number(row.missing), 0);
    return {
      charts: [chart],
      notices: missing
        ? [
            `${missing} payments have no recorded markup and are excluded from the average.`,
          ]
        : [],
    };
  }
}
