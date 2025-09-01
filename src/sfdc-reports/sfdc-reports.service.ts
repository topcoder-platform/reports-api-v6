import { Injectable } from "@nestjs/common";
import { DbService } from "../db/db.service";
import { Logger } from "src/common/logger";
import { PaymentsReportQueryDto } from "./sfdc-reports.dto";

@Injectable()
export class SfdcReportsService {
  private readonly logger = new Logger(SfdcReportsService.name);

  constructor(
    private readonly db: DbService,
  ) {}

  async getPaymentsReport(filters: PaymentsReportQueryDto) {
    this.logger.debug("Starting getPaymentsReport with filters:", filters);

    const params: any[] = [];
    const whereClauses: string[] = [];

    // Filter by billing accounts
    if (filters.billingAccountIds) {
      params.push(filters.billingAccountIds);
      whereClauses.push(`p.billing_account = ANY($${params.length})`);
    }

    // Filter by challenge ids
    if (filters.challengeIds) {
      params.push(filters.challengeIds);
      whereClauses.push(`c.id = ANY($${params.length})`);
    }

    // Filter by handles
    if (filters.handles) {
      params.push(filters.handles);
      whereClauses.push(`
        w.winner_id IN (
          SELECT m."userId"::text
          FROM members.member m
          WHERE m.handle = ANY($${params.length})
        )
      `);
    }

    // Filter by challenge name
    if (filters.challengeName) {
      params.push(`%${filters.challengeName}%`);
      whereClauses.push(`
        w.external_id IN (
          SELECT c.id
          FROM challenges."Challenge" c
          WHERE c.name ILIKE $${params.length}
        )
      `);
    }

    if (filters.startDate) {
      params.push(filters.startDate);
      whereClauses.push(`p.created_at >= $${params.length}::timestamptz`);
    }

    if (filters.endDate) {
      params.push(filters.endDate);
      whereClauses.push(`p.created_at <= $${params.length}::timestamptz`);
    }

    if (filters.minPaymentAmount) {
      params.push(filters.minPaymentAmount);
      whereClauses.push(`p.total_amount >= $${params.length}::numeric`);
    }

    if (filters.maxPaymentAmount) {
      params.push(filters.maxPaymentAmount);
      whereClauses.push(`p.total_amount <= $${params.length}::numeric`);
    }

    // Final WHERE clause
    const whereSQL = whereClauses.length > 0 ? `WHERE ${whereClauses.join(" AND ")}` : "";

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
      `
      SELECT 
        p.payment_id as "paymentId",
        p.created_at as "paymentDate",
        p.billing_account as "billingAccountId",
        p.payment_status as "paymentStatus",
        p.challenge_fee as "challengeFee",
        p.total_amount as "paymentAmount",
        w.external_id as "challengeId",
        w.category,
        (w.category = 'TASK_PAYMENT') AS "isTask",
        c.name AS "challengeName",
        m.handle AS "winnerHandle",
        m."userId" as "winnerId",
        m."firstName" as "winnerFirstName",
        m."lastName" as "winnerLastName"
      FROM finance.payment p
      LEFT JOIN finance.winnings w ON w.winning_id = p.winnings_id
      LEFT JOIN challenges."Challenge" c ON c.id = w.external_id
      LEFT JOIN members.member m ON m."userId" = w.winner_id::bigint
      ${whereSQL}
      LIMIT 1000
      `,
      params as string[],
    );

    this.logger.debug("Mapped payments to the final report format");

    return payments;
  }
}
