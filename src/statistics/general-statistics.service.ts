import { Injectable } from "@nestjs/common";
import { DbService } from "../db/db.service";
import { SqlLoaderService } from "../common/sql-loader.service";

@Injectable()
export class GeneralStatisticsService {
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getMemberCount() {
    const q = this.sql.load("reports/statistics/general/member-count.sql");
    const rows = await this.db.query<{ count: string }>(q);
    const count = rows?.[0]?.count ? Number(rows[0].count) : 0;
    return { count };
  }

  async getTotalPrizes() {
    const q = this.sql.load("reports/statistics/general/total-prizes.sql");
    const rows = await this.db.query<{ total: string }>(q);
    const total = rows?.[0]?.total ? rows[0].total : "0";
    return { total };
  }

  async getCompletedChallengesCount() {
    const q = this.sql.load(
      "reports/statistics/general/completed-challenges.sql",
    );
    const rows = await this.db.query<{ count: string }>(q);
    const count = rows?.[0]?.count ? Number(rows[0].count) : 0;
    return { count };
  }

  async getCountriesRepresented() {
    const q = this.sql.load(
      "reports/statistics/general/countries-represented.sql",
    );
    return this.db.query(q);
  }

  async getFirstPlaceByCountry() {
    const q = this.sql.load(
      "reports/statistics/general/first-place-by-country.sql",
    );
    return this.db.query(q);
  }

  async getCopilotedChallenges() {
    const q = this.sql.load(
      "reports/statistics/general/copiloted-challenges.sql",
    );
    return this.db.query(q);
  }

  async getReviewCountsByMember() {
    const q = this.sql.load(
      "reports/statistics/general/reviews-by-member.sql",
    );
    return this.db.query(q);
  }
}

