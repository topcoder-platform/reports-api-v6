import { Injectable } from "@nestjs/common";
import { DbService } from "../db/db.service";
import { Logger } from "src/common/logger";
import {
  BaFeesReportQueryDto,
  BaFeesReportResponse,
  PaymentsReportQueryDto,
  PaymentsReportResponse,
} from "./sfdc-reports.dto";
import { SqlLoaderService } from "src/common/sql-loader.service";

@Injectable()
export class SfdcReportsService {
  private readonly logger = new Logger(SfdcReportsService.name);

  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getPaymentsReport(filters: PaymentsReportQueryDto) {
    this.logger.debug("Starting getPaymentsReport with filters:", filters);

    const query = this.sql.load("reports/sfdc/payments.sql");

    const payments = await this.db.query<PaymentsReportResponse>(query, [
      filters.billingAccountIds,
      filters.challengeIds,
      filters.handles,
      filters.challengeName,
      filters.startDate,
      filters.endDate,
      filters.minPaymentAmount,
      filters.maxPaymentAmount,
    ]);

    this.logger.debug("Mapped payments to the final report format");

    return payments;
  }

  async getBaFeesReport(filters: BaFeesReportQueryDto) {
    this.logger.debug("Starting getBaFeesReport with filters:", filters);

    const query = this.sql.load("reports/sfdc/ba-fees.sql");

    const report = await this.db.query<BaFeesReportResponse>(query, [
      filters.startDate,
      filters.endDate,
    ]);

    this.logger.debug("Mapped BA fees to the final report format");

    return report;
  }
}
