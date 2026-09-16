import { ConfigService } from "@nestjs/config";
import {
  BadGatewayException,
  ServiceUnavailableException,
} from "@nestjs/common";
import { SalesforceReportsClient } from "./salesforce-reports.client";

describe("SalesforceReportsClient", () => {
  const reportId = "00O1K00000A7UGDUA3";
  let client: SalesforceReportsClient;
  let request: jest.SpyInstance;
  /** @param token Synthetic test token. @returns A mock OAuth response. Does not throw. */
  function oauth(token = "test-token"): Response {
    return Response.json({
      access_token: token,
      instance_url: "https://topcoder.my.salesforce.com",
    });
  }
  beforeEach(() => {
    request = jest.spyOn(global, "fetch");
    client = new SalesforceReportsClient(
      new ConfigService({
        SALESFORCE_API_CONSUMER_KEY: "test-client",
        SALESFORCE_API_CONSUMER_SECRET: "test-secret",
      }),
    );
  });
  afterEach(() => jest.restoreAllMocks());

  it("keeps OAuth on the server and performs only GET report reads with details", async () => {
    request
      .mockResolvedValueOnce(oauth())
      .mockResolvedValueOnce(Response.json({ allData: true }));
    expect(await client.runReport(reportId)).toEqual({ allData: true });
    expect(request.mock.calls[0][1].method).toBe("POST");
    expect(request.mock.calls[0][1].body.toString()).toContain(
      "grant_type=client_credentials",
    );
    expect(request.mock.calls[1][0]).toBe(
      `https://topcoder.my.salesforce.com/services/data/v65.0/analytics/reports/${reportId}?includeDetails=true`,
    );
    expect(request.mock.calls[1][1]).toMatchObject({
      redirect: "error",
      headers: { Authorization: "Bearer test-token" },
    });
    expect(request.mock.calls[1][1].method).toBeUndefined();
  });
  it("renews expired sessions once", async () => {
    request
      .mockResolvedValueOnce(oauth())
      .mockResolvedValueOnce(new Response("", { status: 401 }))
      .mockResolvedValueOnce(oauth("renewed"))
      .mockResolvedValueOnce(Response.json({ allData: true }));
    await client.runReport(reportId);
    expect(request).toHaveBeenCalledTimes(4);
    expect(request.mock.calls[3][1].headers.Authorization).toBe(
      "Bearer renewed",
    );
  });
  it("retries transient failures and does not retry forbidden reports", async () => {
    request
      .mockResolvedValueOnce(oauth())
      .mockResolvedValueOnce(
        new Response("private upstream body", { status: 503 }),
      )
      .mockResolvedValueOnce(new Response("", { status: 429 }))
      .mockResolvedValueOnce(Response.json({ allData: true }));
    await expect(client.runReport(reportId)).resolves.toEqual({
      allData: true,
    });
    request.mockResolvedValueOnce(
      new Response("private upstream body", { status: 403 }),
    );
    await expect(client.runReport(reportId)).rejects.toThrow(
      "Salesforce report could not be loaded",
    );
    expect(request).toHaveBeenCalledTimes(5);
  });
  it("bounds network retries and sanitizes errors", async () => {
    request.mockRejectedValue(new Error("secret network details"));
    await expect(client.runReport(reportId)).rejects.toBeInstanceOf(
      BadGatewayException,
    );
    expect(request).toHaveBeenCalledTimes(3);
  });
  it("rejects unconfigured credentials, invalid IDs and untrusted OAuth origins", async () => {
    await expect(
      new SalesforceReportsClient(new ConfigService()).runReport(reportId),
    ).rejects.toBeInstanceOf(ServiceUnavailableException);
    await expect(client.runReport("../../secrets")).rejects.toBeInstanceOf(
      ServiceUnavailableException,
    );
    expect(request).not.toHaveBeenCalled();
    request.mockResolvedValueOnce(
      Response.json({
        access_token: "test-token",
        instance_url: "https://example.com",
      }),
    );
    await expect(client.runReport(reportId)).rejects.toBeInstanceOf(
      ServiceUnavailableException,
    );
    expect(request).toHaveBeenCalledTimes(1);
  });
});
