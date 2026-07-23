import { BadRequestException, Injectable } from "@nestjs/common";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { DbService } from "../../db/db.service";
import {
  AllDashboardsDto,
  ChallengeParticipationDashboardDto,
  DashboardExportRowDto,
  DashboardQueryDto,
  DashboardResponse,
  DashboardSlug,
  MembersPaidDashboardDto,
  NewSignupsDashboardDto,
} from "./dashboard-reports.dto";

type QueryValue = Date | string | number | null;

type NewSignupsRow = {
  month: string;
  activated: QueryValue;
  not_activated: QueryValue;
  total_signups: QueryValue;
  activated_members: QueryValue;
  not_activated_members: QueryValue;
  activation_rate: QueryValue;
  peak_month: string | null;
  peak_month_signups: QueryValue;
};

type MembersPaidRow = {
  month: string;
  taas: QueryValue;
  task: QueryValue;
  contest: QueryValue;
  engagement: QueryValue;
  total_unique_members: QueryValue;
  taas_unique_members: QueryValue;
  task_unique_members: QueryValue;
  contest_unique_members: QueryValue;
  engagement_unique_members: QueryValue;
  peak_month: string | null;
  peak_month_unique_members: QueryValue;
};

type ChallengeParticipationRow = {
  month: string;
  registrants: QueryValue;
  submitters: QueryValue;
  total_unique_registrants: QueryValue;
  total_unique_submitters: QueryValue;
  submission_rate: QueryValue;
  peak_month: string | null;
  peak_month_registrants: QueryValue;
};

/**
 * Resolved half-open date range used by all dashboard SQL queries.
 */
export type DashboardDateRange = {
  startDate: string;
  endDate: string;
};

/**
 * Parses an optional ISO date for dashboard range resolution.
 *
 * @param value Optional ISO-8601 value supplied by the request.
 * @param fieldName Query field name used in validation errors.
 * @returns Parsed date, or `undefined` when no value was supplied.
 * @throws BadRequestException when the value is not a valid date.
 */
function parseOptionalDate(
  value: string | undefined,
  fieldName: string,
): Date | undefined {
  if (!value) {
    return undefined;
  }

  const parsed = new Date(value);
  if (Number.isNaN(parsed.getTime())) {
    throw new BadRequestException(`${fieldName} must be a valid ISO date.`);
  }

  return parsed;
}

/**
 * Shifts a timestamp by whole UTC calendar months while clamping the day to
 * the final valid day in the destination month.
 *
 * @param value Source timestamp.
 * @param monthCount Signed number of UTC calendar months to add.
 * @returns Shifted timestamp with the original UTC time-of-day.
 */
function shiftUtcMonths(value: Date, monthCount: number): Date {
  const sourceYear = value.getUTCFullYear();
  const sourceMonth = value.getUTCMonth();
  const targetFirst = new Date(
    Date.UTC(sourceYear, sourceMonth + monthCount, 1),
  );
  const finalDay = new Date(
    Date.UTC(targetFirst.getUTCFullYear(), targetFirst.getUTCMonth() + 1, 0),
  ).getUTCDate();

  return new Date(
    Date.UTC(
      targetFirst.getUTCFullYear(),
      targetFirst.getUTCMonth(),
      Math.min(value.getUTCDate(), finalDay),
      value.getUTCHours(),
      value.getUTCMinutes(),
      value.getUTCSeconds(),
      value.getUTCMilliseconds(),
    ),
  );
}

/**
 * Resolves optional query dates into an explicit half-open range.
 *
 * With no dates, the range covers the latest six UTC calendar months,
 * including the current month. Supplying only one bound derives the other
 * bound six calendar months away.
 *
 * @param query Optional dashboard range supplied by the caller.
 * @param now Current time override used by deterministic tests.
 * @returns Explicit ISO start and exclusive end timestamps.
 * @throws BadRequestException when a date is invalid or end is not after start.
 */
