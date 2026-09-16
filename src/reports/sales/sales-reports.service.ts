import {
  BadGatewayException,
  BadRequestException,
  Injectable,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { compile } from "html-to-text";
import {
  SalesCellDto,
  SalesReportDto,
  SalesReportQueryDto,
  SalesRowDto,
} from "./sales-reports.dto";
import {
  SalesforceGrouping,
  SalesforceReport,
  SalesforceReportsClient,
} from "./salesforce-reports.client";

const CACHE_MS = 60000;
const REFRESH_COOLDOWN_MS = 5000;
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
   * @param query Validated page, search, column filter, sorting and refresh options.
   * @returns Metadata and one page; total is explicitly the matched received-row count.
   * @throws BadRequestException for unknown columns or incomplete filters; upstream exceptions propagate.
   */
  async getReport(query: SalesReportQueryDto): Promise<SalesReportDto> {
    if (!!query.filterColumn !== !!query.filterValue) {
      throw new BadRequestException(
        "filterColumn and filterValue must be supplied together.",
      );
    }
    const report = await this.getSnapshot(query.refresh);
    const sortIndex = report.columns.findIndex(
      (column) => column.id === query.sortBy,
    );
    const filterIndex = report.columns.findIndex(
      (column) => column.id === query.filterColumn,
    );
    if (
      (query.sortBy && sortIndex < 0) ||
      (query.filterColumn && filterIndex < 0)
    ) {
      throw new BadRequestException(
        "Unknown report column. Use a column ID from the report response.",
      );
    }
    const search = query.search?.trim().toLowerCase();
    const filter = query.filterValue?.trim().toLowerCase();
    const rows = report.rows.filter(
      (row) =>
        (!search ||
          row.cells.some((cell) =>
            cell.label.toLowerCase().includes(search),
          )) &&
        (!filter ||
          row.cells[filterIndex].label.toLowerCase().includes(filter)),
    );
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
    };
  }
}
