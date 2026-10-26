import { BadGatewayException } from "@nestjs/common";
import { SalesReportDto } from "../sales/sales-reports.dto";
import { DashboardDateRange } from "./dashboard-reports.service";
import {
  CATEGORY_LABELS,
  categoryColumn,
  categoryLabel,
} from "./sales-dashboard.categories";
import {
  SalesDashboardChartDto,
  SalesDashboardDto,
} from "./sales-dashboard.dto";

/**
 * Stages counted as Closed Won. Topcoder's only won Salesforce stage is `Won - SOW Signed`
 * (closed and won), which the Sales app's Total WON SOW Signed card also reports. `Won - Closed`
 * and Salesforce's default `Closed Won` still match, for orgs that use them.
 */
const WON_STAGE = /^(won\b|closed won$)/i;

/**
 * Creates zero-filled UTC months for each series, used by the monthly business charts.
 * @param range Inclusive start and exclusive end.
 * @param definition Chart identity, labels, units and series.
 * @returns An independent mutable chart for server-side aggregation.
 * @throws Does not throw for a previously validated range.
 */
export function monthlyChart(
  range: DashboardDateRange,
  definition: Omit<SalesDashboardChartDto, "months">,
): SalesDashboardChartDto {
  const start = new Date(range.startDate);
  const cursor = new Date(
    Date.UTC(start.getUTCFullYear(), start.getUTCMonth(), 1),
  );
  const months: SalesDashboardChartDto["months"] = [];
  while (cursor.getTime() < Date.parse(range.endDate)) {
    months.push({
      month: cursor.toISOString().slice(0, 10),
      values: Object.fromEntries(definition.series.map((s) => [s.key, 0])),
    });
    cursor.setUTCMonth(cursor.getUTCMonth() + 1);
  }
  return { ...definition, months };
}

/**
 * Locates a known Salesforce field, preferring converted currency columns as Sales already does.
 * @param report Normalized report schema.
 * @param label Established Salesforce display label.
 * @returns Cell index, or -1 for an unavailable field.
 * @throws Does not throw.
 */
function column(report: SalesReportDto, label: string): number {
  const converted = report.columns.findIndex(
    (c) => c.label.toLowerCase() === `${label} (converted)`,
  );
  return converted >= 0
    ? converted
    : report.columns.findIndex((c) => c.label.toLowerCase() === label);
}

/**
 * Aggregates won bookings and their three business categories separately from open pipeline amounts.
 * @param report Complete normalized source snapshot, before UI pagination.
 * @param range Pipeline window (normally three months back through six months ahead).
 * @param closedRange Historical window for Closed Won amounts.
 * @param dateBasis Close date or Created date, selected by the user.
 * @returns Zero-filled charts and explicit incomplete/missing-data notices.
 * @throws BadGatewayException if the source lacks amount, stage or the selected date field.
 */
