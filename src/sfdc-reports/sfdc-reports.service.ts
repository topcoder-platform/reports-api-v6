import { Injectable } from "@nestjs/common";
import { DbService } from "../db/db.service";
import { Logger } from "src/common/logger";
import { PaymentsReportQueryDto } from "./sfdc-reports.dto";
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

    const payments = await this.db.query<{
      billingAccountId: string,
      challengeName: string,
      challengeId: string,
      paymentDate: Date,
      paymentId: string,
      paymentStatus: string,
      winnerId: string,
      winnerHandle: string,
      winnerFirstName: string,
      winnerLastName: string,
      isTask: boolean,
      challengeFee: number,
      paymentAmount: number,
    }>(
      query,
      [
        filters.billingAccountIds,
        filters.challengeIds,
        filters.handles,
        filters.challengeName,
        filters.startDate,
        filters.endDate,
        filters.minPaymentAmount,
        filters.maxPaymentAmount,
      ]
    );

    this.logger.debug("Mapped payments to the final report format");

    return payments;
  }
}
