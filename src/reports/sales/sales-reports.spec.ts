import {
  BadGatewayException,
  BadRequestException,
  ExecutionContext,
  ForbiddenException,
  UnauthorizedException,
  ValidationPipe,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { Reflector } from "@nestjs/core";
import { AuthUserLike } from "../../auth/permissions.util";
import { SalesReportsController } from "./sales-reports.controller";
import { SalesReportQueryDto } from "./sales-reports.dto";
import { SalesReportsGuard } from "./sales-reports.guard";
import { SalesReportsService } from "./sales-reports.service";
import {
  SalesforceReport,
  SalesforceReportsClient,
} from "./salesforce-reports.client";

/** Creates a synthetic grouped report; no customer data or credentials are used. @returns Test report. Does not throw. */
function reportFixture(): SalesforceReport {
  return {
    allData: true,
    hasDetailRows: true,
    reportMetadata: {
      id: "00O1K00000A7UGDUA3",
      name: "Sales pipeline",
      detailColumns: ["NAME", "AMOUNT", "CLOSE_DATE"],
    },
    reportExtendedMetadata: {
      detailColumnInfo: {
        NAME: { label: "Opportunity", dataType: "string" },
        AMOUNT: { label: "Amount", dataType: "currency" },
        CLOSE_DATE: { label: "Close date", dataType: "date" },
      },
    },
    factMap: {
      "0!T": {
        rows: [
          {
            dataCells: [
              { label: "Alpha", value: "Alpha" },
              { label: "$1,000", value: { amount: 1000, currencyCode: "USD" } },
              { label: "9/1/2026", value: "2026-09-01" },
            ],
          },
          {
            dataCells: [
              { label: "Beta", value: "Beta" },
              { label: "$20", value: 20 },
              { label: "10/1/2026", value: "2026-10-01" },
            ],
          },
        ],
      },
      "1!T": {
        rows: [
          {
            dataCells: [
              { label: "Gamma", value: "Gamma" },
              { label: "", value: null },
              { label: "8/1/2026", value: "2026-08-01" },
            ],
          },
        ],
      },
      "T!T": {},
    },
  };
}

describe("SalesReportsService", () => {
  let service: SalesReportsService;
  let runReport: jest.Mock;
  beforeEach(() => {
    jest.spyOn(Date, "now").mockReturnValue(Date.parse("2026-09-16T01:00:00Z"));
    jest.useFakeTimers({ now: Date.now() });
    runReport = jest.fn().mockResolvedValue(reportFixture());
    service = new SalesReportsService(
      { runReport } as unknown as SalesforceReportsClient,
      new ConfigService(),
    );
  });
  afterEach(() => {
    jest.useRealTimers();
    jest.restoreAllMocks();
  });

  it("preserves stage groupings and readable image formulas from Bookings By Stage", async () => {
    const fixture = reportFixture();
    fixture.reportMetadata.groupingsDown = [{ name: "STAGE_NAME" }];
    fixture.reportExtendedMetadata.groupingColumnInfo = {
      STAGE_NAME: { label: "Stage", dataType: "picklist" },
    };
    fixture.groupingsDown = {
      groupings: [
        { key: "0", label: "Proposal", value: "Proposal", groupings: [] },
        {
          key: "1",
          label: "Qualification",
          value: "Qualification",
          groupings: [],
        },
      ],
    };
    fixture.reportMetadata.detailColumns.push("ALERT");
    fixture.reportExtendedMetadata.detailColumnInfo.ALERT = {
      label: "Forecast Alert",
      dataType: "html",
    };
    Object.values(fixture.factMap).forEach((bucket) =>
      bucket.rows?.forEach((row) =>
        row.dataCells.push({
          label: '<img src="/private-file" alt="Red &amp; overdue" />',
          value: '<img src="/private-file" />',
        }),
      ),
    );
    fixture.factMap["0!T"].rows![0].dataCells[1].value = {
      amount: 1000,
      currency: "USD",
    };
    runReport.mockResolvedValue(fixture);
    const result = await service.getReport(
      Object.assign(new SalesReportQueryDto(), {
        filterColumn: "STAGE_NAME",
        filterValue: "Proposal",
      }),
    );
    expect(result.total).toBe(2);
    expect(result.columns[0]).toEqual({
      id: "STAGE_NAME",
      label: "Stage",
      dataType: "picklist",
    });
    expect(result.rows[0].cells[0].label).toBe("Proposal");
    expect(result.rows[0].cells[2]).toMatchObject({
      value: 1000,
      currencyCode: "USD",
    });
    expect(result.rows[0].cells[4]).toEqual({
      label: "Red & overdue",
      value: "Red & overdue",
    });
  });

  it("sorts lookup names by their displayed labels rather than Salesforce IDs", async () => {
    const fixture = reportFixture();
    fixture.factMap["0!T"].rows![0].dataCells[0].value = "zz-id";
    fixture.factMap["0!T"].rows![1].dataCells[0].value = "aa-id";
    runReport.mockResolvedValue(fixture);
    const result = await service.getReport(
      Object.assign(new SalesReportQueryDto(), { sortBy: "NAME" }),
    );
    expect(result.rows.map((row) => row.cells[0].label)).toEqual([
      "Alpha",
      "Beta",
      "Gamma",
    ]);
  });

  it("preserves all detail buckets, metadata, currency scalars and nulls", async () => {
    const result = await service.getReport(new SalesReportQueryDto());
    expect(result).toMatchObject({
      total: 3,
      sourceRowCount: 3,
      allData: true,
      reportName: "Sales pipeline",
    });
    expect(result.columns.map((column) => column.id)).toEqual([
      "NAME",
      "AMOUNT",
      "CLOSE_DATE",
    ]);
    expect(result.rows[0].cells[1]).toEqual({
      label: "$1,000",
      value: 1000,
      currencyCode: "USD",
    });
    expect(result.rows[2].cells[1].value).toBeNull();
    expect(runReport).toHaveBeenCalledWith("00O1K00000A7UGDUA3");
  });

  it("sorts numeric and date values globally before pagination and keeps nulls last", async () => {
    const result = await service.getReport(
      Object.assign(new SalesReportQueryDto(), {
        sortBy: "AMOUNT",
        perPage: 1,
        page: 2,
      }),
    );
    expect(result.rows[0].cells[0].label).toBe("Alpha");
    expect(result.totalPages).toBe(3);
    const dates = await service.getReport(
      Object.assign(new SalesReportQueryDto(), { sortBy: "CLOSE_DATE" }),
    );
    expect(dates.rows.map((row) => row.cells[0].label)).toEqual([
      "Gamma",
      "Alpha",
      "Beta",
    ]);
    const descending = await service.getReport(
      Object.assign(new SalesReportQueryDto(), {
        sortBy: "AMOUNT",
        sortOrder: "desc",
      }),
    );
    expect(descending.rows.map((row) => row.cells[0].label)).toEqual([
      "Alpha",
      "Beta",
      "Gamma",
    ]);
  });

  it("combines search and column filters before counting and clamps shrinking pages", async () => {
    const result = await service.getReport(
      Object.assign(new SalesReportQueryDto(), {
        search: "ALP",
        filterColumn: "AMOUNT",
        filterValue: "1,000",
        page: 99,
      }),
    );
    expect(result).toMatchObject({ total: 1, page: 1, sourceRowCount: 3 });
    await expect(
      service.getReport(
        Object.assign(new SalesReportQueryDto(), { sortBy: "missing" }),
      ),
    ).rejects.toBeInstanceOf(BadRequestException);
    await expect(
      service.getReport(
        Object.assign(new SalesReportQueryDto(), { filterValue: "Alpha" }),
      ),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it("coalesces requests, caches for a minute, and honors manual refresh after its cooldown", async () => {
    await Promise.all([
      service.getReport(new SalesReportQueryDto()),
      service.getReport(new SalesReportQueryDto()),
    ]);
    await service.getReport(
      Object.assign(new SalesReportQueryDto(), { refresh: true }),
    );
    expect(runReport).toHaveBeenCalledTimes(1);
    jest.advanceTimersByTime(5001);
    await service.getReport(
      Object.assign(new SalesReportQueryDto(), { refresh: true }),
    );
    expect(runReport).toHaveBeenCalledTimes(2);
    jest.advanceTimersByTime(60001);
    await service.getReport(new SalesReportQueryDto());
    expect(runReport).toHaveBeenCalledTimes(3);
  });

  it("does not serve failed refreshes as successful fresh data and throttles repeated failures", async () => {
    await service.getReport(new SalesReportQueryDto());
    jest.advanceTimersByTime(60001);
    runReport.mockRejectedValue(
      new BadGatewayException("Upstream unavailable"),
    );
    await expect(
      service.getReport(new SalesReportQueryDto()),
    ).rejects.toBeInstanceOf(BadGatewayException);
    await expect(
      service.getReport(new SalesReportQueryDto()),
    ).rejects.toBeInstanceOf(BadGatewayException);
    expect(runReport).toHaveBeenCalledTimes(2);
  });

  it("filters an inclusive date range on the selected column before counting", async () => {
    const september = await service.getReport(
      Object.assign(new SalesReportQueryDto(), {
        dateColumn: "CLOSE_DATE",
        dateFrom: "2026-09-01",
        dateTo: "2026-09-30",
      }),
    );
    expect(september.total).toBe(1);
    expect(september.rows[0].cells[0].label).toBe("Alpha");
    expect(september.sourceRowCount).toBe(3);
    const openEnded = await service.getReport(
      Object.assign(new SalesReportQueryDto(), {
        dateColumn: "CLOSE_DATE",
        dateFrom: "2026-09-01",
      }),
    );
    expect(openEnded.rows.map((row) => row.cells[0].label)).toEqual([
      "Alpha",
      "Beta",
    ]);
    const upToOnly = await service.getReport(
      Object.assign(new SalesReportQueryDto(), {
        dateColumn: "CLOSE_DATE",
        dateTo: "2026-08-31",
      }),
    );
    expect(upToOnly.rows.map((row) => row.cells[0].label)).toEqual(["Gamma"]);
  });

  it("selecting a date column without a bound leaves the result set untouched", async () => {
    const result = await service.getReport(
      Object.assign(new SalesReportQueryDto(), { dateColumn: "CLOSE_DATE" }),
    );
    expect(result.total).toBe(3);
  });

  it("uses the underlying date value and drops rows the range cannot place", async () => {
    const fixture = reportFixture();
    // A localized label with no usable underlying value must not be guessed at.
    fixture.factMap["0!T"].rows![1].dataCells[2] = {
      label: "10/1/2026",
      value: null,
    };
    // A datetime keeps the report's own offset; the displayed day is what counts.
    fixture.factMap["0!T"].rows![0].dataCells[2] = {
      label: "9/30/2026",
      value: "2026-09-30T22:00:00-07:00",
    };
    runReport.mockResolvedValue(fixture);
    const result = await service.getReport(
      Object.assign(new SalesReportQueryDto(), {
        dateColumn: "CLOSE_DATE",
        dateFrom: "2026-09-01",
        dateTo: "2026-09-30",
      }),
    );
    expect(result.rows.map((row) => row.cells[0].label)).toEqual(["Alpha"]);
    expect(result.total).toBe(1);
  });

  it("combines the date range with search and column filters", async () => {
    const result = await service.getReport(
      Object.assign(new SalesReportQueryDto(), {
        dateColumn: "CLOSE_DATE",
        dateFrom: "2026-08-01",
        dateTo: "2026-10-31",
        search: "a",
        filterColumn: "NAME",
        filterValue: "alpha",
      }),
    );
    expect(result.rows.map((row) => row.cells[0].label)).toEqual(["Alpha"]);
  });

  it("rejects incomplete, inverted and non-date range requests", async () => {
    for (const query of [
      { dateFrom: "2026-09-01" },
      { dateTo: "2026-09-30" },
      {
        dateColumn: "CLOSE_DATE",
        dateFrom: "2026-09-30",
        dateTo: "2026-09-01",
      },
      { dateColumn: "AMOUNT", dateFrom: "2026-09-01" },
      { dateColumn: "missing", dateFrom: "2026-09-01" },
    ]) {
      await expect(
        service.getReport(Object.assign(new SalesReportQueryDto(), query)),
      ).rejects.toBeInstanceOf(BadRequestException);
    }
  });

  it("summarizes every matching row rather than the returned page", async () => {
    const unfiltered = await service.getReport(
      Object.assign(new SalesReportQueryDto(), { perPage: 1 }),
    );
    expect(unfiltered.rows).toHaveLength(1);
    expect(unfiltered.summary).toMatchObject({ recordCount: 3 });
    // Beta's plain 20 declares no currency, so it cannot contradict Alpha's USD.
    expect(unfiltered.summary.amounts).toEqual([
      {
        columnId: "AMOUNT",
        label: "Amount",
        total: 1020,
        count: 2,
        currencyCode: "USD",
      },
    ]);
    const september = await service.getReport(
      Object.assign(new SalesReportQueryDto(), {
        dateColumn: "CLOSE_DATE",
        dateFrom: "2026-09-01",
        dateTo: "2026-09-30",
      }),
    );
    expect(september.summary).toMatchObject({ recordCount: 1 });
    expect(september.summary.amounts[0]).toEqual({
      columnId: "AMOUNT",
      label: "Amount",
      total: 1000,
      count: 1,
      currencyCode: "USD",
    });
  });

  it("breaks stage groupings down by count and amount, largest total first", async () => {
    const fixture = reportFixture();
    fixture.reportMetadata.groupingsDown = [{ name: "STAGE_NAME" }];
    fixture.reportExtendedMetadata.groupingColumnInfo = {
      STAGE_NAME: { label: "Stage", dataType: "picklist" },
    };
    fixture.groupingsDown = {
      groupings: [
        { key: "0", label: "Proposal", value: "Proposal", groupings: [] },
        { key: "1", label: "Closed Won", value: "Closed Won", groupings: [] },
      ],
    };
    fixture.factMap["0!T"].rows![1].dataCells[1] = {
      label: "$20",
      value: { amount: 20, currencyCode: "USD" },
    };
    runReport.mockResolvedValue(fixture);
    const result = await service.getReport(new SalesReportQueryDto());
    expect(result.summary.groups).toEqual([
      {
        columnId: "STAGE_NAME",
        label: "Stage",
        amountColumnId: "AMOUNT",
        currencyCode: "USD",
        otherBuckets: 0,
        buckets: [
          { label: "Proposal", count: 2, total: 1020 },
          { label: "Closed Won", count: 1, total: 0 },
        ],
      },
    ]);
  });

  it("does not label a total with a currency the matching rows do not share", async () => {
    const fixture = reportFixture();
    fixture.factMap["0!T"].rows![1].dataCells[1] = {
      label: "\u20ac20",
      value: { amount: 20, currencyCode: "EUR" },
    };
    runReport.mockResolvedValue(fixture);
    const result = await service.getReport(new SalesReportQueryDto());
    expect(result.summary.amounts[0]).toEqual({
      columnId: "AMOUNT",
      label: "Amount",
      total: 1020,
      count: 2,
    });
  });

  it("distinguishes an empty report, truncated data and an invalid detail-disabled report", async () => {
    const fixture = reportFixture();
    fixture.factMap = { "T!T": { rows: [] } };
    fixture.allData = false;
    runReport.mockResolvedValue(fixture);
    expect(await service.getReport(new SalesReportQueryDto())).toMatchObject({
      total: 0,
      allData: false,
    });
    jest.advanceTimersByTime(60001);
    fixture.hasDetailRows = false;
    await expect(
      service.getReport(new SalesReportQueryDto()),
    ).rejects.toBeInstanceOf(BadGatewayException);
  });
});

describe("Sales authorization", () => {
  const guard = new SalesReportsGuard(new Reflector());
  /** @param user Verified test claims. @param win Selects endpoint. @returns Mock Nest context. Does not throw. */
  function context(
    user: AuthUserLike | undefined,
    win = false,
  ): ExecutionContext {
    return {
      getHandler: () =>
        win
          ? SalesReportsController.prototype.getWinSales
          : SalesReportsController.prototype.getSales,
      getClass: () => SalesReportsController,
      switchToHttp: () => ({ getRequest: () => ({ authUser: user }) }),
    } as unknown as ExecutionContext;
  }
  it.each(["Administrator", "Talent Manager", "Topcoder Talent Manager"])(
    "allows the %s human role",
    (role) => {
      expect(guard.canActivate(context({ roles: [role] }))).toBe(true);
    },
  );
  it("requires a verified identity and never grants human access from scopes", () => {
    expect(() => guard.canActivate(context(undefined))).toThrow(
      UnauthorizedException,
    );
    expect(() =>
      guard.canActivate(
        context({ roles: ["Project Manager"], scopes: ["reports:sales"] }),
      ),
    ).toThrow(ForbiddenException);
    expect(() =>
      guard.canActivate(
        context({ isMachine: true, scopes: ["reports:sales"] }),
      ),
    ).toThrow(ForbiddenException);
  });
  it("requires exactly the dedicated machine scope for WIN, including for admins", () => {
    expect(
      guard.canActivate(
        context({ isMachine: true, scopes: "openid reports:sales" }, true),
      ),
    ).toBe(true);
    for (const user of [
      { roles: ["Administrator"], scopes: ["reports:sales"] },
      { isMachine: true, scopes: ["reports:all"] },
      { isMachine: true, roles: ["Administrator"] },
    ]) {
      expect(() => guard.canActivate(context(user, true))).toThrow(
        ForbiddenException,
      );
    }
  });
});

describe("Sales query validation", () => {
  const pipe = new ValidationPipe({ transform: true, whitelist: true });
  const metadata = { type: "query" as const, metatype: SalesReportQueryDto };
  it("parses booleans without interpreting false as true", async () => {
    expect(
      await pipe.transform(
        { refresh: "false", page: "2", perPage: "50" },
        metadata,
      ),
    ).toMatchObject({ refresh: false, page: 2, perPage: 50 });
  });
  it("accepts a well-formed calendar range", async () => {
    expect(
      await pipe.transform(
        {
          dateColumn: "CLOSE_DATE",
          dateFrom: "2028-02-29",
          dateTo: "2026-09-30",
        },
        metadata,
      ),
    ).toMatchObject({
      dateColumn: "CLOSE_DATE",
      dateFrom: "2028-02-29",
      dateTo: "2026-09-30",
    });
  });
  it.each([
    { page: "0" },
    { perPage: "201" },
    { refresh: "1" },
    { sortOrder: "invalid" },
    { search: ["a", "b"] },
    { dateFrom: "09/01/2026" },
    { dateFrom: "2026-09-01T00:00:00Z" },
    { dateFrom: "2026-02-30" },
    { dateTo: "2027-02-29" },
    { dateTo: "2026-13-01" },
  ])("rejects invalid input %j", async (query) => {
    await expect(pipe.transform(query, metadata)).rejects.toBeInstanceOf(
      BadRequestException,
    );
  });
});
