import {
  BadGatewayException,
  BadRequestException,
  Injectable,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { compile } from "html-to-text";
import {
  SalesCellDto,
  SalesColumnDto,
  SalesReportDto,
  SalesReportQueryDto,
  SalesRowDto,
  SalesSummaryDto,
  SalesSummaryGroupDto,
} from "./sales-reports.dto";
import {
  SalesforceGrouping,
  SalesforceReport,
  SalesforceReportsClient,
} from "./salesforce-reports.client";

const CACHE_MS = 60000;
const REFRESH_COOLDOWN_MS = 5000;
/** Column types that can carry a pipeline or revenue amount worth totalling. */
const AMOUNT_TYPES = ["currency", "double"];
/** Column types that a date range can be applied to. */
const DATE_TYPES = ["date", "datetime"];
/** Column types that describe a category, such as a pipeline stage. */
const CATEGORY_TYPES = ["picklist", "multipicklist", "combobox", "boolean"];
/** Keeps a breakdown readable and the response bounded for very wide reports. */
const MAX_SUMMARY_GROUPS = 3;
const MAX_SUMMARY_BUCKETS = 25;
const htmlToPlainText = compile({
  wordwrap: false,
  selectors: [
    {
      selector: "img",
      options: {
        /** Omits image source paths, keeping only parsed alt text. Returns an empty path; does not throw. */
        pathRewrite: () => "",
      },
    },
    { selector: "a", options: { ignoreHref: true } },
  ],
});

/**
 * Normalizes live Salesforce report data for both Sales and WIN. Maintains one
 * short-lived memory snapshot, never a database copy, and coalesces refreshes.
 */
@Injectable()
export class SalesReportsService {
  private snapshot?: SalesReportDto;
  private loading?: Promise<SalesReportDto>;
  private lastFailure?: { error: unknown; time: number };

  /** @param client Reusable Analytics client. @param config Server report selection. Does not throw. */
  constructor(
    private readonly client: SalesforceReportsClient,
    private readonly config: ConfigService,
  ) {}

  /**
   * Converts a Salesforce cell into safe plain text and a sortable scalar.
   * @param cell Raw detail cell, including Salesforce currency objects when present.
   * @param dataType Report column type; HTML formulas are projected to plain text.
   * @returns Display label, raw scalar and optional currency code; nulls remain null.
   * @throws Does not throw for missing cells.
   */
  private cell(
    cell: { label?: string; value?: unknown } | undefined,
    dataType = "string",
  ): SalesCellDto {
    const raw = cell?.value;
    const currency =
      raw && typeof raw === "object" && "amount" in raw
        ? (raw as {
            amount: unknown;
            currencyCode?: unknown;
            currency?: unknown;
          })
        : undefined;
    const scalar = currency ? currency.amount : raw;
    const value =
      typeof scalar === "string" ||
      typeof scalar === "boolean" ||
      (typeof scalar === "number" && Number.isFinite(scalar))
        ? scalar
        : null;
    const label =
      typeof cell?.label === "string"
        ? cell.label
        : value === null
          ? ""
          : String(value);
    const plainLabel = dataType === "html" ? this.htmlLabel(label) : label;
    const currencyCode = currency?.currencyCode ?? currency?.currency;
    return {
      label: plainLabel,
      value: dataType === "html" ? plainLabel : value,
      ...(typeof currencyCode === "string" ? { currencyCode } : {}),
    };
  }

  /**
   * Converts Salesforce HTML formula labels to text, preserving image alt text.
   * This is a text projection, not an HTML sanitizer: clients must render the result as text.
   * @param html Formula label, such as the Forecast Alert image.
   * @returns Readable text without fetching protected images or executing markup.
   * @throws Does not throw for malformed markup; the parser handles incomplete HTML.
   */
  private htmlLabel(html: string): string {
    return htmlToPlainText(html).trim();
  }

  /**
   * Indexes grouping paths so a detail bucket retains dimensions omitted from detailColumns.
   * @param groups Row or column axis groupings returned by Salesforce.
   * @param ancestors Parent grouping cells, used during recursion.
   * @param result Accumulator keyed by the exact Salesforce grouping key.
   * @returns Every grouping key mapped to its ordered ancestor and current cells.
   * @throws Does not throw for an empty axis.
   */
  private groupingPaths(
    groups: SalesforceGrouping[],
    ancestors: SalesCellDto[] = [],
    result = new Map<string, SalesCellDto[]>(),
  ): Map<string, SalesCellDto[]> {
    for (const group of groups) {
      const path = [...ancestors, this.cell(group)];
      result.set(group.key, path);
      this.groupingPaths(group.groupings ?? [], path, result);
    }
    return result;
  }

  /**
   * Flattens detail-bearing fact-map buckets, ignoring aggregate-only totals.
   * @param report Salesforce tabular, summary or matrix report with detail rows.
   * @returns A schema-driven snapshot preserving column order, labels and completeness.
   * @throws BadGatewayException for malformed or detail-disabled reports.
   */
  private normalize(report: SalesforceReport): SalesReportDto {
    const ids = report?.reportMetadata?.detailColumns;
    const info = report?.reportExtendedMetadata?.detailColumnInfo;
    if (
      !Array.isArray(ids) ||
      !ids.length ||
      !ids.every((id) => typeof id === "string" && info?.[id]) ||
      !report.factMap ||
      typeof report.factMap !== "object" ||
      report.hasDetailRows === false ||
      report.reportMetadata.reportFormat === "MULTI_BLOCK"
    ) {
      throw new BadGatewayException(
        "Salesforce report must provide a supported report with detail rows.",
      );
    }
    const details = ids.map((id) => ({
      id,
      label: info[id].label || id,
      dataType: info[id].dataType || "string",
    }));
    const groupingInfo = report.reportExtendedMetadata.groupingColumnInfo ?? {};
    const groupingColumns = [
      ...(report.reportMetadata.groupingsDown ?? []).map((group, index) => ({
        ...group,
        index,
        axis: "down",
      })),
      ...(report.reportMetadata.groupingsAcross ?? []).map((group, index) => ({
        ...group,
        index,
        axis: "across",
      })),
    ].filter((group) => !ids.includes(group.name));
    const columns = [
      ...groupingColumns.map((group) => ({
        id: group.name,
        label: groupingInfo[group.name]?.label ?? group.name,
        dataType: groupingInfo[group.name]?.dataType ?? "string",
      })),
      ...details,
    ];
    const down = this.groupingPaths(report.groupingsDown?.groupings ?? []);
    const across = this.groupingPaths(report.groupingsAcross?.groupings ?? []);
    const rows: SalesRowDto[] = [];
    for (const [key, bucket] of Object.entries(report.factMap)) {
      if (
        !bucket ||
        (bucket.rows !== undefined && !Array.isArray(bucket.rows))
      ) {
        throw new BadGatewayException(
          "Salesforce returned invalid report rows.",
        );
      }
      (bucket.rows ?? []).forEach((row, index) => {
        if (
          !Array.isArray(row.dataCells) ||
          row.dataCells.length !== details.length
        ) {
          throw new BadGatewayException(
            "Salesforce returned invalid report columns.",
          );
        }
        const [downKey, acrossKey] = key.split("!");
        const groupCells = groupingColumns.map(
          (group) =>
            (group.axis === "down"
              ? down.get(downKey)
              : across.get(acrossKey))?.[group.index] ?? this.cell(undefined),
        );
        rows.push({
          id: `${key}:${index}`,
          cells: [
            ...groupCells,
            ...row.dataCells.map((cell, index) =>
              this.cell(cell, details[index].dataType),
            ),
          ],
        });
      });
    }
    return {
      reportId: report.reportMetadata.id,
      reportName: report.reportMetadata.name,
      columns,
      rows,
      allData: report.allData === true,
      sourceRowCount: rows.length,
      total: rows.length,
      page: 1,
      perPage: 25,
      totalPages: Math.ceil(rows.length / 25),
      refreshedAt: new Date().toISOString(),
      refreshAfterSeconds: CACHE_MS / 1000,
      summary: this.summarize(rows, columns),
    };
  }

  /**
   * Reads the calendar day a date cell falls on, using the underlying Salesforce
   * value rather than its locale-formatted label.
   * @param cell Cell taken from a column whose dataType is date or datetime.
   * @returns The YYYY-MM-DD day, or undefined when the cell holds no usable date.
   * @throws Does not throw for null, blank or unparseable values.
   */
  private day(cell: SalesCellDto | undefined): string | undefined {
    const raw = cell?.value;
    if (typeof raw === "number" && Number.isFinite(raw)) {
      return new Date(raw).toISOString().slice(0, 10);
    }
    // Salesforce emits date and datetime values as ISO 8601; a datetime keeps
    // the report's own offset, so slicing matches the day the report displays.
    return typeof raw === "string" && /^\d{4}-\d{2}-\d{2}/.test(raw)
      ? raw.slice(0, 10)
      : undefined;
  }

  /**
   * Totals one numeric column across matching rows, tracking currency agreement.
   * @param rows Matching rows, before pagination.
   * @param column The numeric column being totalled.
   * @param index The column's position in every row's cells.
   * @returns The total, the number of contributing rows and a shared currency code when unanimous.
   * @throws Does not throw for null or non-numeric cells, which are skipped.
   */
  private amount(
    rows: SalesRowDto[],
    column: SalesColumnDto,
    index: number,
  ): SalesSummaryDto["amounts"][number] {
    let total = 0;
    let count = 0;
    let currencyCode: string | undefined;
    let mixed = false;
    for (const row of rows) {
      const cell = row.cells[index];
      if (typeof cell?.value !== "number" || !Number.isFinite(cell.value))
        continue;
      total += cell.value;
      count += 1;
      if (cell.currencyCode === undefined) continue;
      if (currencyCode === undefined) currencyCode = cell.currencyCode;
      else if (currencyCode !== cell.currencyCode) mixed = true;
    }
    return {
      columnId: column.id,
      label: column.label,
      // Rounded to cents: repeated float addition otherwise leaks artifacts
      // such as 0.30000000000000004 into displayed currency totals.
      total: Math.round(total * 100) / 100,
      count,
      // A mixed-currency total is still the report's own sum, but it must not
      // be labelled with a currency the amounts do not share.
      ...(currencyCode !== undefined && !mixed ? { currencyCode } : {}),
    };
  }

  /**
   * Breaks a category column into its distinct values with counts and amounts.
   * Every amount column is totalled inside each bucket, not only the primary one,
   * so a dashboard can show a stage's Amount beside its Expected Revenue.
   * @param rows Matching rows, before pagination.
   * @param column The category column being broken down.
   * @param index The column's position in every row's cells.
   * @param amounts Every numeric column and its position; the first one is the primary total.
   * @returns Buckets ordered by primary total then count, capped with an explicit remainder.
   * @throws Does not throw for blank category labels, which form their own bucket.
   */
  private group(
    rows: SalesRowDto[],
    column: SalesColumnDto,
    index: number,
    amounts: Array<{ column: SalesColumnDto; index: number }>,
  ): SalesSummaryGroupDto {
    const buckets = new Map<string, SalesRowDto[]>();
    for (const row of rows) {
      const label = row.cells[index]?.label ?? "";
      const bucket = buckets.get(label) ?? [];
      bucket.push(row);
      buckets.set(label, bucket);
    }
    const primary = amounts[0];
    const ordered = [...buckets.entries()]
      .map(([label, bucketRows]) => {
        const totals = amounts.map((amount) =>
          this.amount(bucketRows, amount.column, amount.index),
        );
        return {
          label,
          count: bucketRows.length,
          total: totals[0]?.total ?? 0,
          amounts: totals,
        };
      })
      .sort(
        (left, right) =>
          right.total - left.total ||
          right.count - left.count ||
          left.label.localeCompare(right.label, "en", { sensitivity: "base" }),
      );
    // The group currency describes the primary total across every bucket, so it
    // is omitted as soon as any contributing row declares a different currency.
    const currencyCode = primary
      ? this.amount(rows, primary.column, primary.index).currencyCode
      : undefined;
    return {
      columnId: column.id,
      label: column.label,
      ...(primary ? { amountColumnId: primary.column.id } : {}),
      ...(currencyCode !== undefined ? { currencyCode } : {}),
      buckets: ordered.slice(0, MAX_SUMMARY_BUCKETS),
      otherBuckets: Math.max(0, ordered.length - MAX_SUMMARY_BUCKETS),
    };
  }

  /**
   * Aggregates every matching row so counts and totals describe the filtered
   * result rather than the page currently being displayed.
   * @param rows Matching rows, before pagination.
   * @param columns The snapshot's column schema, in cell order.
   * @returns Record count, per-column amount totals and category breakdowns.
   * @throws Does not throw for reports without numeric or category columns.
   */
  private summarize(
    rows: SalesRowDto[],
    columns: SalesColumnDto[],
  ): SalesSummaryDto {
    const amountIndexes = columns
      .map((column, index) => ({ column, index }))
      .filter(({ column }) => AMOUNT_TYPES.includes(column.dataType));
    return {
      recordCount: rows.length,
      amounts: amountIndexes.map(({ column, index }) =>
        this.amount(rows, column, index),
      ),
      groups: columns
        .map((column, index) => ({ column, index }))
        .filter(({ column }) => CATEGORY_TYPES.includes(column.dataType))
        .slice(0, MAX_SUMMARY_GROUPS)
        .map(({ column, index }) =>
          this.group(rows, column, index, amountIndexes),
        ),
    };
  }

  /**
   * Loads or reuses the current snapshot. Failed refreshes never relabel stale data as fresh.
   * @param refresh Whether to bypass the regular TTL, subject to a five-second cooldown.
   * @returns A report fetched within the cache interval.
   * @throws The sanitized client/normalization error; failures are throttled for five seconds.
   */
  private async getSnapshot(refresh: boolean): Promise<SalesReportDto> {
    if (this.loading) return this.loading;
    if (
      this.lastFailure &&
      Date.now() - this.lastFailure.time < REFRESH_COOLDOWN_MS
    )
      throw this.lastFailure.error;
    if (
      this.snapshot &&
      Date.now() - Date.parse(this.snapshot.refreshedAt) <
        (refresh ? REFRESH_COOLDOWN_MS : CACHE_MS)
    )
      return this.snapshot;
    const reportId = this.config.get<string>(
      "SALESFORCE_SALES_REPORT_ID",
      "00O1K00000A7UGDUA3",
    );
    this.loading = this.client
      .runReport(reportId)
      .then((report) => {
        this.snapshot = this.normalize(report);
        this.lastFailure = undefined;
        return this.snapshot;
      })
      .catch((error: unknown) => {
        this.lastFailure = { error, time: Date.now() };
        throw error;
      });
    try {
      return await this.loading;
    } finally {
      this.loading = undefined;
    }
  }

  /**
   * Filters, stably sorts and paginates a live report snapshot for UI or WIN callers.
   * @param query Validated page, search, column filter, drilldown, date range, sorting and refresh options.
   * @returns Metadata, aggregates over the filtered set and one page; total is the returned-row count after any drilldown.
   * @throws BadRequestException for unknown columns, incomplete filters or an inverted date range; upstream exceptions propagate.
   */
  async getReport(query: SalesReportQueryDto): Promise<SalesReportDto> {
    if (!!query.filterColumn !== !!query.filterValue) {
      throw new BadRequestException(
        "filterColumn and filterValue must be supplied together.",
      );
    }
    if (!!query.drilldownColumn !== !!query.drilldownValue) {
      throw new BadRequestException(
        "drilldownColumn and drilldownValue must be supplied together.",
      );
    }
    if ((query.dateFrom || query.dateTo) && !query.dateColumn) {
      throw new BadRequestException(
        "dateColumn must be supplied with dateFrom or dateTo.",
      );
    }
    if (query.dateFrom && query.dateTo && query.dateFrom > query.dateTo) {
      throw new BadRequestException("dateFrom must not be after dateTo.");
    }
    const report = await this.getSnapshot(query.refresh);
    const sortIndex = report.columns.findIndex(
      (column) => column.id === query.sortBy,
    );
    const filterIndex = report.columns.findIndex(
      (column) => column.id === query.filterColumn,
    );
    const dateIndex = report.columns.findIndex(
      (column) => column.id === query.dateColumn,
    );
    const drilldownIndex = report.columns.findIndex(
      (column) => column.id === query.drilldownColumn,
    );
    if (
      (query.sortBy && sortIndex < 0) ||
      (query.filterColumn && filterIndex < 0) ||
      (query.drilldownColumn && drilldownIndex < 0) ||
      (query.dateColumn && dateIndex < 0)
    ) {
      throw new BadRequestException(
        "Unknown report column. Use a column ID from the report response.",
      );
    }
    if (
      dateIndex >= 0 &&
      !DATE_TYPES.includes(report.columns[dateIndex].dataType)
    ) {
      throw new BadRequestException(
        "dateColumn must reference a date or datetime column.",
      );
    }
    const search = query.search?.trim().toLowerCase();
    const filter = query.filterValue?.trim().toLowerCase();
    const drilldown = query.drilldownValue?.trim().toLowerCase();
    // A range only applies once a bound is given, so selecting a date field
    // alone leaves the result set untouched.
    const ranged = dateIndex >= 0 && !!(query.dateFrom || query.dateTo);
    const matched = report.rows.filter((row) => {
      if (ranged) {
        // Rows without a usable date cannot satisfy a range, so they drop out
        // rather than silently inflating counts and totals.
        const day = this.day(row.cells[dateIndex]);
        if (
          !day ||
          (query.dateFrom && day < query.dateFrom) ||
          (query.dateTo && day > query.dateTo)
        ) {
          return false;
        }
      }
      return (
        (!search ||
          row.cells.some((cell) =>
            cell.label.toLowerCase().includes(search),
          )) &&
        (!filter || row.cells[filterIndex].label.toLowerCase().includes(filter))
      );
    });
    // The summary covers every matching row, so a drilldown can narrow the page
    // to one bucket while the breakdown it was clicked in stays on screen.
    const summary = this.summarize(matched, report.columns);
    const rows = drilldown
      ? matched.filter(
          (row) =>
            row.cells[drilldownIndex].label.trim().toLowerCase() === drilldown,
        )
      : matched;
    if (sortIndex >= 0) {
      rows.sort((left, right) => {
        const a = left.cells[sortIndex];
        const b = right.cells[sortIndex];
        // Empty cells sort last in both directions. Array.sort is stable in supported Node versions.
        if (a.value === null || b.value === null)
          return a.value === b.value ? 0 : a.value === null ? 1 : -1;
        const useRawValue = ["date", "datetime", "boolean"].includes(
          report.columns[sortIndex].dataType,
        );
        const comparison =
          typeof a.value === "number" && typeof b.value === "number"
            ? a.value - b.value
            : String(useRawValue ? a.value : a.label).localeCompare(
                String(useRawValue ? b.value : b.label),
                "en",
                {
                  numeric: true,
                  sensitivity: "base",
                },
              );
        return comparison * (query.sortOrder === "desc" ? -1 : 1);
      });
    }
    const totalPages = Math.ceil(rows.length / query.perPage);
    const page = Math.min(query.page, Math.max(1, totalPages));
    return {
      ...report,
      rows: rows.slice((page - 1) * query.perPage, page * query.perPage),
      total: rows.length,
      totalPages,
      page,
      perPage: query.perPage,
      summary,
    };
  }
}
