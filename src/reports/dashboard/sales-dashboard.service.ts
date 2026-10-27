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
import { SalesRowDto } from "../sales/sales-reports.dto";
import {
  DashboardDateFilter,
  DEFAULT_REVENUE_COLUMNS,
  DEFAULT_REVENUE_REPORT_ID,
  SalesReportsService,
} from "../sales/sales-reports.service";
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
import {
  CATEGORY_LABELS,
  categoryColumn,
  categoryLabel,
  offeringLabel,
} from "./sales-dashboard.categories";
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

/** In-range revenue row, already validated and assigned to its UTC month. */
type RevenueEntry = { month: string; amount: number; row: SalesRowDto };

/** Opportunity report date columns behind each pipeline date basis. */
const PIPELINE_DATE_COLUMNS = {
  close: "CLOSE_DATE",
  created: "CREATED_DATE",
} as const;
const DAY_MS = 86400000;

/**
 * Covers half-open UTC chart windows with one inclusive Salesforce date filter, padded by a
 * day on each side for the Run As user's timezone. Rows are still bounded exactly afterwards.
 * @param column Report column the filter applies to.
 * @param ranges Chart windows that the run must cover.
 * @returns Execution-only standard date filter replacing the saved fiscal-year filter.
 * @throws Does not throw for previously validated ranges.
 */
function salesforceDateFilter(
  column: string,
  ...ranges: DashboardDateRange[]
): DashboardDateFilter {
  const day = (time: number) => new Date(time).toISOString().slice(0, 10);
  return {
    column,
    startDate: day(
      Math.min(...ranges.map((r) => Date.parse(r.startDate))) - DAY_MS,
    ),
    endDate: day(Math.max(...ranges.map((r) => Date.parse(r.endDate)))),
  };
}

/**
 * Stacks revenue by a category, optionally grouping smaller categories as Other.
 * @param range Half-open UTC range of the entries.
 * @param entries In-range revenue rows.
 * @param label Resolves the business category for each row, including source corrections.
 * @param definition Chart identity and copy.
 * @param maximumSeries Maximum series including Other; Infinity retains every customer for the table.
 * @returns A stacked currency chart whose monthly totals match the revenue total.
 * @throws Does not throw.
 */
