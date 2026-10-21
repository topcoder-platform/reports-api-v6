import { Injectable, OnModuleDestroy } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { Pool } from "pg";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { DbService } from "../../db/db.service";
import {
  ActiveMemberActivityDto,
  ActiveMembersDashboardDto,
  ActiveMembersMonthDto,
  DashboardSlug,
} from "./dashboard-reports.dto";
import type { DashboardDateRange } from "./dashboard-reports.service";

/** Combines finance/resource and engagement events for the active-members dashboard. */
@Injectable()
export class ActiveMembersReportsService implements OnModuleDestroy {
  private engagementsPool?: Pool;

  /**
   * Creates the cross-database activity report used by DashboardReportsService.
   * @param db Main reporting database connection.
   * @param sql Report SQL loader.
   * @param config Supplies the separate engagements database URL.
   * @returns A report service; no database connections are opened here.
   * @throws Does not throw.
   */
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
    private readonly config: ConfigService,
  ) {}

  /**
   * Closes the lazily opened engagements connection at application shutdown.
   * @returns Resolves when the pool has closed.
   * @throws Propagates pool shutdown errors.
   */
  async onModuleDestroy(): Promise<void> {
    await this.engagementsPool?.end();
  }

  /**
   * Loads dated activity and deduplicates members within months and the whole range.
   * Activity detail is ordered newest first, with stable IDs breaking date ties.
   * @param range Validated inclusive start and exclusive end UTC timestamps.
   * @returns Zero-filled monthly counts, activity detail, and a selected-range total.
   * @throws Error if ENGAGEMENTS_DB_URL is missing or a database query fails.
   */
  async load(range: DashboardDateRange): Promise<ActiveMembersDashboardDto> {
    const params = [range.startDate, range.endDate];
    const pool = this.getEngagementsPool();
    const [mainEvents, engagementEvents] = await Promise.all([
      this.db.query<ActiveMemberActivityDto>(
        this.sql.load("reports/dashboard/active-members.sql"),
        params,
      ),
      pool.query<ActiveMemberActivityDto>(
        this.sql.load("reports/dashboard/active-members-engagements.sql"),
        params,
      ),
    ]);
    const months = new Map<string, ActiveMembersMonthDto>();
    const start = new Date(range.startDate);
    const cursor = new Date(
      Date.UTC(start.getUTCFullYear(), start.getUTCMonth(), 1),
    );
    while (cursor.getTime() < new Date(range.endDate).getTime()) {
      const month = cursor.toISOString().slice(0, 10);
      months.set(month, { month, totalUniqueMembers: 0, activities: [] });
      cursor.setUTCMonth(cursor.getUTCMonth() + 1);
    }
    const events = [...mainEvents, ...engagementEvents.rows].sort(
      (a, b) => b.date.localeCompare(a.date) || a.id.localeCompare(b.id),
    );
    for (const event of events) {
      months.get(`${event.date.slice(0, 7)}-01`)?.activities.push(event);
    }
    for (const month of months.values()) {
      month.totalUniqueMembers = new Set(
        month.activities.map((event) => event.memberId),
      ).size;
    }
    return {
      dashboard: DashboardSlug.ActiveMembers,
      ...range,
      months: [...months.values()],
      summary: {
        totalUniqueMembers: new Set(events.map((event) => event.memberId)).size,
      },
    };
  }

  /**
   * Reuses a lazy pool, matching the existing Engagement Data report connection.
   * @returns The engagements database pool.
   * @throws Error when ENGAGEMENTS_DB_URL is not configured.
   */
  private getEngagementsPool(): Pool {
    if (!this.engagementsPool) {
      const connectionString = this.config.get<string>(
        "ENGAGEMENTS_DB_URL",
        "",
      );
      if (!connectionString) {
        throw new Error(
          "ENGAGEMENTS_DB_URL must be configured for the active-members dashboard.",
        );
      }
      this.engagementsPool = new Pool({ connectionString });
    }
    return this.engagementsPool;
  }
}
