import {
  BadGatewayException,
  Injectable,
  InternalServerErrorException,
  Logger,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import * as core from "tc-core-library-js";

export type StandardizedSkillCategory = {
  id: string;
  name: string;
};

type M2MClient = {
  getMachineToken: (clientId: string, clientSecret: string) => Promise<string>;
};

const CATEGORIES_PATH =
  "/v5/standardized-skills/categories?disablePagination=true&sortBy=name";

function parseValidIssuers(value?: string): string[] {
  const raw = String(value || "").trim();
  if (!raw) {
    return [];
  }

  if (raw.startsWith("[")) {
    try {
      const parsed = JSON.parse(raw);
      if (Array.isArray(parsed)) {
        return parsed
          .map((issuer) =>
            String(issuer || "")
              .trim()
              .replace(/\/$/, ""),
          )
          .filter(Boolean);
      }
    } catch {
      return [];
    }
  }

  return raw
    .split(",")
    .map((issuer) => issuer.trim().replace(/\/$/, ""))
    .filter(Boolean);
}

function issuerHostname(issuer: string): string | undefined {
  try {
    return new URL(issuer).hostname.toLowerCase();
  } catch {
    return undefined;
  }
}

function resolveApiBaseUrl(
  issuers: string[],
  deployEnv?: string,
): string | undefined {
  const apiIssuers = issuers.filter((issuer) =>
    Boolean(issuerHostname(issuer)?.startsWith("api.")),
  );
  if (!apiIssuers.length) {
    return undefined;
  }

  const environment = String(deployEnv || "").toLowerCase();
  const preferProd = environment === "prod" || environment === "production";
  const prodUrl = apiIssuers.find(
    (issuer) => !issuerHostname(issuer)?.includes("-dev"),
  );
  const devUrl = apiIssuers.find((issuer) =>
    Boolean(issuerHostname(issuer)?.includes("-dev")),
  );

  if (preferProd) {
    return prodUrl || devUrl || apiIssuers[0];
  }

  return devUrl || prodUrl || apiIssuers[0];
}

@Injectable()
export class StandardizedSkillsClient {
  private readonly logger = new Logger(StandardizedSkillsClient.name);
  private m2m?: M2MClient;

  constructor(private readonly config: ConfigService) {}

  async fetchCategories(): Promise<StandardizedSkillCategory[]> {
    const url = this.buildCategoriesUrl();
    const headers: Record<string, string> = { Accept: "application/json" };
    const token = await this.getOptionalM2MToken();

    if (token) {
      headers.Authorization = `Bearer ${token}`;
    }

    let response: Response;
    try {
      response = await fetch(url, { headers });
    } catch (error) {
      this.logger.error(
        "Standardized-skills categories request failed.",
        error instanceof Error ? error.message : error,
      );
      throw new BadGatewayException(
        "Failed to fetch skill categories from standardized-skills.",
      );
    }

    if (!response.ok) {
      this.logger.error(
        `Standardized-skills categories request failed with status ${response.status}.`,
      );
      throw new BadGatewayException(
        "Failed to fetch skill categories from standardized-skills.",
      );
    }

    let payload: unknown;
    try {
      payload = await response.json();
    } catch (error) {
      this.logger.error(
        "Standardized-skills categories response was not valid JSON.",
        error instanceof Error ? error.message : error,
      );
      throw new BadGatewayException(
        "Failed to fetch skill categories from standardized-skills.",
      );
    }

    return this.parseCategories(payload);
  }

  private buildCategoriesUrl(): string {
    const issuers = parseValidIssuers(this.config.get<string>("VALID_ISSUERS"));
    const deployEnv =
      this.config.get<string>("DEPLOY_ENV") ||
      this.config.get<string>("LOGICAL_ENV") ||
      this.config.get<string>("NODE_ENV");
    const baseUrl = resolveApiBaseUrl(issuers, deployEnv);

    if (!baseUrl) {
      this.logger.error("VALID_ISSUERS does not include a Topcoder API host.");
      throw new InternalServerErrorException(
        "VALID_ISSUERS does not include a Topcoder API host.",
      );
    }

    return `${baseUrl}${CATEGORIES_PATH}`;
  }

  private async getOptionalM2MToken(): Promise<string | undefined> {
    const clientId =
      this.config.get<string>("M2M_CLIENT_ID") ||
      this.config.get<string>("AUTH0_CLIENT_ID");
    const clientSecret =
      this.config.get<string>("M2M_CLIENT_SECRET") ||
      this.config.get<string>("AUTH0_CLIENT_SECRET");

    if (!clientId || !clientSecret) {
      return undefined;
    }

    try {
      return await this.getM2MClient().getMachineToken(clientId, clientSecret);
    } catch (error) {
      this.logger.error(
        "Failed to obtain an M2M token for standardized-skills.",
        error instanceof Error ? error.message : error,
      );
      throw new BadGatewayException(
        "Failed to authenticate with standardized-skills.",
      );
    }
  }

  private getM2MClient(): M2MClient {
    if (this.m2m) {
      return this.m2m;
    }

    this.m2m = core.auth.m2m({
      AUTH0_URL: this.config.get<string>("AUTH0_URL"),
      AUTH0_AUDIENCE: this.config.get<string>("AUTH0_AUDIENCE"),
      AUTH0_PROXY_SERVER_URL: this.config.get<string>("AUTH0_PROXY_SERVER_URL"),
    }) as M2MClient;

    return this.m2m;
  }

  private parseCategories(payload: unknown): StandardizedSkillCategory[] {
    const rows = this.extractCategoryList(payload);
    const seen = new Set<string>();
    const categories: StandardizedSkillCategory[] = [];

    rows.forEach((row) => {
      const id = this.normalizeText(row.id);
      const name = this.normalizeText(row.name);

      if (!id || !name || seen.has(id)) {
        return;
      }

      seen.add(id);
      categories.push({ id, name });
    });

    return categories;
  }

  private extractCategoryList(payload: unknown): Array<{
    id?: unknown;
    name?: unknown;
  }> {
    if (Array.isArray(payload)) {
      return payload;
    }

    if (!payload || typeof payload !== "object") {
      return [];
    }

    const record = payload as {
      categories?: unknown;
      data?: unknown;
    };

    if (Array.isArray(record.categories)) {
      return record.categories;
    }

    if (Array.isArray(record.data)) {
      return record.data;
    }

    return [];
  }

  private normalizeText(value: unknown): string | undefined {
    if (typeof value !== "string" && typeof value !== "number") {
      return undefined;
    }

    const normalized = String(value).trim();
    return normalized || undefined;
  }
}
