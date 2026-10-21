import { BadGatewayException } from "@nestjs/common";
import { SalesReportDto } from "../sales/sales-reports.dto";
import { DashboardDateRange } from "./dashboard-reports.service";
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
 * Aggregates all Salesforce snapshot rows into the four pipeline charts from the executive overview.
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
      report.rows.map((row) => row.cells[stageIndex]?.label || "Unknown"),
    ),
  ].sort();
  const stageKeys = new Map(stages.map((label, i) => [label, `stage-${i}`]));
  const charts = [
    monthlyChart(range, {
      id: "opportunity-size",
      title: "Total opportunity size",
      description: "Opportunity amount by month.",
      unit: "currency",
      stacked: false,
      series: [{ key: "amount", label: "Amount" }],
    }),
    monthlyChart(closedRange, {
      id: "closed-won",
      title: "Closed Won revenue",
      description:
        "Amount for won opportunities (the Won - SOW Signed stage), by selected date.",
      unit: "currency",
      stacked: false,
      series: [{ key: "amount", label: "Closed Won" }],
    }),
    monthlyChart(range, {
      id: "expected-revenue",
      title: "Expected revenue",
      description: "Expected Revenue, falling back to Amount × Probability.",
      unit: "currency",
      stacked: false,
      series: [{ key: "amount", label: "Expected revenue" }],
    }),
    monthlyChart(range, {
      id: "pipeline-stage",
      title: "Pipeline by stage",
      description: "Opportunity amount split by stage and month.",
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
    const stage = row.cells[stageIndex]?.label || "Unknown";
    const expected = row.cells[expectedIndex]?.value;
    const probability = row.cells[probabilityIndex]?.value;
    const weighted =
      typeof expected === "number"
        ? expected
        : typeof probability === "number"
          ? (amount * probability) / 100
          : undefined;
    if (weighted === undefined) missingExpected++;
    charts.forEach((chart, i) => {
      const bounds = i === 1 ? closedRange : range;
      if (
        timestamp < Date.parse(bounds.startDate) ||
        timestamp >= Date.parse(bounds.endDate)
      )
        return;
      const bucket = chart.months.find((m) => m.month === month);
      if (
        !bucket ||
        (i === 1 && !WON_STAGE.test(stage.trim()))
      )
        return;
      const key = i === 3 ? stageKeys.get(stage)! : "amount";
      if (i === 2 && weighted === undefined) return;
      bucket.values[key] =
        (bucket.values[key] ?? 0) + (i === 2 ? weighted! : amount);
    });
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
      `${missingExpected} opportunities have neither Expected Revenue nor Probability and are excluded from expected revenue.`,
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