export function resolveDashboardDateRange(
  query: DashboardQueryDto,
  now: Date = new Date(),
): DashboardDateRange {
  const requestedStart = parseOptionalDate(query.startDate, "startDate");
  const requestedEnd = parseOptionalDate(query.endDate, "endDate");
  const defaultEnd = new Date(
    Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + 1, 1),
  );

  const start =
    requestedStart ??
    (requestedEnd
      ? shiftUtcMonths(requestedEnd, -6)
      : shiftUtcMonths(defaultEnd, -6));
  const end =
    requestedEnd ??
    (requestedStart ? shiftUtcMonths(requestedStart, 6) : defaultEnd);

  if (end.getTime() <= start.getTime()) {
    throw new BadRequestException("endDate must be later than startDate.");
  }

  return {
    startDate: start.toISOString(),
    endDate: end.toISOString(),
  };
}

/**
 * Converts PostgreSQL numeric and bigint results into finite JavaScript
 * numbers suitable for JSON responses.
 *
 * @param value Raw database value.
 * @returns Numeric value, falling back to zero for null or non-finite input.
 */
function toNumber(value: QueryValue | undefined): number {
  const parsed = Number(value ?? 0);
  return Number.isFinite(parsed) ? parsed : 0;
}

/**
 * Loads and maps the SQL-backed reports used by the Reports Portal dashboards.
 */
@Injectable()
export class DashboardReportsService {
  /**
   * Creates a dashboard report service.
   *
   * @param db Shared PostgreSQL query service.
   * @param sql SQL file loader.
   */
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  /**
   * Loads all three dashboards for one shared reporting range.
   *
   * @param query Optional date range.
   * @returns Full dashboard objects keyed for the landing page.
   * @throws BadRequestException when the range is invalid.
   */
  async getAllDashboards(query: DashboardQueryDto): Promise<AllDashboardsDto> {
    const range = resolveDashboardDateRange(query);
    const [newSignups, membersPaid, challengeParticipation] = await Promise.all(
      [
        this.loadNewSignups(range),
        this.loadMembersPaid(range),
        this.loadChallengeParticipation(range),
      ],
    );

    return {
      newSignups,
      membersPaid,
      challengeParticipation,
    };
  }

  /**
   * Loads one dashboard selected by its public route slug.
   *
   * @param dashboard Dashboard route slug.
   * @param query Optional date range.
   * @returns Full selected dashboard object.
   * @throws BadRequestException when the dashboard or range is invalid.
   */
  async getDashboard(
    dashboard: DashboardSlug,
    query: DashboardQueryDto,
  ): Promise<DashboardResponse> {
    const range = resolveDashboardDateRange(query);

    switch (dashboard) {
      case DashboardSlug.NewSignups:
        return this.loadNewSignups(range);
      case DashboardSlug.MembersPaid:
        return this.loadMembersPaid(range);
      case DashboardSlug.ChallengeParticipation:
        return this.loadChallengeParticipation(range);
      default:
        throw new BadRequestException("Unsupported dashboard.");
    }
  }

  /**
   * Builds a flat monthly export containing all dashboards.
   *
   * @param query Optional date range.
   * @returns Flat rows ready for CSV serialization.
   * @throws BadRequestException when the range is invalid.
   */
  async exportAllDashboards(
    query: DashboardQueryDto,
  ): Promise<DashboardExportRowDto[]> {
    const dashboards = await this.getAllDashboards(query);
    return [
      ...this.toExportRows(dashboards.newSignups),
      ...this.toExportRows(dashboards.membersPaid),
      ...this.toExportRows(dashboards.challengeParticipation),
    ];
  }

  /**
   * Builds a flat monthly export for one dashboard.
   *
   * @param dashboard Dashboard route slug.
   * @param query Optional date range.
   * @returns Flat rows ready for CSV serialization.
   * @throws BadRequestException when the dashboard or range is invalid.
   */
  async exportDashboard(
    dashboard: DashboardSlug,
    query: DashboardQueryDto,
  ): Promise<DashboardExportRowDto[]> {
    const response = await this.getDashboard(dashboard, query);
    return this.toExportRows(response);
  }

