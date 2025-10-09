import { Injectable } from "@nestjs/common";
import { DbService } from "../db/db.service";
import { SqlLoaderService } from "../common/sql-loader.service";

@Injectable()
export class DesignStatisticsService {
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getUiDesignWins() {
    const q = this.sql.load(
      "reports/statistics/design/ui-design-wins.sql",
    );
    return this.db.query(q);
  }

  async getDesignF2FWins() {
    const q = this.sql.load(
      "reports/statistics/design/design-f2f-wins.sql",
    );
    return this.db.query(q);
  }

  async getFirstTimeDesignSubmitters() {
    const q = this.sql.load(
      "reports/statistics/design/first-time-design-submitters.sql",
    );
    return this.db.query(q);
  }

  async getDesignCountriesRepresented() {
    const q = this.sql.load(
      "reports/statistics/design/design-countries-represented.sql",
    );
    return this.db.query(q);
  }

  async getFirstPlaceByCountry() {
    const q = this.sql.load(
      "reports/statistics/design/first-place-by-country.sql",
    );
    return this.db.query(q);
  }
}
