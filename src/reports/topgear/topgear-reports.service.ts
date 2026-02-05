import { Injectable, BadRequestException } from "@nestjs/common";
import { DbService } from "../../db/db.service";
import { SqlLoaderService } from "../../common/sql-loader.service";
import {
  parseOptionalDate,
  defaultStartDate,
  defaultEndDate,
} from "../../common/validation.util";
import { ChallengeStatsByUserDto } from "./dtos/challenge-stats-by-user.dto";
import { subDays } from "date-fns";

@Injectable()
export class TopgearReportsService {
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getTopgearHourly() {
    const query = this.sql.load("reports/topgear/hourly.sql");
    return this.db.query(query);
  }

  async getTopgearHandles(opts: { startDate?: string }) {
    const startDate =
      parseOptionalDate(opts.startDate) ?? subDays(new Date(), 90);
    const query = this.sql.load("reports/topgear/topgear-handles.sql");
    return this.db.query(query, [startDate.toISOString()]);
  }

  async getChallengeStatsByUser(opts: {
    startDate?: string;
    endDate?: string;
  }): Promise<ChallengeStatsByUserDto[]> {
    const startDate = opts.startDate
      ? new Date(opts.startDate)
      : subDays(new Date(), 7);
    const endDate = opts.endDate ? new Date(opts.endDate) : new Date();

    if (startDate > endDate) {
      throw new BadRequestException("start_date must be <= end_date");
    }

    const query = this.sql.load("reports/topgear/challenge-stats-by-user.sql");
    return this.db.query<ChallengeStatsByUserDto>(query, [startDate, endDate]);
  }
  async getTopgearRegistrantsDetails(opts: { start?: string; end?: string }) {
    const startDate = parseOptionalDate(opts.start) ?? defaultStartDate();
    const endDate = parseOptionalDate(opts.end) ?? defaultEndDate();

    if (startDate > endDate) {
      throw new BadRequestException("start_date must be <= end_date");
    }

    const query = this.sql.load(
      "reports/topgear/topgear-registrants-details.sql",
    );
    return this.db.query(query, [
      startDate.toISOString(),
      endDate.toISOString(),
    ]);
  }

  async getChallengesCountBySkill() {
    const query = this.sql.load("reports/topgear/challenge-count-by-skill.sql");
    return this.db.query(query);
  }

  async getTopgearPayments(opts: { start?: string; end?: string }) {
    const startDate = parseOptionalDate(opts.start) ?? defaultStartDate();
    const endDate = parseOptionalDate(opts.end) ?? defaultEndDate();

    if (startDate > endDate) {
      throw new BadRequestException("start_date must be <= end_date");
    }

    const query = this.sql.load("reports/topgear/payments.sql");
    // Postgres parameter placeholders: $1, $2
    return this.db.query(query, [
      startDate.toISOString(),
      endDate.toISOString(),
    ]);
  }

  async getTopgearChallenge(opts: { start?: string; end?: string }) {
    const startDate = parseOptionalDate(opts.start) ?? defaultStartDate();
    const endDate = parseOptionalDate(opts.end) ?? defaultEndDate();

    if (startDate > endDate) {
      throw new BadRequestException("start_date must be <= end_date");
    }

    const query = this.sql.load("reports/topgear/challenge.sql");
    // Postgres parameter placeholders: $1, $2
    return this.db.query(query, [
      startDate.toISOString(),
      endDate.toISOString(),
    ]);
  }

  async getTopgearCancelledChallenge(opts: { start?: string; end?: string }) {
    const startDate = parseOptionalDate(opts.start) ?? defaultStartDate();
    const endDate = parseOptionalDate(opts.end) ?? defaultEndDate();

    if (startDate > endDate) {
      throw new BadRequestException("start_date must be <= end_date");
    }

    const query = this.sql.load("reports/topgear/cancelled-challenge.sql");
    return this.db.query(query, [
      startDate.toISOString(),
      endDate.toISOString(),
    ]);
  }
}
