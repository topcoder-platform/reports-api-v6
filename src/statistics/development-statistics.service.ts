import { Injectable } from "@nestjs/common";
import { DbService } from "../db/db.service";
import { SqlLoaderService } from "../common/sql-loader.service";
import { alpha3ToCountryName } from "../common/country.util";

@Injectable()
export class DevelopmentStatisticsService {
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getCodeWins() {
    const q = this.sql.load("reports/statistics/development/code-wins.sql");
    return this.db.query(q);
  }

  async getDevelopmentF2FWins() {
    const q = this.sql.load(
      "reports/statistics/development/development-f2f-wins.sql",
    );
    return this.db.query(q);
  }

  async getPrototypeWins() {
    const q = this.sql.load(
      "reports/statistics/development/prototype-wins.sql",
    );
    return this.db.query(q);
  }

  async getDevelopmentFirstPlaceWins() {
    const q = this.sql.load(
      "reports/statistics/development/first-place-wins.sql",
    );
    return this.db.query(q);
  }

  async getFirstTimeDevelopmentSubmitters() {
    const q = this.sql.load(
      "reports/statistics/development/first-time-development-submitters.sql",
    );
    return this.db.query(q);
  }

  async getDevelopmentCountriesRepresented() {
    const q = this.sql.load(
      "reports/statistics/development/development-countries-represented.sql",
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

  async getDevelopmentChallengesByTechnology() {
    const q = this.sql.load(
      "reports/statistics/development/challenges-technology.sql",
    );
    return this.db.query(q);
  }
}