  /**
   * Executes and maps the new-signups dashboard SQL.
   *
   * @param range Explicit half-open query range.
   * @returns New-signups dashboard response.
   */
  private async loadNewSignups(
    range: DashboardDateRange,
  ): Promise<NewSignupsDashboardDto> {
    const query = this.sql.load("reports/dashboard/new-signups.sql");
    const rows = await this.db.query<NewSignupsRow>(query, [
      range.startDate,
      range.endDate,
    ]);
    const summary = rows[0];

    return {
      dashboard: DashboardSlug.NewSignups,
      ...range,
      months: rows.map((row) => ({
        month: row.month,
        activated: toNumber(row.activated),
        notActivated: toNumber(row.not_activated),
      })),
      summary: {
        totalSignups: toNumber(summary?.total_signups),
        activatedMembers: toNumber(summary?.activated_members),
        notActivatedMembers: toNumber(summary?.not_activated_members),
        activationRate: toNumber(summary?.activation_rate),
        peakMonth: summary?.peak_month ?? null,
        peakMonthSignups: toNumber(summary?.peak_month_signups),
      },
    };
  }

  /**
   * Executes and maps the unique-members-paid dashboard SQL.
   *
   * @param range Explicit half-open query range.
   * @returns Members-paid dashboard response.
   */
  private async loadMembersPaid(
    range: DashboardDateRange,
  ): Promise<MembersPaidDashboardDto> {
    const query = this.sql.load("reports/dashboard/members-paid.sql");
    const rows = await this.db.query<MembersPaidRow>(query, [
      range.startDate,
      range.endDate,
    ]);
    const summary = rows[0];

    return {
      dashboard: DashboardSlug.MembersPaid,
      ...range,
      months: rows.map((row) => ({
        month: row.month,
        taas: toNumber(row.taas),
        task: toNumber(row.task),
        contest: toNumber(row.contest),
        engagement: toNumber(row.engagement),
      })),
      summary: {
        totalUniqueMembers: toNumber(summary?.total_unique_members),
        taasUniqueMembers: toNumber(summary?.taas_unique_members),
        taskUniqueMembers: toNumber(summary?.task_unique_members),
        contestUniqueMembers: toNumber(summary?.contest_unique_members),
        engagementUniqueMembers: toNumber(summary?.engagement_unique_members),
        peakMonth: summary?.peak_month ?? null,
        peakMonthUniqueMembers: toNumber(summary?.peak_month_unique_members),
      },
    };
  }

  /**
   * Executes and maps the challenge-participation dashboard SQL.
   *
   * @param range Explicit half-open query range.
   * @returns Challenge-participation dashboard response.
   */
  private async loadChallengeParticipation(
    range: DashboardDateRange,
  ): Promise<ChallengeParticipationDashboardDto> {
    const query = this.sql.load(
      "reports/dashboard/challenge-participation.sql",
    );
    const rows = await this.db.query<ChallengeParticipationRow>(query, [
      range.startDate,
      range.endDate,
    ]);
    const summary = rows[0];

    return {
      dashboard: DashboardSlug.ChallengeParticipation,
      ...range,
      months: rows.map((row) => ({
        month: row.month,
        registrants: toNumber(row.registrants),
        submitters: toNumber(row.submitters),
      })),
      summary: {
        totalUniqueRegistrants: toNumber(summary?.total_unique_registrants),
        totalUniqueSubmitters: toNumber(summary?.total_unique_submitters),
        submissionRate: toNumber(summary?.submission_rate),
        peakMonth: summary?.peak_month ?? null,
        peakMonthRegistrants: toNumber(summary?.peak_month_registrants),
      },
    };
  }

  /**
   * Flattens a dashboard response into monthly CSV rows.
   *
   * @param dashboard Full dashboard response.
   * @returns Metric-specific flat rows with a dashboard discriminator.
   */
  private toExportRows(dashboard: DashboardResponse): DashboardExportRowDto[] {
    switch (dashboard.dashboard) {
      case DashboardSlug.NewSignups:
        return dashboard.months.map((month) => ({
          dashboard: dashboard.dashboard,
          month: month.month,
          activated: month.activated,
          notActivated: month.notActivated,
        }));
      case DashboardSlug.MembersPaid:
        return dashboard.months.map((month) => ({
          dashboard: dashboard.dashboard,
          month: month.month,
          taas: month.taas,
          task: month.task,
          contest: month.contest,
          engagement: month.engagement,
        }));
      case DashboardSlug.ChallengeParticipation:
        return dashboard.months.map((month) => ({
          dashboard: dashboard.dashboard,
          month: month.month,
          registrants: month.registrants,
          submitters: month.submitters,
        }));
    }
  }
}
