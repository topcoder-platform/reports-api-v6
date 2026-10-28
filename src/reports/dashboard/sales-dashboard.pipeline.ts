import { BadGatewayException } from "@nestjs/common";
import { customerTypeLabel } from "../sales/sales-category.utils";
import { SalesRowDto, SalesReportDto } from "../sales/sales-reports.dto";
import { DashboardDateRange } from "./dashboard-reports.service";
import {
  CATEGORY_LABELS,
  DASHBOARD_GROUPS,
  categoryColumn,
  categoryLabel,
} from "./sales-dashboard.categories";
import {
  SalesDashboardChartDto,
  SalesDashboardDto,
  SalesDashboardGroupBy,
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
 * @param groupBy Optional dimension for all won/open/expected series; absent retains legacy charts.
 * @returns Zero-filled charts and explicit incomplete/missing-data notices.
 * @throws BadGatewayException if the source lacks amount, stage or the selected date field.
 */
export function pipelineCharts(
  report: SalesReportDto,
  range: DashboardDateRange,
  closedRange: DashboardDateRange,
  dateBasis: "close" | "created",
  groupBy?: SalesDashboardGroupBy,
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
  const group = groupBy ? DASHBOARD_GROUPS[groupBy] : undefined;
  const groupIndex = group ? categoryColumn(report, group.pattern) : stageIndex;
  if (groupIndex < 0)
    return {
      charts: [],
      notices: [
        `The ${group?.label} breakdown is unavailable: the pipeline report does not include this category column.`,
      ],
    };
  /** @param row Source opportunity. @returns Selected category with canonical customer-type spelling or Unknown. Does not throw. */
  const groupLabel = (row: SalesRowDto): string => {
    const label = categoryLabel(row, groupIndex) || "Unknown";
    return groupBy === SalesDashboardGroupBy.CustomerType
      ? customerTypeLabel(label)
      : label;
  };
  /** @param won Selects won or open opportunities. @returns Stable series keys for every category. Does not throw. */
  const groupKeys = (won: boolean): Map<string, string> =>
    new Map(
      [
        ...new Set(
          report.rows
            .filter(
              (row) =>
                WON_STAGE.test(row.cells[stageIndex]?.label.trim() ?? "") ===
                won,
            )
            .map(groupLabel),
        ),
      ]
        .sort()
        .map((label, i) => [label, `${groupBy ? "group" : "stage"}-${i}`]),
    );
  const wonKeys = groupKeys(true);
  const openKeys = groupKeys(false);
  /** @param keys Category-to-key map. @returns Chart series definitions. Does not throw. */
  const series = (keys: Map<string, string>) =>
    [...keys].map(([label, key]) => ({ key, label }));
  const charts = [
    monthlyChart(closedRange, {
      id: "closed-won",
      title: "Won - SOW Signed bookings",
      description:
        "Amount for won opportunities (the Won - SOW Signed stage), by selected date.",
      unit: "currency",
      stacked: !!groupBy,
      series: groupBy
        ? series(wonKeys)
        : [{ key: "amount", label: "Bookings won" }],
    }),
    monthlyChart(range, {
      id: "expected-revenue",
      title: "Expected bookings",
      description:
        "Open opportunities only: Expected Revenue, falling back to Amount × Probability. Won bookings are excluded.",
      unit: "currency",
      stacked: !!groupBy,
      series: groupBy
        ? series(openKeys)
        : [{ key: "amount", label: "Expected bookings" }],
    }),
    monthlyChart(range, {
      id: "pipeline-stage",
      title: group ? "Pipeline" : "Pipeline by stage",
      description: `Open opportunity amount split by ${group?.label ?? "stage"} and month, excluding won bookings.`,
      unit: "currency",
      stacked: true,
      series: series(openKeys),
    }),
  ];
  const notices = report.allData
    ? []
    : [
        "Salesforce returned an incomplete report. These charts show only the returned rows.",
      ];
  if (group)
    charts.forEach((chart) => {
      chart.title += ` by ${group.label}`;
      chart.description += ` Breakdown: ${group.label}.`;
    });
  const breakdowns = (
    groupBy
      ? []
      : [
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
        ]
  ).flatMap(({ id, title, label }) => {
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
      const wonKey = groupBy ? wonKeys.get(groupLabel(row))! : "amount";
      if (bucket) bucket.values[wonKey] = (bucket.values[wonKey] ?? 0) + amount;
      breakdowns.forEach(({ index, keys, chart }) => {
        const group = chart.months.find((m) => m.month === month);
        const key = keys.get(categoryLabel(row, index) || "Unknown")!;
        if (group) group.values[key] = (group.values[key] ?? 0) + amount;
      });
    } else if (!won && inRange(range)) {
      const expectedMonth = charts[1].months.find((m) => m.month === month);
      const expectedKey = groupBy ? openKeys.get(groupLabel(row))! : "amount";
      if (expectedMonth && weighted !== undefined)
        expectedMonth.values[expectedKey] =
          (expectedMonth.values[expectedKey] ?? 0) + weighted;
      const stageMonth = charts[2].months.find((m) => m.month === month);
      const key = openKeys.get(groupLabel(row))!;
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
