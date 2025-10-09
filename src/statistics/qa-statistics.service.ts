import { Injectable } from "@nestjs/common";
import { DbService } from "../db/db.service";
import { SqlLoaderService } from "../common/sql-loader.service";

@Injectable()
export class QaStatisticsService {
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getWins() {
    const q = this.sql.load("reports/statistics/qa/wins.sql");
    return this.db.query(q);
  }
}
