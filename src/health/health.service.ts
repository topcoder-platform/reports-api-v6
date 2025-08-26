import { Injectable } from "@nestjs/common";
import { DbService } from "../db/db.service";

@Injectable()
export class HealthService {
  constructor(private readonly db: DbService) {}

  async check() {
    // A simple, fast query to check if the database is reachable and responsive.
    await this.db.query('SELECT 1');
    return {
      status: "ok",
      info: {
        database: {
          status: "up",
        },
      },
      error: {},
      details: {
        database: {
          status: "up",
        },
      },
    };
  }
}
