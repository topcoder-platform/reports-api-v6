import { Injectable } from "@nestjs/common";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { DbService } from "../../db/db.service";
import { WinReportQueryDto, WinReportResponseDto } from "./win-reports.dto";

/** Loads opted-in showcases with current project metadata for the WIN integration. */
@Injectable()
export class WinReportsService {
  /**
   * @param db Shared reporting database connection.
   * @param sql Repository SQL loader used by report services.
   * @returns A service ready to execute the WIN query.
   * @throws Does not throw during construction.
   */
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  /**
   * Reads a consistent page and total from the current opted-in showcase records.
   * @param query Validated project filter and pagination from the controller.
   * @returns Current metadata, ordered by post ID, with pagination information.
   * @throws Propagates SQL loading and database errors to Nest's error handler.
   */
  async getReport(query: WinReportQueryDto): Promise<WinReportResponseDto> {
    const rows = await this.db.query<Pick<WinReportResponseDto, "data" | "total">>(
      this.sql.load("reports/win/showcase.sql"),
      [query.projectId ?? null, query.perPage, (query.page - 1) * query.perPage],
    );
    return { ...rows[0], page: query.page, perPage: query.perPage };
  }
}
