import { Injectable } from "@nestjs/common";
import { DbService } from "../db/db.service";
import { SqlLoaderService } from "../common/sql-loader.service";
import { alpha3ToCountryName } from "../common/country.util";

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
    return { "user.count": count };
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
    return { "challenge.count": count };
  }

  async getCountriesRepresented() {
    const q = this.sql.load(
      "reports/statistics/general/countries-represented.sql",
    );
    const rows = await this.db.query<{
      country_code: string | null;
      "user.count": number | string | null;
      rank: number | string | null;
    }>(q);
    return rows.map((row) => {
      const countryName =
        alpha3ToCountryName(row.country_code) ?? row.country_code ?? "";
      return {
        "country.country_name": countryName,
        "user.count": Number(row["user.count"] ?? 0),
        rank: row.rank !== null && row.rank !== undefined ? Number(row.rank) : null,
      };
    });
  }

  async getFirstPlaceByCountry() {
    const q = this.sql.load(
      "reports/statistics/general/first-place-by-country.sql",
    );
    const rows = await this.db.query<{
      country_code: string | null;
      "challenge_stats.count": number | string | null;
      rank: number | string | null;
    }>(q);
    return rows.map((row) => {
      const countryName =
        alpha3ToCountryName(row.country_code) ?? row.country_code ?? "";
      return {
        "country.country_name": countryName,
        "challenge_stats.count": Number(row["challenge_stats.count"] ?? 0),
        rank: row.rank !== null && row.rank !== undefined ? Number(row.rank) : null,
      };
    });
  }

  async getCopilotedChallenges() {
    const q = this.sql.load(
      "reports/statistics/general/copiloted-challenges.sql",
    );
    return this.db.query(q);
  }

  async getReviewCountsByMember() {
    const q = this.sql.load("reports/statistics/general/reviews-by-member.sql");
    return this.db.query(q);
  }
}