export function pipelineCharts(
  report: SalesReportDto,
  range: DashboardDateRange,
  closedRange: DashboardDateRange,
  dateBasis: "close" | "created",
): SalesDashboardDto {
  const amountIndex = column(report, "amount");
  const expectedIndex = column(report, "expected revenue");
  const probabilityIndex = column(report, "probability");
  const stageIndex = column(report, "stage");
  const dateIndex = column(
    report,
    dateBasis === "close" ? "close date" : "created date",
  );
  if ([amountIndex, stageIndex, dateIndex].includes(-1)) {
    throw new BadGatewayException(
      "The pipeline report must include Amount, Stage and the selected date column.",
    );
  }
  const stages = [
    ...new Set(
      report.rows
        .map((row) => row.cells[stageIndex]?.label.trim() || "Unknown")
        .filter((stage) => !WON_STAGE.test(stage)),
    ),
  ].sort();
  const stageKeys = new Map(stages.map((label, i) => [label, `stage-${i}`]));
  const charts = [
    monthlyChart(closedRange, {
      id: "closed-won",
      title: "Won - SOW Signed bookings",
      description:
        "Amount for won opportunities (the Won - SOW Signed stage), by selected date.",
      unit: "currency",
      stacked: false,
      series: [{ key: "amount", label: "Bookings won" }],
    }),
    monthlyChart(range, {
      id: "expected-revenue",
      title: "Expected bookings",
      description:
        "Open opportunities only: Expected Revenue, falling back to Amount × Probability. Won bookings are excluded.",
      unit: "currency",
      stacked: false,
      series: [{ key: "amount", label: "Expected bookings" }],
    }),
    monthlyChart(range, {
      id: "pipeline-stage",
      title: "Pipeline by stage",
      description:
        "Open opportunity amount split by stage and month, excluding won bookings.",
      unit: "currency",
      stacked: true,
      series: stages.map((label) => ({ key: stageKeys.get(label)!, label })),
    }),
  ];
  const notices = report.allData
    ? []
    : [
        "Salesforce returned an incomplete report. These charts show only the returned rows.",
      ];
  const breakdowns = [
    {
      id: "won-offering",
      title: "Bookings won by offering type",
      label: CATEGORY_LABELS.offering,
    },
    {
      id: "won-deal-category",
      title: "Bookings won by deal category",
      label: CATEGORY_LABELS.deal,
    },
    {
      id: "won-customer-type",
      title: "Bookings won by customer type",
      label: CATEGORY_LABELS.customer,
    },
  ].flatMap(({ id, title, label }) => {
    const index = categoryColumn(report, label);
    if (index < 0) {
      notices.push(
        `${title} is unavailable: the pipeline report does not include this category column.`,
      );
      return [];
    }
    const labels = [
      ...new Set(
        report.rows
          .filter((row) =>
            WON_STAGE.test(row.cells[stageIndex]?.label.trim() ?? ""),
          )
          .map((row) => categoryLabel(row, index) || "Unknown"),
      ),
    ].sort();
    const keys = new Map(labels.map((name, i) => [name, `group-${i}`]));
    const chart = monthlyChart(closedRange, {
      id,
      title,
      description: `Won opportunity amounts by ${report.columns[index].label} and selected date.`,
      unit: "currency",
      stacked: true,
      series: labels.map((name) => ({ key: keys.get(name)!, label: name })),
    });
    charts.push(chart);
    return [{ index, keys, chart }];
  });
  let missingDates = 0;
  let missingAmounts = 0;
  let missingExpected = 0;
  const currencies = new Set<string>();
  for (const row of report.rows) {
    const rawDate = row.cells[dateIndex]?.value;
    const timestamp =
      typeof rawDate === "number"
        ? rawDate
        : typeof rawDate === "string"
          ? Date.parse(rawDate)
          : NaN;
    if (!Number.isFinite(timestamp)) {
      missingDates++;
      continue;
    }
    const month = new Date(timestamp).toISOString().slice(0, 7) + "-01";
    const amountCell = row.cells[amountIndex];
    const amount = amountCell?.value;
    if (typeof amount !== "number") {
      missingAmounts++;
      continue;
    }
    if (amountCell.currencyCode) currencies.add(amountCell.currencyCode);
    const stage = row.cells[stageIndex]?.label.trim() || "Unknown";
    const won = WON_STAGE.test(stage);
    const expected = row.cells[expectedIndex]?.value;
    const probability = row.cells[probabilityIndex]?.value;
    const weighted =
      typeof expected === "number"
        ? expected
        : typeof probability === "number"
          ? (amount * probability) / 100
          : undefined;
    if (!won && weighted === undefined) missingExpected++;
    const inRange = (bounds: DashboardDateRange) =>
      timestamp >= Date.parse(bounds.startDate) &&
      timestamp < Date.parse(bounds.endDate);
    if (won && inRange(closedRange)) {
      const bucket = charts[0].months.find((m) => m.month === month);
      if (bucket) bucket.values.amount = (bucket.values.amount ?? 0) + amount;
      breakdowns.forEach(({ index, keys, chart }) => {
        const group = chart.months.find((m) => m.month === month);
        const key = keys.get(categoryLabel(row, index) || "Unknown")!;
        if (group) group.values[key] = (group.values[key] ?? 0) + amount;
      });
    } else if (!won && inRange(range)) {
      const expectedMonth = charts[1].months.find((m) => m.month === month);
      if (expectedMonth && weighted !== undefined)
        expectedMonth.values.amount =
          (expectedMonth.values.amount ?? 0) + weighted;
      const stageMonth = charts[2].months.find((m) => m.month === month);
      const key = stageKeys.get(stage)!;
      if (stageMonth)
        stageMonth.values[key] = (stageMonth.values[key] ?? 0) + amount;
    }
  }
  if (missingDates)
    notices.push(
      `${missingDates} opportunities have no usable date and are excluded.`,
    );
  if (missingAmounts)
    notices.push(
      `${missingAmounts} opportunities have no amount and are excluded.`,
    );
  if (missingExpected)
    notices.push(
      `${missingExpected} opportunities have neither Expected Revenue nor Probability and are excluded from expected bookings.`,
    );
  if (currencies.size > 1 || [...currencies].some((code) => code !== "USD"))
    notices.push(
      `Source currencies: ${[...currencies].join(", ")}. No currency conversion is applied.`,
    );
  charts.forEach((chart) =>
    chart.months.forEach((month) =>
      Object.keys(month.values).forEach((key) => {
        month.values[key] = Math.round((month.values[key] ?? 0) * 100) / 100;
      }),
    ),
  );
  return { charts, notices };
}
