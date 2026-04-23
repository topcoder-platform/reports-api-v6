import { DbService } from "../../db/db.service";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { PaymentReportsService } from "./payment-reports.service";

describe("PaymentReportsService", () => {
  let service: PaymentReportsService;
  let db: { query: jest.Mock };
  let sql: { load: jest.Mock };

  beforeEach(() => {
    db = {
      query: jest.fn().mockResolvedValue([
        {
          payment_created_at: new Date("2024-01-15T12:00:00.000Z"),
          payment_id: "payment-123",
          payment_description: "Challenge payout",
          challenge_id: "3001",
          payment_status: "OWED",
          payment_type: "Challenge Payment",
          payee_handle: "tourist",
          payment_method: "PayPal",
          billing_account_name: "BA One",
          customer_name: "Client One",
          reporting_account_name: "End Customer One",
          member_id: "4001",
          challenge_created_date: "2024-01-01",
          user_payment_gross_amount: "150.50",
        },
      ]),
    };

    sql = {
      load: jest.fn().mockReturnValue("SELECT 1"),
    };

    service = new PaymentReportsService(
      db as unknown as DbService,
      sql as unknown as SqlLoaderService,
    );
  });

  it("loads the payment SQL and maps the accrual rows", async () => {
    await expect(
      service.getMemberPaymentAccrual("2024-01-01", "2024-01-31", [
        "Challenge Payment",
      ]),
    ).resolves.toEqual([
      {
        paymentCreatedAt: "2024-01-15T12:00:00.000Z",
        paymentId: "payment-123",
        paymentDescription: "Challenge payout",
        challengeId: "3001",
        paymentStatus: "OWED",
        paymentType: "Challenge Payment",
        payeeHandle: "tourist",
        payeePaymentMethod: "PayPal",
        billingAccountName: "BA One",
        customerName: "Client One",
        reportingAccountName: "End Customer One",
        memberId: "4001",
        challengeCreatedAt: "2024-01-01",
        userPaymentGrossAmount: 150.5,
      },
    ]);

    expect(sql.load).toHaveBeenCalledWith(
      "reports/payment/member-payment-accrual.sql",
    );
    expect(db.query).toHaveBeenCalledWith("SELECT 1", [
      "2024-01-01",
      "2024-01-31",
      ["Challenge Payment"],
    ]);
  });
});
