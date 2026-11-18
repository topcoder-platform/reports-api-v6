import { BadGatewayException } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { DbService } from "../../db/db.service";
import { SalesReportsService } from "../sales/sales-reports.service";
import { SalesDashboardSection } from "./sales-dashboard.dto";
import { SalesDashboardService } from "./sales-dashboard.service";

describe("Goods sold customer payment scopes", () => {
  const query = jest.fn();
  const getBillingAccountOfferings = jest.fn();
  const range = { startDate: "2028-02-15", endDate: "2028-03-01" };
  const accounts = ["1", "2", "3", "unknown"].map((billing_account_id) => ({
    kind: "billing-account",
    billing_account_id,
  }));
  const customer = (
    month: string,
    amount: string,
    booking_amount: string | null,
  ) => ({
    month,
    amount,
    booking_amount,
    kind: "customer",
    customer_id: "client",
    customer_label: "Customer",
  });
  const api = () =>
    new SalesDashboardService(
      { query } as unknown as DbService,
      new SqlLoaderService(),
      { getBillingAccountOfferings } as unknown as SalesReportsService,
      new ConfigService(),
    );
  beforeEach(() => {
    jest.resetAllMocks();
    query.mockResolvedValue([
      ...accounts,
      customer("2028-02-01", "100", "125"),
    ]);
    getBillingAccountOfferings.mockResolvedValue(
      new Map([
        ["1", "AI Training"],
        ["2", "Flexible Talent"],
      ]),
    );
  });

  it("exposes both measures and all offerings without changing member totals", async () => {
    const result = await api().load(SalesDashboardSection.Payments, range);
    expect(query).toHaveBeenCalledTimes(1);
    expect(
      result.customerPayments?.months[0].values['["client","Customer"]'],
    ).toBe(100);
    expect(
      result.customerBookingCosts?.months[0].values['["client","Customer"]'],
    ).toBe(125);
    expect(result.customerBookingCosts?.series).toEqual(
      result.customerPayments?.series,
    );
    expect(result.filterOptions?.offeringType).toEqual([
      "AI Training",
      "Flexible Talent",
      "Unknown",
    ]);
    expect(result.notices).toEqual([]);
  });

  it.each([
    [
      ["AI Training", "Flexible Talent"],
      ["1", "2"],
    ],
    [["Unknown"], ["3", "unknown"]],
    [["Not present"], []],
  ])(
    "resolves %j to account IDs before aggregation",
    async (offeringType, selected) => {
      query
        .mockResolvedValueOnce(accounts)
        .mockResolvedValueOnce([customer("2028-02-01", "80", "100")]);
      const result = await api().load(SalesDashboardSection.Payments, {
        ...range,
        portal: "sales",
        offeringType,
      });
      expect(query).toHaveBeenLastCalledWith(expect.any(String), [
        "2028-02-15T00:00:00.000Z",
        "2028-03-01T00:00:00.000Z",
        true,
        false,
        selected,
      ]);
      expect(
        result.customerPayments?.months[0].values['["client","Customer"]'],
      ).toBe(80);
      expect(
        result.customerBookingCosts?.months[0].values['["client","Customer"]'],
      ).toBe(100);
      expect(result.filterOptions?.offeringType).toEqual([
        "AI Training",
        "Flexible Talent",
        "Unknown",
      ]);
    },
  );

  it("keeps all-payment and booking amounts available on a lookup failure, but rejects filtered requests", async () => {
    getBillingAccountOfferings.mockRejectedValue(
      new BadGatewayException("upstream unavailable"),
    );
    const service = api();
    const result = await service.load(SalesDashboardSection.Payments, range);
    expect(
      result.customerBookingCosts?.months[0].values['["client","Customer"]'],
    ).toBe(125);
    expect(result.notices).toContain(
      "Offering type details are unavailable. All payment offerings are included.",
    );
    await expect(
      service.load(SalesDashboardSection.Payments, {
        ...range,
        offeringType: ["AI Training"],
      }),
    ).rejects.toThrow("upstream unavailable");
  });

  it("preserves unavailable fees, negative adjustments and zero-filled months", async () => {
    query.mockResolvedValue([
      customer("2028-02-01", "100", null),
      customer("2028-03-01", "-20", "-25"),
    ]);
    const result = await api().load(SalesDashboardSection.Payments, {
      ...range,
      endDate: "2028-05-01",
    });
    expect(
      result.customerBookingCosts?.months.map(
        (month) => month.values['["client","Customer"]'],
      ),
    ).toEqual([null, -25, 0]);
    expect(result.notices[0]).toContain("Some challenge fees are unavailable");
  });

  it("returns empty matrices without Salesforce requests for empty data", async () => {
    query.mockResolvedValue([]);
    const result = await api().load(SalesDashboardSection.Payments, range);
    expect(result.customerPayments?.series).toEqual([]);
    expect(result.customerBookingCosts?.series).toEqual([]);
    expect(getBillingAccountOfferings).not.toHaveBeenCalled();
  });

  it("keeps TaaS independent from offering lookups and booking matrices", async () => {
    const result = await api().load(SalesDashboardSection.TaasPayments, range);
    expect(getBillingAccountOfferings).not.toHaveBeenCalled();
    expect(result.customerBookingCosts).toBeUndefined();
    expect(query).toHaveBeenLastCalledWith(expect.any(String), [
      "2028-02-15T00:00:00.000Z",
      "2028-03-01T00:00:00.000Z",
      false,
      true,
      null,
    ]);
  });
});
