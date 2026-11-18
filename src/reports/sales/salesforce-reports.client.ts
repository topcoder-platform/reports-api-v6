import {
  BadGatewayException,
  Injectable,
  Logger,
  ServiceUnavailableException,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { setTimeout as delay } from "node:timers/promises";
import { categoryValue } from "./sales-category.utils";

export interface SalesforceGrouping {
  key: string;
  label: string;
  value?: unknown;
  groupings: SalesforceGrouping[];
}

/** Runtime-only report filters; never saved back to Salesforce. */
export interface SalesforceReportFilter {
  column: string;
  operator: string;
  value: string;
}

/** Execution overrides shared by pipeline and historical summary reports. */
export interface SalesforceReportOverrides {
  detailColumns?: string[];
  aggregates?: string[];
  groupingsDown?: Array<{ name: string; sortOrder?: string }>;
  groupingsAcross?: Array<{ name: string }>;
  reportFormat?: string;
  reportFilters?: SalesforceReportFilter[];
  reportBooleanFilter?: string | null;
  standardDateFilter?: {
    column: string;
    durationValue: string;
    startDate: string;
    endDate: string;
  };
  showGrandTotal?: boolean;
  showSubtotals?: boolean;
}

export interface SalesforceReport {
  allData?: boolean;
  hasDetailRows?: boolean;
  reportMetadata: {
    id: string;
    name: string;
    detailColumns: string[];
    reportFormat?: string;
    groupingsDown?: Array<{ name: string }>;
    groupingsAcross?: Array<{ name: string }>;
    aggregates?: string[];
    reportFilters?: SalesforceReportFilter[];
    reportBooleanFilter?: string | null;
  };
  reportExtendedMetadata: {
    detailColumnInfo: Record<string, { label: string; dataType: string }>;
    groupingColumnInfo?: Record<string, { label: string; dataType: string }>;
  };
  groupingsDown?: { groupings: SalesforceGrouping[] };
  groupingsAcross?: { groupings: SalesforceGrouping[] };
  factMap: Record<
    string,
    {
      rows?: Array<{ dataCells: Array<{ label?: string; value?: unknown }> }>;
      aggregates?: Array<{ value: number | null; label?: string }>;
    }
  >;
}

interface SalesforceSession {
  access_token: string;
  instance_url: string;
}

/**
 * Server-only Salesforce Analytics client. Runs existing reports without modifying
 * records or report definitions. Reusable for future authorized report services.
 */
@Injectable()
export class SalesforceReportsClient {
  private readonly logger = new Logger(SalesforceReportsClient.name);
  private session?: SalesforceSession;
  private authenticating?: Promise<SalesforceSession>;
  private quotaRetryAt = 0;
  private readonly billingOfferings = new Map<
    string,
    { expires: number; offering?: string }
  >();

  /** @param config Server environment configuration. Creates a lazy client; does not authenticate or throw. */
  constructor(private readonly config: ConfigService) {}

  /**
   * Validates a configured or OAuth-provided Salesforce origin before sending credentials.
   * @param origin HTTPS Salesforce origin, without a path, credentials, query, or custom port.
   * @returns Normalized trusted origin.
   * @throws ServiceUnavailableException for missing or invalid configuration.
   */
  private salesforceOrigin(origin: string): string {
    try {
      const url = new URL(origin);
      if (
        url.protocol === "https:" &&
        !url.username &&
        !url.password &&
        !url.port &&
        url.pathname === "/" &&
        !url.search &&
        !url.hash &&
        (url.hostname.endsWith(".my.salesforce.com") ||
          ["login.salesforce.com", "test.salesforce.com"].includes(
            url.hostname,
          ))
      ) {
        return url.origin;
      }
    } catch {
      /* Invalid URLs use the same sanitized configuration error. */
    }
    throw new ServiceUnavailableException(
      "Salesforce report integration is not configured.",
    );
  }

  /**
   * Performs a bounded request with retries for network errors, throttling and 5xx.
   * @param url Trusted Salesforce API URL.
   * @param init HTTP request options; bodies and credentials are never logged.
   * @returns The first non-transient HTTP response.
   * @throws BadGatewayException after three failed attempts or an unreadable response.
   */
  private async request(url: string, init: RequestInit): Promise<Response> {
    for (let attempt = 0; attempt < 3; attempt++) {
      let retryAfter = 0;
      try {
        const response = await fetch(url, {
          ...init,
          redirect: "error",
          signal: AbortSignal.timeout(15000),
        });
        if (response.status !== 429 && response.status < 500) return response;
        const header = response.headers.get("retry-after");
        retryAfter = header ? Number(header) * 1000 : 0;
        await response.body?.cancel();
        this.logger.warn(
          `Salesforce temporarily unavailable (HTTP ${response.status}).`,
        );
      } catch {
        this.logger.warn("Salesforce request timed out or failed to connect.");
      }
      if (attempt < 2) {
        await delay(
          Math.min(
            2000,
            Math.max(
              250 * 2 ** attempt,
              Number.isFinite(retryAfter) ? retryAfter : 0,
            ),
          ),
        );
      }
    }
    throw new BadGatewayException(
      "Salesforce is temporarily unavailable. Please try again.",
    );
  }

  /**
   * Logs bounded Salesforce error details without logging the full response or credentials.
   * @param response Failed OAuth or report response.
   * @param operation Safe operation name and, for reports, the configured report ID.
   * @returns True when Salesforce says the synchronous report quota is exhausted.
   * @throws Does not throw for missing, malformed, or unreadable error bodies.
   */
  private async logRejection(
    response: Response,
    operation: string,
  ): Promise<boolean> {
    let details = "";
    let quotaExceeded = false;
    try {
      const body: unknown = await response.json();
      const errors = Array.isArray(body) ? body : [body];
      details = errors
        .slice(0, 3)
        .map((error: unknown) => {
          if (!error || typeof error !== "object") return "";
          const item = error as Record<string, unknown>;
          const code =
            typeof item.errorCode === "string"
              ? item.errorCode
              : typeof item.error === "string"
                ? item.error
                : "";
          const message =
            typeof item.message === "string"
              ? item.message
              : typeof item.error_description === "string"
                ? item.error_description
                : "";
          if (
            response.status === 403 &&
            /more than 500 reports synchronously every 60 minutes/i.test(
              message,
            )
          )
            quotaExceeded = true;
          const safeCode = code.replace(/[^a-zA-Z0-9_]/g, "").slice(0, 64);
          let safeMessage = message
            // eslint-disable-next-line no-control-regex -- Intentionally remove control characters from log messages.
            .replace(/[\r\n\t\x00-\x1f\x7f]/g, " ")
            .replace(/Bearer\s+\S+/gi, "Bearer [redacted]")
            .slice(0, 240);
          for (const secret of [
            this.config.get<string>("SALESFORCE_API_CONSUMER_SECRET"),
            this.session?.access_token,
          ]) {
            if (secret)
              safeMessage = safeMessage.split(secret).join("[redacted]");
          }
          return [safeCode, safeMessage].filter(Boolean).join(": ");
        })
        .filter(Boolean)
        .join("; ");
    } catch {
      // JSON parsing may already have consumed or locked the response stream.
    }
    const requestId = response.headers
      .get("sforce-request-id")
      ?.replace(/[^a-zA-Z0-9-]/g, "")
      .slice(0, 80);
    this.logger.warn(
      `Salesforce ${operation} rejected (HTTP ${response.status})${details ? `: ${details}` : ""}${requestId ? `; requestId=${requestId}` : ""}.`,
    );
    return quotaExceeded;
  }

  /**
   * Obtains a client-credentials session, coalescing concurrent token requests.
   * @returns A trusted instance URL and an access token kept only in server memory.
   * @throws ServiceUnavailableException for missing credentials; BadGatewayException on OAuth failure.
   */
  private async authenticate(): Promise<SalesforceSession> {
    if (this.session) return this.session;
    if (this.authenticating) return this.authenticating;
    const clientId = this.config.get<string>("SALESFORCE_API_CONSUMER_KEY");
    const clientSecret = this.config.get<string>(
      "SALESFORCE_API_CONSUMER_SECRET",
    );
    const origin = this.salesforceOrigin(
      this.config.get<string>(
        "SALESFORCE_LOGIN_URL",
        "https://topcoder.my.salesforce.com",
      ),
    );
    if (!clientId || !clientSecret) {
      throw new ServiceUnavailableException(
        "Salesforce report integration is not configured.",
      );
    }
    this.authenticating = (async () => {
      const response = await this.request(`${origin}/services/oauth2/token`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
          grant_type: "client_credentials",
          client_id: clientId,
          client_secret: clientSecret,
        }),
      });
      if (!response.ok) {
        await this.logRejection(response, "authentication");
        throw new BadGatewayException(
          "Salesforce authentication failed. Contact your administrator.",
        );
      }
      let token: SalesforceSession;
      try {
        token = (await response.json()) as SalesforceSession;
      } catch {
        throw new BadGatewayException(
          "Salesforce returned an invalid authentication response.",
        );
      }
      if (
        !token ||
        typeof token.access_token !== "string" ||
        !token.access_token
      ) {
        throw new BadGatewayException(
          "Salesforce returned an invalid authentication response.",
        );
      }
      this.session = {
        access_token: token.access_token,
        instance_url: this.salesforceOrigin(token.instance_url),
      };
      return this.session;
    })();
    try {
      return await this.authenticating;
    } finally {
      this.authenticating = undefined;
    }
  }

  /**
   * Runs a report with optional execution-only filters/groupings; never saves it.
   * @param reportId Server-selected 15/18-character Salesforce report ID.
   * @param metadata Optional server-generated execution overrides.
   * @param includeDetails Whether to download detail rows (existing pipeline default).
   * @returns Unmodified Analytics report JSON for normalization.
   * @throws ServiceUnavailableException for invalid configuration; BadGatewayException on upstream failure.
   */
  async runReport(
    reportId: string,
    metadata?: SalesforceReportOverrides,
    includeDetails = true,
  ): Promise<SalesforceReport> {
    return this.reportRequest(
      reportId,
      `?includeDetails=${includeDetails}`,
      metadata
        ? {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ reportMetadata: metadata }),
          }
        : {},
    );
  }

  /**
   * Reads a saved report's metadata before adding execution filters.
   * @param reportId Server-selected report ID.
   * @returns Saved metadata, including its filters and Boolean logic.
   * @throws Sanitized configuration or upstream errors.
   */
  async describeReport(
    reportId: string,
  ): Promise<Pick<SalesforceReport, "reportMetadata">> {
    return this.reportRequest(reportId, "/describe");
  }

  /**
   * Reads the same Customer Type used by Pipeline for revenue-linked opportunities.
   * @param ids Raw lookup IDs; only valid Opportunity IDs are queried, deduplicated in batches of 200.
   * @returns Types keyed by case-sensitive 15-character IDs; missing values remain absent.
   * @throws Sanitized upstream errors, including incomplete query responses. No date filter is applied.
   */
  async getOpportunityCustomerTypes(
    ids: string[],
  ): Promise<Map<string, string>> {
    const unique = [
      ...new Set(
        ids
          .filter((id) => /^006[a-zA-Z0-9]{12}(?:[a-zA-Z0-9]{3})?$/.test(id))
          .map((id) => id.slice(0, 15)),
      ),
    ];
    const types = new Map<string, string>();
    for (let start = 0; start < unique.length; start += 200) {
      const batch = unique.slice(start, start + 200);
      const query = `SELECT Id, New_or_Follow_On__c FROM Opportunity WHERE Id IN (${batch.map((id) => `'${id}'`).join(",")})`;
      const result = await this.dataRequest<{
        done: boolean;
        records: Array<{ Id: string; New_or_Follow_On__c?: string | null }>;
      }>(
        `query?q=${encodeURIComponent(query)}`,
        {},
        "opportunity customer types",
      );
      if (!result || result.done !== true || !Array.isArray(result.records)) {
        throw new BadGatewayException(
          "Salesforce returned incomplete opportunity customer types.",
        );
      }
      for (const record of result.records) {
        const id = typeof record?.Id === "string" ? record.Id.slice(0, 15) : "";
        if (
          batch.includes(id) &&
          typeof record.New_or_Follow_On__c === "string" &&
          record.New_or_Follow_On__c.trim()
        ) {
          types.set(id, record.New_or_Follow_On__c.trim());
        }
      }
    }
    return types;
  }

  /**
   * Resolves payment offerings through the billing account's linked Opportunity.
   * Uses exact numeric Topcoder IDs, never customer names or opportunity close dates.
   * Missing links remain unknown; malformed/incomplete or ambiguous responses fail explicitly.
   * Results (including missing links) are cached for one minute and queried in batches of 200.
   */
  async getBillingAccountOfferings(
    ids: string[],
  ): Promise<Map<string, string>> {
    const unique = [...new Set(ids.filter((id) => /^[1-9]\d{0,9}$/.test(id)))];
    const now = Date.now();
    for (const [id, entry] of this.billingOfferings) {
      if (entry.expires <= now) this.billingOfferings.delete(id);
    }
    const missing = unique.filter((id) => !this.billingOfferings.has(id));
    for (let start = 0; start < missing.length; start += 200) {
      const batch = missing.slice(start, start + 200);
      const query =
        "SELECT TopCoder_Billing_Account_Id__c, Opportunity__r.Engagement_Offering_Type__c, " +
        "Opportunity__r.Name FROM Topcoder_Billing_Account__c WHERE TopCoder_Billing_Account_Id__c IN (" +
        batch.map((id) => `'${id}'`).join(",") +
        ")";
      const result = await this.dataRequest<{
        done: boolean;
        records: Array<{
          TopCoder_Billing_Account_Id__c: string;
          Opportunity__r?: {
            Engagement_Offering_Type__c?: string | null;
            Name?: string;
          } | null;
        }>;
      }>(
        `query?q=${encodeURIComponent(query)}`,
        {},
        "billing account offerings",
      );
      if (!result || result.done !== true || !Array.isArray(result.records)) {
        throw new BadGatewayException(
          "Salesforce returned incomplete billing account offerings.",
        );
      }
      const offerings = new Map<string, string | undefined>();
      for (const record of result.records) {
        const id = record?.TopCoder_Billing_Account_Id__c;
        if (!batch.includes(id)) continue;
        const opportunity = record.Opportunity__r;
        if (
          opportunity != null &&
          (typeof opportunity !== "object" ||
            (opportunity.Engagement_Offering_Type__c != null &&
              typeof opportunity.Engagement_Offering_Type__c !== "string") ||
            (opportunity.Name != null && typeof opportunity.Name !== "string"))
        ) {
          throw new BadGatewayException(
            "Salesforce returned invalid billing account offerings.",
          );
        }
        let offering =
          opportunity?.Engagement_Offering_Type__c?.trim() || undefined;
        // Preserve the same two blank-offering corrections used by customer revenue.
        if (!offering && /^topgear$/i.test(opportunity?.Name?.trim() ?? ""))
          offering = "TopGear";
        if (
          !offering &&
          /^multiple app enhancements? 5$/i.test(
            opportunity?.Name?.trim() ?? "",
          )
        ) {
          offering = "Flexible Talent";
        }
        const canonical = [
          "AI Training",
          "Crowd Powered Outcomes",
          "Crowd Powered Innovation",
          "Flexible Talent",
          "TopGear",
          "TaaS Ops",
        ].find(
          (value) => categoryValue(value) === categoryValue(offering ?? ""),
        );
        offering =
          categoryValue(offering ?? "") === "topgear ops"
            ? "TopGear"
            : (canonical ?? offering);
        if (offerings.has(id) && offerings.get(id) !== offering) {
          throw new BadGatewayException(
            "Salesforce returned conflicting billing account offerings.",
          );
        }
        offerings.set(id, offering);
      }
      for (const id of batch) {
        this.billingOfferings.set(id, {
          expires: Date.now() + 60000,
          offering: offerings.get(id),
        });
      }
    }
    return new Map(
      unique.flatMap((id) => {
        const offering = this.billingOfferings.get(id)?.offering;
        return offering ? [[id, offering]] : [];
      }),
    );
  }

  /**
   * Executes a trusted report request with shared validation, retries and OAuth renewal.
   * @param reportId Configured report ID. @param suffix Internal resource suffix.
   * @param init Optional POST execution body. @returns Parsed report response.
   * @throws ServiceUnavailableException for configuration; BadGatewayException for upstream failures.
   */
  private async reportRequest(
    reportId: string,
    suffix: string,
    init: RequestInit = {},
  ): Promise<SalesforceReport> {
    if (!/^00O[a-zA-Z0-9]{12}(?:[a-zA-Z0-9]{3})?$/.test(reportId)) {
      throw new ServiceUnavailableException(
        "Salesforce report ID is not configured correctly.",
      );
    }
    return this.dataRequest<SalesforceReport>(
      `analytics/reports/${reportId}${suffix}`,
      init,
      `report ${reportId}`,
    );
  }

  /**
   * Executes an internal Salesforce data path with shared OAuth renewal and bounded retries.
   * @param path Server-built relative resource path. @param init HTTP options.
   * @param operation Safe log context. @returns Parsed JSON; never saves report definitions.
   * @throws Sanitized configuration, transport or response errors.
   */
  private async dataRequest<T>(
    path: string,
    init: RequestInit,
    operation: string,
  ): Promise<T> {
    const version = this.config.get<string>("SALESFORCE_API_VERSION", "65.0");
    if (!/^\d{2,3}\.0$/.test(version)) {
      throw new ServiceUnavailableException(
        "Salesforce API version is not configured correctly.",
      );
    }
    if (Date.now() < this.quotaRetryAt) {
      throw new BadGatewayException(
        "Salesforce report quota is temporarily exhausted. Please try again later.",
      );
    }
    for (let attempt = 0; attempt < 2; attempt++) {
      const session = await this.authenticate();
      const response = await this.request(
        `${session.instance_url}/services/data/v${version}/${path}`,
        {
          ...init,
          headers: {
            ...init.headers,
            Authorization: `Bearer ${session.access_token}`,
            Accept: "application/json",
          },
        },
      );
      if (response.status === 401 && attempt === 0) {
        await response.body?.cancel();
        if (this.session === session) this.session = undefined;
        continue;
      }
      if (!response.ok) {
        if (await this.logRejection(response, operation)) {
          this.quotaRetryAt = Date.now() + 5 * 60 * 1000;
        }
        throw new BadGatewayException(
          "Salesforce report could not be loaded. Please try again.",
        );
      }
      try {
        return (await response.json()) as T;
      } catch {
        throw new BadGatewayException(
          "Salesforce returned an invalid report response.",
        );
      }
    }
    throw new BadGatewayException(
      "Salesforce authentication failed. Contact your administrator.",
    );
  }
}