function revenueBreakdown(
  range: DashboardDateRange,
  entries: RevenueEntry[],
  label: (entry: RevenueEntry) => string,
  definition: Pick<SalesDashboardChartDto, "id" | "title" | "description">,
  maximumSeries = 6,
): SalesDashboardChartDto {
  const totals = new Map<string, number>();
  entries.forEach((entry) =>
    totals.set(label(entry), (totals.get(label(entry)) ?? 0) + entry.amount),
  );
  const ranked = [...totals]
    .sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]))
    .map(([name]) => name);
  const top =
    ranked.length > maximumSeries ? ranked.slice(0, maximumSeries - 1) : ranked;
  const keys = new Map(top.map((name, i) => [name, `group-${i}`]));
  const chart = monthlyChart(range, {
    ...definition,
    unit: "currency",
    stacked: true,
    series: [
      ...top.map((name) => ({ key: keys.get(name)!, label: name })),
      ...(ranked.length > top.length ? [{ key: "other", label: "Other" }] : []),
    ],
  });
  entries.forEach((entry) => {
    const month = chart.months.find((m) => m.month === entry.month);
    const key = keys.get(label(entry)) ?? "other";
    if (month) month.values[key] = (month.values[key] ?? 0) + entry.amount;
  });
  return chart;
}

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
        const dateBasis = query.dateBasis ?? "close";
        return pipelineCharts(
          await this.sales.getDashboardSnapshot(
            "pipeline",
            salesforceDateFilter(
              PIPELINE_DATE_COLUMNS[dateBasis],
              pipelineRange,
              range,
            ),
          ),
          pipelineRange,
          range,
          dateBasis,
        );
      }
      case SalesDashboardSection.Revenue:
        return this.revenue(range);
      case SalesDashboardSection.Payments:
        return this.payments(range, query.portal === "sales");
      case SalesDashboardSection.Talent:
        return this.talent(range, query.portal === "sales");
      case SalesDashboardSection.GrossMargin:
        return this.grossMargin(range);
    }
  }

  /**
   * Resolves the revenue report's columns. The confirmed report uses its verified column IDs
   * unless settings override them; an overridden report must configure date and amount itself.
   * @returns Date/amount IDs and optional category overrides; categories otherwise resolve from business labels.
   * @throws Does not throw.
   */
  private revenueColumns():
    | {
        date: string;
        amount: string;
        offering?: string;
        category?: string;
        customer?: string;
      }
    | undefined {
    const reportId = this.config.get<string>(
      "SALESFORCE_REVENUE_REPORT_ID",
      DEFAULT_REVENUE_REPORT_ID,
    );
    const defaults: Partial<typeof DEFAULT_REVENUE_COLUMNS> =
      reportId === DEFAULT_REVENUE_REPORT_ID ? DEFAULT_REVENUE_COLUMNS : {};
    const setting = (name: string, fallback?: string) =>
      this.config.get<string>(name) || fallback;
    const date = setting("SALESFORCE_REVENUE_DATE_COLUMN", defaults.date);
    const amount = setting("SALESFORCE_REVENUE_AMOUNT_COLUMN", defaults.amount);
    if (!reportId || !date || !amount) return undefined;
    return {
      date,
      amount,
      offering: setting("SALESFORCE_REVENUE_OFFERING_COLUMN"),
      category: setting("SALESFORCE_REVENUE_CATEGORY_COLUMN"),
      customer: setting("SALESFORCE_REVENUE_CUSTOMER_COLUMN"),
    };
  }

  /**
   * Groups the confirmed (or overridden) Salesforce revenue report by its date and amount fields.
   * @param range Half-open UTC range; the report run is filtered to it instead of the saved fiscal year.
   * @returns Monthly revenue and category charts plus all customers for the customer matrix.
   * Missing mappings and incomplete sources are labelled without suppressing available charts.
   * @throws BadGatewayException for invalid date/amount fields; sanitized upstream errors propagate.
   */
  private async revenue(range: DashboardDateRange): Promise<SalesDashboardDto> {
    const columns = this.revenueColumns();
    if (!columns) {
      return {
        charts: [],
        notices: [
          "Revenue report pending: the Salesforce revenue source is not fully configured.",
        ],
      };
    }
    const report = await this.sales.getDashboardSnapshot(
      "revenue",
      salesforceDateFilter(columns.date, range),
    );
    const dateIndex = report.columns.findIndex(
      (c) => c.id === columns.date && ["date", "datetime"].includes(c.dataType),
    );
    const amountIndex = report.columns.findIndex(
      (c) =>
        c.id === columns.amount && ["currency", "double"].includes(c.dataType),
    );
    if (dateIndex < 0 || amountIndex < 0)
      throw new BadGatewayException(
        "The configured revenue columns are missing or have incompatible types.",
      );
    const currencies = new Set<string>();
    const entries: RevenueEntry[] = [];
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
      entries.push({
        month: new Date(time).toISOString().slice(0, 7) + "-01",
        amount,
        row,
      });
    });
    const total = monthlyChart(range, {
      id: "revenue",
      title: "Revenue report",
      description: `Monthly revenue from ${report.reportName}.`,
      unit: "currency",
      stacked: false,
      series: [{ key: "revenue", label: "Revenue" }],
    });
    entries.forEach((entry) => {
      const month = total.months.find((m) => m.month === entry.month);
      if (month)
        month.values.revenue = (month.values.revenue ?? 0) + entry.amount;
    });
    const notices = report.allData
      ? []
      : [
          "Salesforce returned an incomplete revenue report. Totals include only returned rows.",
        ];
    const charts = [total];
    const projectIndex = categoryColumn(report, CATEGORY_LABELS.project);
    [
      {
        id: "revenue-offering",
        title: "Revenue by offering",
        column: columns.offering,
        label: CATEGORY_LABELS.offering,
      },
      {
        id: "revenue-category",
        title: "Revenue by account category",
        column: columns.category,
        label: CATEGORY_LABELS.deal,
      },
    ].forEach(({ column, label, ...definition }) => {
      const index = column
        ? report.columns.findIndex((c) => c.id === column)
        : categoryColumn(report, label);
      if (index < 0) {
        notices.push(
          `${definition.title} is unavailable: the report has no ${column ?? (definition.id === "revenue-offering" ? "Engagement Offering Type" : "Deal Category")} column.`,
        );
        return;
      }
      charts.push(
        revenueBreakdown(
          range,
          entries,
          (entry) =>
            definition.id === "revenue-offering"
              ? offeringLabel(entry.row, index, projectIndex)
              : categoryLabel(entry.row, index) || "Unknown",
          {
            ...definition,
            description: `Monthly revenue stacked by ${report.columns[index].label}.`,
          },
        ),
      );
    });
    // Prefer the end customer to a parent/account name when the report exposes both.
    const customerIndex = columns.customer
      ? report.columns.findIndex((column) => column.id === columns.customer)
      : ([
          /^(?:subcontracting )?end customer$/i,
          /^customer(?: name)?$/i,
          /^account name$/i,
        ]
          .map((label) => categoryColumn(report, label))
          .find((index) => index >= 0) ?? -1);
    const customerRevenue =
      customerIndex >= 0
        ? revenueBreakdown(
            range,
            entries,
            (entry) =>
              categoryLabel(entry.row, customerIndex) || "Unknown customer",
            {
              id: "revenue-customer-all",
              title: "Revenue Customer-Wise",
              description: `All customers by ${report.columns[customerIndex].label}, with monthly revenue and annual totals.`,
            },
            Infinity,
          )
        : undefined;
    if (!customerRevenue)
      notices.push(
        `Revenue Customer-Wise is unavailable: the report has no ${columns.customer ?? "customer name"} column.`,
      );
    [...charts, ...(customerRevenue ? [customerRevenue] : [])].forEach(
      (chart) =>
        chart.months.forEach((month) =>
          Object.keys(month.values).forEach((key) => {
            month.values[key] =
              Math.round((month.values[key] ?? 0) * 100) / 100;
          }),
        ),
    );
    if (skipped)
      notices.push(
        `${skipped} revenue rows have no usable date or amount and are excluded.`,
      );
    if (currencies.size > 1 || [...currencies].some((code) => code !== "USD"))
      notices.push(
        `Source currencies: ${[...currencies].join(", ")}. No currency conversion is applied.`,
      );
    return { charts, customerRevenue, notices };
  }

  /**
   * Aggregates scoped payment events by type and customer, with customer ranking after filtering.
   * @param range Half-open UTC reporting range.
   * @param customerOnly Excludes TaaS, Topcoder and payments without a linked customer in Sales.
   * @returns Payment values, distinct members per type, top-five customer chart and an ungrouped customer table.
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
    // Keep every customer in the table, independently of the chart's top-five ranking.
    const customers = new Map<string, string>();
    rows
      .filter((row) => row.kind === "customer")
      .forEach((row) => {
        const key = JSON.stringify([row.customer_id, row.customer_label]);
        customers.set(
          key,
          row.customer_label ||
            (row.customer_id
              ? `Customer ${row.customer_id}`
              : "Unknown customer"),
        );
      });
    const customerPayments = monthlyChart(range, {
      id: "payment-customer-all",
      title: "Monthly member payments by customer",
      description:
        "All customers, with monthly payments and fiscal-period totals.",
      unit: "currency",
      stacked: true,
      series: [...customers]
        .sort((a, b) => a[1].localeCompare(b[1]) || a[0].localeCompare(b[0]))
        .map(([key, label]) => ({ key, label })),
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
        const fullMonth = customerPayments.months.find(
          (m) => m.month === row.month,
        );
        if (fullMonth)
          fullMonth.values[key] =
            (fullMonth.values[key] ?? 0) + Number(row.amount);
        const selected = top.some((c) => c.key === key) ? key : "other";
        const month = customerChart.months.find((m) => m.month === row.month);
        if (month)
          month.values[selected] =
            (month.values[selected] ?? 0) + Number(row.amount);
      }
    });
    return {
      charts: [...charts, customerChart],
      customerPayments,
      notices: [],
    };
  }

  /**
   * Reads actual assignment acceptance and ending dates from the engagement database.
   * @param range Half-open UTC range.
   * @param customerOnly Restricts assignments to linked external-customer projects for the Sales portal.
   * @returns Distinct monthly newly assigned, completed and ongoing member counts after scoping.
   * @throws ServiceUnavailableException if the engagement connection is missing; query failures propagate.
   */
  private async talent(
    range: DashboardDateRange,
    customerOnly: boolean,
  ): Promise<SalesDashboardDto> {
    if (!this.engagementsPool) {
      const connectionString = this.config.get<string>("ENGAGEMENTS_DB_URL");
      if (!connectionString)
        throw new ServiceUnavailableException(
          "The engagements reporting connection is not configured.",
        );
      this.engagementsPool = new Pool({ connectionString });
    }
    const customerProjects = customerOnly
      ? await this.db.query<{ project_id: string }>(
          this.sql.load("reports/dashboard/sales-customer-projects.sql"),
        )
      : undefined;
    const result = await this.engagementsPool.query<{
      month: string;
      newly_assigned: string;
      completed: string;
      ongoing: string;
    }>(this.sql.load("reports/dashboard/sales-talent.sql"), [
      range.startDate,
      range.endDate,
      customerProjects?.map((project) => project.project_id) ?? null,
    ]);
    const chart = monthlyChart(range, {
      id: "flexible-talent",
      title: "Flexible talent",
      description:
        (customerOnly ? "Customer work only. " : "") +
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
