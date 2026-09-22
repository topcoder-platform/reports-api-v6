import {
  BadGatewayException,
  Injectable,
  Logger,
  ServiceUnavailableException,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { setTimeout as delay } from "node:timers/promises";

export interface SalesforceGrouping {
  key: string;
  label: string;
  value?: unknown;
  groupings: SalesforceGrouping[];
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
  };
  reportExtendedMetadata: {
    detailColumnInfo: Record<string, { label: string; dataType: string }>;
    groupingColumnInfo?: Record<string, { label: string; dataType: string }>;
  };
  groupingsDown?: { groupings: SalesforceGrouping[] };
  groupingsAcross?: { groupings: SalesforceGrouping[] };
  factMap: Record<
    string,
    { rows?: Array<{ dataCells: Array<{ label?: string; value?: unknown }> }> }
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
            .replace(/[\r\n\t\x00-\x1f\x7f]/g, " ")
            .replace(/Bearer\s+\S+/gi, "Bearer [redacted]")
            .slice(0, 240);
          for (const secret of [
            this.config.get<string>("SALESFORCE_API_CONSUMER_SECRET"),
            this.session?.access_token,
          ]) {
            if (secret) safeMessage = safeMessage.split(secret).join("[redacted]");
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
   * Runs a saved report using GET with includeDetails=true; renews expired OAuth once.
   * @param reportId Server-selected 15/18-character Salesforce report ID.
   * @returns Unmodified Analytics report JSON for metadata-driven normalization.
   * @throws ServiceUnavailableException for invalid configuration; BadGatewayException on upstream failure.
   */
  async runReport(reportId: string): Promise<SalesforceReport> {
    if (!/^00O[a-zA-Z0-9]{12}(?:[a-zA-Z0-9]{3})?$/.test(reportId)) {
      throw new ServiceUnavailableException(
        "Salesforce report ID is not configured correctly.",
      );
    }
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
        `${session.instance_url}/services/data/v${version}/analytics/reports/${reportId}?includeDetails=true`,
        {
          headers: {
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
        if (await this.logRejection(response, `report ${reportId}`)) {
          this.quotaRetryAt = Date.now() + 5 * 60 * 1000;
        }
        throw new BadGatewayException(
          "Salesforce report could not be loaded. Please try again.",
        );
      }
      try {
        return (await response.json()) as SalesforceReport;
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
