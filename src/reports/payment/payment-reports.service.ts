import { Injectable } from "@nestjs/common";
import { DbService } from "../../db/db.service";
import { SqlLoaderService } from "../../common/sql-loader.service";

type MemberPaymentAccrualRow = {
  payment_created_at: Date | string | null;
  payment_id: string | null;
  payment_description: string | null;
  challenge_id: string | null;
  payment_status: string | null;
  payment_type: string | null;
  payee_handle: string | null;
  payment_method: string | null;
  billing_account_name: string | null;
  customer_name: string | null;
  reporting_account_name: string | null;
  member_id: string | null;
  challenge_created_date: string | null;
  user_payment_gross_amount: string | number | null;
};

@Injectable()
export class PaymentReportsService {
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getMemberPaymentAccrual(
    startDate?: string,
    endDate?: string,
    paymentTypes?: string[],
  ) {
    const query = this.sql.load("reports/payment/member-payment-accrual.sql");
    const rows = await this.db.query<MemberPaymentAccrualRow>(query, [
      startDate ?? null,
      endDate ?? null,
      paymentTypes?.length ? paymentTypes : null,
    ]);

    return rows.map((row) => ({
      paymentCreatedAt: this.normalizeDate(row.payment_created_at),
      paymentId: row.payment_id ?? null,
      paymentDescription: row.payment_description ?? null,
      challengeId: row.challenge_id ?? null,
      paymentStatus: row.payment_status ?? null,
      paymentType: row.payment_type ?? null,
      payeeHandle: row.payee_handle ?? null,
      payeePaymentMethod: row.payment_method ?? null,
      billingAccountName: row.billing_account_name ?? null,
      customerName: row.customer_name ?? null,
      reportingAccountName: row.reporting_account_name ?? null,
      memberId: row.member_id ?? null,
      challengeCreatedAt: row.challenge_created_date ?? null,
      userPaymentGrossAmount: this.toNullableNumber(
        row.user_payment_gross_amount,
      ),
    }));
  }

  private toNullableNumber(value: string | number | null | undefined) {
    if (value === null || value === undefined) {
      return null;
    }

    return Number(value);
  }

  private normalizeDate(value: Date | string | null | undefined) {
    if (value === null || value === undefined) {
      return null;
    }

    if (value instanceof Date) {
      return value.toISOString();
    }

    return value;
  }
}
