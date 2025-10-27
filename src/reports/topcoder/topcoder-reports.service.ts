import { Injectable } from "@nestjs/common";
import { DbService } from "../../db/db.service";
import { SqlLoaderService } from "../../common/sql-loader.service";

@Injectable()
export class TopcoderReportsService {
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getMemberCount() {
    const query = this.sql.load("reports/topcoder/member-count.sql");
    const rows = await this.db.query<{ "user.count": string | number }>(query);
    const value = rows?.[0]?.["user.count"];
    return { "user.count": Number(value ?? 0) };
  }
}
