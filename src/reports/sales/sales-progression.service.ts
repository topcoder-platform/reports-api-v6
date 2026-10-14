import {
  BadGatewayException,
  BadRequestException,
  Injectable,
  ServiceUnavailableException,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import {
  SalesMovementDto,
  SalesProgressionDto,
  SalesProgressionQueryDto,
  SalesTransitionDto,
} from "./sales-progression.dto";
import {
  SalesforceReport,
  SalesforceReportFilter,
  SalesforceReportOverrides,
  SalesforceReportsClient,
} from "./salesforce-reports.client";

/** Exact report column IDs and stage values are deployment configuration, never supplied by callers. */
interface HistoryConfig {
  reportId: string;
  dateColumn: string;
  opportunityIdColumn: string;
  fromStageColumn: string;
  toStageColumn: string;
  openStages: string[];
  wonStages: string[];
  otherStages: string[];
  timeZone: string;
}

const CACHE_MS = 60000;
const MAX_CACHE_ENTRIES = 50;
const MAX_CONCURRENT_QUERIES = 5;

/**
 * Runs two summary-only Opportunity History reports with execution filters in Salesforce.
 * Grand totals count distinct opportunities across every qualifying transition, avoiding
 * double counting across groups. Keeps only bounded, one-minute response caches in memory.
 */
@Injectable()
export class SalesProgressionService {
  private readonly cache = new Map<
    string,
    { expires: number; result?: SalesProgressionDto; error?: Error }
  >();
  private readonly pending = new Map<string, Promise<SalesProgressionDto>>();

  /** @param client Shared authenticated Analytics transport. @param config Server settings. Does not throw. */
  constructor(
    private readonly client: SalesforceReportsClient,
    private readonly config: ConfigService,
  ) {}

  /**
   * Loads the explicit pipeline ordering and report identifiers without guessing org-specific values.
   * @returns Validated history configuration. @throws ServiceUnavailableException for missing/invalid settings.
   */
  private settings(): HistoryConfig {
    try {
      const config = JSON.parse(
        this.config.get<string>("SALESFORCE_SALES_HISTORY_CONFIG", ""),
      ) as HistoryConfig;
      const fields = [
        config.dateColumn,
        config.opportunityIdColumn,
        config.fromStageColumn,
        config.toStageColumn,
      ];
      if (
        !/^00O[a-zA-Z0-9]{12}(?:[a-zA-Z0-9]{3})?$/.test(config.reportId) ||
        !fields.every(
          (field) =>
            typeof field === "string" && /^[a-zA-Z0-9_.]+$/.test(field),
        ) ||
        new Set(fields).size !== fields.length
      )
        throw new Error();
      config.otherStages ??= [];
      if (
        ![config.openStages, config.wonStages, config.otherStages].every(
          Array.isArray,
        ) ||
        !config.openStages.length ||
        !config.wonStages.length
      )
        throw new Error();
      const stages = [
        ...config.openStages,
        ...config.wonStages,
        ...config.otherStages,
      ];
      if (
        stages.length > 30 ||
        new Set(stages).size !== stages.length ||
        !stages.every(
          (stage) =>
            typeof stage === "string" &&
            stage.trim() === stage &&
            stage.length > 0 &&
            stage.length <= 100 &&
            !/[,"\r\n]/.test(stage),
        )
      )
        throw new Error();
      if (typeof config.timeZone !== "string" || !config.timeZone)
        throw new Error();
      new Intl.DateTimeFormat("en", { timeZone: config.timeZone }).format();
      return config;
    } catch {
      throw new ServiceUnavailableException(
        "Sales progression reporting is not configured correctly.",
      );
    }
  }

  /**
   * Gets a period-specific response, coalescing requests and throttling repeat failures.
   * @param query Calendar range (maximum 366 inclusive days) and optional exact stage filters.
   * @returns Complete summaries with their applied filters and reporting timezone.
   * @throws BadRequestException for invalid periods/stages; sanitized configuration/upstream errors otherwise.
   */
  async getReport(
    query: SalesProgressionQueryDto,
  ): Promise<SalesProgressionDto> {
    const config = this.settings();
    const days =
      (Date.parse(query.dateTo) - Date.parse(query.dateFrom)) / 86400000;
    if (!Number.isFinite(days) || days < 0 || days >= 366) {
      throw new BadRequestException(
        "Choose a valid period of no more than 366 days.",
      );
    }
    const stages = [
      ...config.openStages,
      ...config.wonStages,
      ...config.otherStages,
    ];
    for (const stage of [query.fromStage, query.toStage]) {
      if (stage !== undefined && !stages.includes(stage))
        throw new BadRequestException("Unknown history stage filter.");
    }
    const key = JSON.stringify([
      config,
      query.dateFrom,
      query.dateTo,
      query.fromStage,
      query.toStage,
    ]);
    const cached = this.cache.get(key);
    if (cached && cached.expires > Date.now()) {
      if (cached.error) throw cached.error;
      return cached.result!;
    }
    const active = this.pending.get(key);
    if (active) return active;
    if (this.pending.size >= MAX_CONCURRENT_QUERIES)
      throw new ServiceUnavailableException(
        "Sales progression is busy. Please try again shortly.",
      );
    const request = this.load(config, query);
    this.pending.set(key, request);
    try {
      const result = await request;
      this.remember(key, { result, expires: Date.now() + CACHE_MS });
      return result;
    } catch (error) {
      const failure =
        error instanceof Error
          ? error
          : new BadGatewayException("Salesforce progression report failed.");
      this.remember(key, { error: failure, expires: Date.now() + CACHE_MS });
      throw failure;
    } finally {
      this.pending.delete(key);
    }
  }

  /** @param key Filter-specific key. @param entry Result/failure with expiry. @returns Nothing; evicts oldest entries. Does not throw. */
  private remember(
    key: string,
    entry: { expires: number; result?: SalesProgressionDto; error?: Error },
  ): void {
    this.cache.delete(key);
    this.cache.set(key, entry);
    if (this.cache.size > MAX_CACHE_ENTRIES)
      this.cache.delete(this.cache.keys().next().value);
  }

  /**
   * Builds report execution filters while preserving the saved report's scope and filter logic.
   * @param config Exact column IDs and stage order. @param query Applied period/stages.
   * @param saved Saved report metadata. @param movement Movement predicate to calculate in Salesforce.
   * @returns Metadata overrides; no saved report mutation. @throws ServiceUnavailableException if filters exceed Salesforce's limit.
   */
  private overrides(
    config: HistoryConfig,
    query: SalesProgressionQueryDto,
    saved: SalesforceReport["reportMetadata"],
    movement: "forward" | "won",
  ): SalesforceReportOverrides {
    const filters: SalesforceReportFilter[] = [...(saved.reportFilters ?? [])];
    const clauses: string[] = [];
    if (filters.length)
      clauses.push(
        `(${saved.reportBooleanFilter || filters.map((_, i) => i + 1).join(" AND ")})`,
      );
    /** @param column Report column. @param operator Salesforce operator. @param value Exact picklist value(s). @returns Filter reference. Does not throw. */
    const add = (column: string, operator: string, value: string): number =>
      filters.push({ column, operator, value });
    if (query.fromStage)
      clauses.push(
        String(add(config.fromStageColumn, "equals", query.fromStage)),
      );
    if (query.toStage)
      clauses.push(String(add(config.toStageColumn, "equals", query.toStage)));
    // IDs cannot be null: Salesforce's unique count otherwise includes null as a value.
    clauses.push(String(add(config.opportunityIdColumn, "notEqual", "")));
    if (movement === "forward") {
      const pairs = config.openStages.map((stage, index) => {
        const from = add(config.fromStageColumn, "equals", stage);
        const to = add(
          config.toStageColumn,
          "equals",
          [...config.openStages.slice(index + 1), ...config.wonStages].join(
            ",",
          ),
        );
        return `(${from} AND ${to})`;
      });
      clauses.push(`(${pairs.join(" OR ")})`);
    } else {
      clauses.push(
        String(add(config.toStageColumn, "equals", config.wonStages.join(","))),
      );
      clauses.push(
        String(
          add(config.fromStageColumn, "notEqual", config.wonStages.join(",")),
        ),
      );
      // Initial record creation is not a transition from an existing stage.
      clauses.push(String(add(config.fromStageColumn, "notEqual", "")));
    }
    if (filters.length > 20)
      throw new ServiceUnavailableException(
        "Sales progression report exceeds Salesforce's filter limit. Simplify the saved report filters or stage configuration.",
      );
    return {
      reportFormat: "SUMMARY",
      detailColumns: [config.opportunityIdColumn],
      aggregates: ["RowCount", `u!${config.opportunityIdColumn}`],
      groupingsDown: [
        { name: config.fromStageColumn, sortOrder: "Asc" },
        { name: config.toStageColumn, sortOrder: "Asc" },
      ],
      groupingsAcross: [],
      showGrandTotal: true,
      showSubtotals: true,
      standardDateFilter: {
        column: config.dateColumn,
        durationValue: "CUSTOM",
        startDate: query.dateFrom,
        endDate: query.dateTo,
      },
      reportFilters: filters,
      reportBooleanFilter: clauses.join(" AND "),
    };
  }

  /**
   * Reads only Salesforce aggregates, rejecting incomplete/malformed summaries instead of returning partial counts.
   * @param report Summary response. @param config Column configuration.
   * @param movement Expected stage predicate, checked against returned groups.
   * @returns Distinct grand total, event count and stage-pair breakdown. @throws BadGatewayException for invalid results.
   */
  private summarize(
    report: SalesforceReport,
    config: HistoryConfig,
    movement: "forward" | "won",
  ): SalesMovementDto {
    /** @returns Sanitized error for incomplete or inconsistent summaries. Does not throw. */
    const invalid = (): BadGatewayException =>
      new BadGatewayException(
        "Salesforce returned incomplete or invalid progression summaries.",
      );
    const aggregates = Array.isArray(report?.reportMetadata?.aggregates)
      ? report.reportMetadata.aggregates
      : [];
    const groupings = report?.reportMetadata?.groupingsDown;
    const rowIndex = aggregates?.indexOf("RowCount") ?? -1;
    const uniqueIndex =
      aggregates?.indexOf(`u!${config.opportunityIdColumn}`) ?? -1;
    if (
      report?.allData !== true ||
      rowIndex < 0 ||
      uniqueIndex < 0 ||
      !Array.isArray(groupings) ||
      groupings.map((group) => group?.name).join("|") !==
        `${config.fromStageColumn}|${config.toStageColumn}` ||
      !Array.isArray(report.groupingsDown?.groupings)
    )
      throw invalid();
    /** @param key Salesforce fact-map bucket. @returns Validated counts. @throws For missing/invalid aggregates. */
    const counts = (
      key: string,
    ): { transitions: number; opportunities: number } => {
      const values = report.factMap?.[key]?.aggregates;
      const transitions = values?.[rowIndex]?.value;
      const opportunities = values?.[uniqueIndex]?.value;
      if (
        typeof transitions !== "number" ||
        typeof opportunities !== "number" ||
        !Number.isSafeInteger(transitions) ||
        !Number.isSafeInteger(opportunities) ||
        transitions < 0 ||
        opportunities < 0 ||
        opportunities > transitions ||
        (transitions > 0 && opportunities === 0)
      )
        throw invalid();
      return { transitions, opportunities };
    };
    const total = counts("T!T");
    const breakdown: SalesTransitionDto[] = [];
    const seen = new Set<string>();
    for (const from of report.groupingsDown.groupings) {
      if (
        !from ||
        typeof from.value !== "string" ||
        !from.value ||
        !Array.isArray(from.groupings)
      )
        throw invalid();
      for (const to of from.groupings) {
        if (
          !to ||
          typeof to.value !== "string" ||
          !to.value ||
          from.value === to.value
        )
          throw invalid();
        const fromIndex = config.openStages.indexOf(from.value);
        const toIndex = config.openStages.indexOf(to.value);
        const toWon = config.wonStages.includes(to.value);
        const qualifies =
          movement === "forward"
            ? fromIndex >= 0 && (toIndex > fromIndex || toWon)
            : toWon && !config.wonStages.includes(from.value);
        if (!qualifies) throw invalid();
        const key = JSON.stringify([from.value, to.value]);
        if (seen.has(key)) throw invalid();
        seen.add(key);
        const values = counts(`${to.key}!T`);
        if (values.opportunities > total.opportunities) throw invalid();
        breakdown.push({ fromStage: from.value, toStage: to.value, ...values });
      }
    }
    if (
      breakdown.reduce((sum, row) => sum + row.transitions, 0) !==
      total.transitions
    )
      throw invalid();
    return { ...total, breakdown };
  }

  /**
   * Runs the two predicates separately so overlapping groups never inflate distinct opportunity totals.
   * @param config Server report setup. @param query Validated filters.
   * @returns Both summaries with shared filter context. @throws Sanitized upstream errors.
   */
  private async load(
    config: HistoryConfig,
    query: SalesProgressionQueryDto,
  ): Promise<SalesProgressionDto> {
    const description = await this.client.describeReport(config.reportId);
    const saved = description?.reportMetadata;
    if (
      !saved ||
      saved.reportFormat === "MULTI_BLOCK" ||
      (saved.reportFilters !== undefined && !Array.isArray(saved.reportFilters))
    ) {
      throw new BadGatewayException(
        "Salesforce returned invalid history report metadata.",
      );
    }
    const forward = this.overrides(config, query, saved, "forward");
    const winning = this.overrides(config, query, saved, "won");
    const progressed = this.summarize(
      await this.client.runReport(config.reportId, forward, false),
      config,
      "forward",
    );
    const won = this.summarize(
      await this.client.runReport(config.reportId, winning, false),
      config,
      "won",
    );
    return {
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      fromStage: query.fromStage,
      toStage: query.toStage,
      timeZone: config.timeZone,
      stages: [
        ...config.openStages,
        ...config.wonStages,
        ...config.otherStages,
      ],
      openStages: config.openStages,
      wonStages: config.wonStages,
      progressed,
      won,
      refreshedAt: new Date().toISOString(),
      refreshAfterSeconds: CACHE_MS / 1000,
    };
  }
}
