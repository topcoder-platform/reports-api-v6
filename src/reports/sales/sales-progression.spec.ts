import {
  BadGatewayException,
  BadRequestException,
  ExecutionContext,
  ForbiddenException,
  ServiceUnavailableException,
  ValidationPipe,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { Reflector } from "@nestjs/core";
import { SalesProgressionController } from "./sales-progression.controller";
import { SalesProgressionQueryDto } from "./sales-progression.dto";
import { SalesProgressionService } from "./sales-progression.service";
import { SalesReportsGuard } from "./sales-reports.guard";
import {
  SalesforceReport,
  SalesforceReportFilter,
  SalesforceReportOverrides,
  SalesforceReportsClient,
} from "./salesforce-reports.client";

const settings = {
  reportId: "00O1K00000A7UGDUA3",
  dateColumn: "HISTORY_DATE",
  opportunityIdColumn: "OPPORTUNITY_ID",
  fromStageColumn: "FROM_STAGE",
  toStageColumn: "TO_STAGE",
  timeZone: "America/New_York",
  openStages: ["Prospecting", "Qualification", "Proposal"],
  wonStages: ["Won", "Won signed"],
  otherStages: ["Lost"],
};
const period = { dateFrom: "2026-10-01", dateTo: "2026-10-31" };
type Event = {
  OPPORTUNITY_ID: string;
  FROM_STAGE: string;
  TO_STAGE: string;
  HISTORY_DATE: string;
  REGION: string;
};

/** @param id Opportunity. @param from Previous stage. @param to New stage. @param day History date. @returns Synthetic history event. Does not throw. */
function event(
  id: string,
  from: string,
  to: string,
  day = "2026-10-03",
): Event {
  return {
    OPPORTUNITY_ID: id,
    FROM_STAGE: from,
    TO_STAGE: to,
    HISTORY_DATE: day,
    REGION: "A",
  };
}
const events = [
  event("A", "Prospecting", "Qualification", "2026-10-01"),
  event("A", "Qualification", "Proposal"),
  event("A", "Proposal", "Qualification"), // Regression.
  event("A", "Qualification", "Won"),
  event("A", "Won", "Proposal"), // Reopened.
  event("A", "Proposal", "Won"),
  event("B", "Proposal", "Won", "2026-10-31"),
  event("B", "Won", "Won signed"), // Already won.
  event("C", "Proposal", "Proposal"), // Amount-only change.
  event("D", "Lost", "Proposal"),
  event("E", "", "Won"), // Creation, not a stage transition.
  event("F", "Prospecting", "Proposal", "2026-09-30"),
  event("H", "Prospecting", "Won", "2026-11-01"),
  event("G", "Lost", "Won"), // A win, but not a forward pipeline transition.
];

/**
 * Evaluates the documented Salesforce filter grammar in the fake upstream, independently of stage ordering.
 * @param row Synthetic event. @param filters API filters. @param expression AND/OR expression.
 * @returns Whether the row matches. @throws For an invalid test expression.
 */
function matches(
  row: Event,
  filters: SalesforceReportFilter[],
  expression: string,
): boolean {
  const tokens = expression.match(/\d+|AND|OR|\(|\)/g)!;
  let position = 0;
  /** @returns Parenthesized expression or filter result. @throws On invalid syntax. */
  function primary(): boolean {
    const token = tokens[position++];
    if (token === "(") {
      const result = or();
      if (tokens[position++] !== ")") throw new Error("Invalid expression");
      return result;
    }
    const filter = filters[Number(token) - 1];
    const included = filter.value.split(",").includes(row[filter.column]);
    return filter.operator === "equals" ? included : !included;
  }
  /** @returns Conjunction result. Does not throw for valid test expressions. */
  function and(): boolean {
    let result = primary();
    while (tokens[position] === "AND") {
      position++;
      const next = primary();
      result = result && next;
    }
    return result;
  }
  /** @returns Disjunction result. Does not throw for valid test expressions. */
  function or(): boolean {
    let result = and();
    while (tokens[position] === "OR") {
      position++;
      const next = and();
      result = result || next;
    }
    return result;
  }
  return or();
}

/**
 * Emulates Salesforce summary aggregation with no detail rows, including independent distinct grand totals.
 * @param metadata Execution metadata. @returns Grouped summary response. Does not throw for valid test metadata.
 */
function upstream(metadata: SalesforceReportOverrides): SalesforceReport {
  const rows = events.filter(
    (row) =>
      row.HISTORY_DATE >= metadata.standardDateFilter!.startDate &&
      row.HISTORY_DATE <= metadata.standardDateFilter!.endDate &&
      matches(row, metadata.reportFilters!, metadata.reportBooleanFilter!),
  );
  /** @param selected Matching events. @returns SF aggregate cells. Does not throw. */
  const aggregate = (selected: Event[]) => ({
    aggregates: [
      { value: selected.length },
      { value: new Set(selected.map((row) => row.OPPORTUNITY_ID)).size },
    ],
  });
  const factMap: SalesforceReport["factMap"] = { "T!T": aggregate(rows) };
  const groupings = [...new Set(rows.map((row) => row.FROM_STAGE))].map(
    (from, i) => ({
      key: String(i),
      label: from,
      value: from,
      groupings: [
        ...new Set(
          rows
            .filter((row) => row.FROM_STAGE === from)
            .map((row) => row.TO_STAGE),
        ),
      ].map((to, j) => {
        factMap[`${i}_${j}!T`] = aggregate(
          rows.filter((row) => row.FROM_STAGE === from && row.TO_STAGE === to),
        );
        return { key: `${i}_${j}`, label: to, value: to, groupings: [] };
      }),
    }),
  );
  return {
    allData: true,
    hasDetailRows: false,
    reportMetadata: {
      id: settings.reportId,
      name: "History",
      detailColumns: [],
      ...metadata,
    },
    reportExtendedMetadata: { detailColumnInfo: {} },
    groupingsDown: { groupings },
    factMap,
  };
}

describe("Sales progression", () => {
  let service: SalesProgressionService;
  let runReport: jest.Mock;
  let describeReport: jest.Mock;
  beforeEach(() => {
    runReport = jest
      .fn()
      .mockImplementation((_id, metadata: SalesforceReportOverrides) =>
        Promise.resolve(upstream(metadata)),
      );
    describeReport = jest.fn().mockResolvedValue({
      reportMetadata: {
        reportFilters: [
          { column: "REGION", operator: "equals", value: "A" },
          { column: "REGION", operator: "equals", value: "B" },
        ],
        reportBooleanFilter: "1 OR 2",
      },
    });
    service = new SalesProgressionService(
      { runReport, describeReport } as unknown as SalesforceReportsClient,
      new ConfigService({
        SALESFORCE_SALES_HISTORY_CONFIG: JSON.stringify(settings),
      }),
    );
  });
  afterEach(() => jest.restoreAllMocks());

  it("counts only forward movement and non-won to won transitions, deduplicating opportunities globally", async () => {
    const report = await service.getReport(period);
    expect(report.progressed).toMatchObject({
      opportunities: 2,
      transitions: 5,
    });
    expect(report.won).toMatchObject({ opportunities: 3, transitions: 4 });
    expect(
      report.progressed.breakdown.reduce(
        (sum, row) => sum + row.opportunities,
        0,
      ),
    ).toBe(5);
    expect(report.won.breakdown).toContainEqual({
      fromStage: "Lost",
      toStage: "Won",
      opportunities: 1,
      transitions: 1,
    });
    expect(runReport.mock.calls.every((call) => call[2] === false)).toBe(true);
    expect(runReport.mock.calls[0][1]).toMatchObject({
      standardDateFilter: {
        column: "HISTORY_DATE",
        startDate: period.dateFrom,
        endDate: period.dateTo,
        durationValue: "CUSTOM",
      },
      aggregates: ["RowCount", "u!OPPORTUNITY_ID"],
      reportBooleanFilter: expect.stringContaining("(1 OR 2) AND"),
    });
  });
  it("applies exact stage filters in Salesforce to both totals and breakdowns", async () => {
    const report = await service.getReport({
      ...period,
      fromStage: "Proposal",
      toStage: "Won",
    });
    expect(report.progressed).toMatchObject({
      opportunities: 2,
      transitions: 2,
    });
    expect(report.won).toMatchObject({ opportunities: 2, transitions: 2 });
    expect(report.progressed.breakdown).toHaveLength(1);
    const empty = await service.getReport({
      ...period,
      fromStage: "Won",
      toStage: "Proposal",
    });
    expect(empty.progressed).toEqual({
      opportunities: 0,
      transitions: 0,
      breakdown: [],
    });
    expect(empty.won).toEqual({
      opportunities: 0,
      transitions: 0,
      breakdown: [],
    });
  });
  it("coalesces and caches identical requests, isolates periods and retries after expiry", async () => {
    const now = Date.now();
    const clock = jest.spyOn(Date, "now").mockReturnValue(now);
    const [a, b] = await Promise.all([
      service.getReport(period),
      service.getReport(period),
    ]);
    expect(a).toBe(b);
    await service.getReport(period);
    expect(runReport).toHaveBeenCalledTimes(2);
    await service.getReport({ ...period, dateFrom: "2026-10-02" });
    expect(runReport).toHaveBeenCalledTimes(4);
    clock.mockReturnValue(now + 60001);
    await service.getReport(period);
    expect(runReport).toHaveBeenCalledTimes(6);
  });
  it("rejects incomplete, missing, and malformed aggregates without inventing zero totals", async () => {
    for (const mode of ["partial", "missing", "mismatch"]) {
      runReport.mockImplementationOnce(
        (_id, metadata: SalesforceReportOverrides) => {
          const report = upstream(metadata);
          if (mode === "partial") report.allData = false;
          if (mode === "missing") delete report.factMap["T!T"].aggregates;
          if (mode === "mismatch")
            report.factMap["T!T"].aggregates![0].value = 999;
          return Promise.resolve(report);
        },
      );
      await expect(
        service.getReport({
          ...period,
          dateTo: `2026-10-${mode === "partial" ? "28" : mode === "missing" ? "29" : "30"}`,
        }),
      ).rejects.toBeInstanceOf(BadGatewayException);
    }
  });
  it("uses complete summary totals above the detail-row limit without downloading events", async () => {
    runReport.mockImplementation((_id, metadata: SalesforceReportOverrides) => {
      const report = upstream(metadata);
      Object.values(report.factMap).forEach((bucket) =>
        bucket.aggregates?.forEach((cell) => {
          cell.value! *= 2000;
        }),
      );
      return Promise.resolve(report);
    });
    const report = await service.getReport(period);
    expect(report.progressed).toMatchObject({
      opportunities: 4000,
      transitions: 10000,
    });
    expect(report.won).toMatchObject({
      opportunities: 6000,
      transitions: 8000,
    });
  });
  it("rejects a summary whose stage groups contradict the requested movement predicate", async () => {
    runReport.mockImplementationOnce(
      (_id, metadata: SalesforceReportOverrides) => {
        const report = upstream(metadata);
        report.groupingsDown!.groupings[0].value = "Won";
        return Promise.resolve(report);
      },
    );
    await expect(service.getReport(period)).rejects.toBeInstanceOf(
      BadGatewayException,
    );
  });
  it("throttles repeat upstream failures", async () => {
    runReport.mockRejectedValue(new BadGatewayException());
    await expect(service.getReport(period)).rejects.toBeInstanceOf(
      BadGatewayException,
    );
    await expect(service.getReport(period)).rejects.toBeInstanceOf(
      BadGatewayException,
    );
    expect(runReport).toHaveBeenCalledTimes(1);
  });
  it("rejects invalid ranges and stage filters before contacting Salesforce", async () => {
    for (const query of [
      { ...period, dateFrom: "2026-11-01" },
      { ...period, dateFrom: "2024-01-01" },
      { ...period, fromStage: "Proposal,Lost" },
    ]) {
      await expect(service.getReport(query)).rejects.toBeInstanceOf(
        BadRequestException,
      );
    }
    expect(describeReport).not.toHaveBeenCalled();
  });
  it("requires explicit configuration and refuses excess report filters", async () => {
    const unconfigured = new SalesProgressionService(
      {} as SalesforceReportsClient,
      new ConfigService(),
    );
    await expect(unconfigured.getReport(period)).rejects.toBeInstanceOf(
      ServiceUnavailableException,
    );
    describeReport.mockResolvedValue({
      reportMetadata: {
        reportFilters: Array(20).fill({
          column: "REGION",
          operator: "equals",
          value: "A",
        }),
      },
    });
    await expect(service.getReport(period)).rejects.toBeInstanceOf(
      ServiceUnavailableException,
    );
    expect(runReport).not.toHaveBeenCalled();
  });
  it("validates required calendar dates at the HTTP boundary", async () => {
    const pipe = new ValidationPipe({ transform: true, whitelist: true });
    for (const query of [
      {},
      { ...period, dateFrom: "2026-02-30" },
      { ...period, dateTo: "2026-10-02T12:00:00Z" },
    ]) {
      await expect(
        pipe.transform(query, {
          type: "query",
          metatype: SalesProgressionQueryDto,
        }),
      ).rejects.toBeInstanceOf(BadRequestException);
    }
    const stripped = await pipe.transform(
      { ...period, reportId: "arbitrary" },
      { type: "query", metatype: SalesProgressionQueryDto },
    );
    expect(stripped).not.toHaveProperty("reportId");
    await expect(
      pipe.transform(period, {
        type: "query",
        metatype: SalesProgressionQueryDto,
      }),
    ).resolves.toMatchObject(period);
  });
  it("retains the Sales human-role guard and denies machines even with reports:sales", () => {
    const guard = new SalesReportsGuard(new Reflector());
    /** @param user Authenticated claims. @returns Controller execution context. Does not throw. */
    const context = (user: object): ExecutionContext =>
      ({
        getHandler: () => SalesProgressionController.prototype.getProgression,
        getClass: () => SalesProgressionController,
        switchToHttp: () => ({ getRequest: () => ({ authUser: user }) }),
      }) as unknown as ExecutionContext;
    expect(
      Reflect.getMetadata("__guards__", SalesProgressionController),
    ).toContain(SalesReportsGuard);
    expect(guard.canActivate(context({ roles: ["administrator"] }))).toBe(true);
    expect(guard.canActivate(context({ roles: ["Talent Manager"] }))).toBe(
      true,
    );
    expect(() => guard.canActivate(context({ roles: ["user"] }))).toThrow(
      ForbiddenException,
    );
    expect(() =>
      guard.canActivate(
        context({ isMachine: true, scopes: ["reports:sales"] }),
      ),
    ).toThrow(ForbiddenException);
  });
});
