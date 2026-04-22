import { BadRequestException, Injectable } from "@nestjs/common";
import { extname } from "node:path";
import { alpha3ToCountryName } from "src/common/country.util";
import { Logger } from "src/common/logger";
import { SqlLoaderService } from "src/common/sql-loader.service";
import { DbService } from "src/db/db.service";
import {
  IdentityUserDto,
  UsersByHandlesBodyDto,
  UsersByGroupQueryDto,
  UsersByRoleQueryDto,
} from "./dtos/identity-users.dto";

const SUPPORTED_HANDLES_UPLOAD_EXTENSIONS = new Set([".txt", ".csv"]);

type UsersByHandlesRow = {
  userId: number | null;
  handle: string;
  firstName: string | null;
  lastName: string | null;
  contactNumber: string | null;
  email: string | null;
  country: string | null;
};

type UploadedHandlesFile = {
  originalname?: string;
  buffer?: Buffer;
};

/**
 * Provides identity-focused report queries and maps HTTP filters to SQL parameters.
 */
@Injectable()
export class IdentityReportsService {
  private readonly logger = new Logger(IdentityReportsService.name);

  /**
   * Initializes the service with database access and SQL template loading.
   * @param db PostgreSQL query service.
   * @param sql SQL file loader for report templates.
   */
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  /**
   * Queries users assigned to a role by role ID and/or role name.
   * @param filters Role filters from the request query string.
   * @returns Matching users with ID, handle, and primary email.
   */
  async getUsersByRole(
    filters: UsersByRoleQueryDto,
  ): Promise<IdentityUserDto[]> {
    this.logger.debug("Starting getUsersByRole with filters:", filters);
    const query = this.sql.load("reports/identity/users-by-role.sql");

    try {
      const results = await this.db.query<IdentityUserDto>(query, [
        filters.roleId ?? null,
        filters.roleName ?? null,
      ]);

      return results;
    } catch (e) {
      this.logger.error(e);
      return [];
    }
  }

  /**
   * Queries users in a group by group UUID/legacy ID and/or group name.
   * @param filters Group filters from the request query string.
   * @returns Matching users with ID, handle, and primary email.
   */
  async getUsersByGroup(
    filters: UsersByGroupQueryDto,
  ): Promise<IdentityUserDto[]> {
    this.logger.debug("Starting getUsersByGroup with filters:", filters);
    const query = this.sql.load("reports/identity/users-by-group.sql");

    try {
      const results = await this.db.query<IdentityUserDto>(query, [
        filters.groupId ?? null,
        filters.groupName ?? null,
      ]);

      return results;
    } catch (e) {
      this.logger.error(e);
      return [];
    }
  }

  /**
   * Queries user details for each submitted handle, preserving all input handles.
   * Unknown handles are returned with null user details.
   * @param body Request body containing a non-empty list of handles.
   * @param file Optional `.txt` or `.csv` upload with handles.
   * @returns One row per input handle with user ID, handle, email, and country.
   * @throws Does not throw; query failures are logged and return an empty array.
   */
  async getUsersByHandles(
    body: UsersByHandlesBodyDto,
    file?: UploadedHandlesFile,
  ): Promise<IdentityUserDto[]> {
    const handles = this.resolveHandles(body, file);
    this.logger.debug("Starting getUsersByHandles with handle count:", {
      count: handles.length,
    });
    const query = this.sql.load("reports/identity/users-by-handles.sql");

    try {
      const results = await this.db.query<UsersByHandlesRow>(query, [handles]);

      return results.map((row) => ({
        userId: row.userId,
        handle: row.handle,
        firstName: row.firstName,
        lastName: row.lastName,
        contactNumber: row.contactNumber,
        email: row.email,
        country: alpha3ToCountryName(row.country) ?? row.country,
      }));
    } catch (e) {
      this.logger.error(e);
      return [];
    }
  }

  /**
   * Resolves handles from either JSON body input or uploaded text/CSV content.
   * @param body Request JSON body.
   * @param file Optional uploaded file.
   * @returns Normalized handle list in caller-provided order.
   * @throws BadRequestException when neither mode provides at least one handle.
   */
  private resolveHandles(
    body: UsersByHandlesBodyDto | undefined,
    file?: UploadedHandlesFile,
  ): string[] {
    if (Array.isArray(body?.handles) && body.handles.length > 0) {
      return body.handles;
    }

    if (file) {
      return this.parseHandlesFromFile(file);
    }

    throw new BadRequestException(
      "Provide either a non-empty 'handles' array or a .txt/.csv file upload.",
    );
  }

  /**
   * Parses handles from uploaded `.txt`/`.csv` content.
   * @param file Uploaded file provided by multipart form-data.
   * @returns Ordered handles extracted from file contents.
   * @throws BadRequestException when type is unsupported or file has no handles.
   */
  private parseHandlesFromFile(file: UploadedHandlesFile): string[] {
    const extension = extname(file.originalname ?? "").toLowerCase();
    if (!SUPPORTED_HANDLES_UPLOAD_EXTENSIONS.has(extension)) {
      throw new BadRequestException(
        "Unsupported file type. Only .txt and .csv uploads are allowed.",
      );
    }

    const content = (file.buffer ?? Buffer.alloc(0))
      .toString("utf8")
      .replace(/^\uFEFF/, "");

    const handles = content
      .split(/\r?\n/)
      .flatMap((line) => line.split(","))
      .map((value) =>
        value
          .trim()
          .replace(/^"(.*)"$/, "$1")
          .trim(),
      )
      .filter((value) => value.length > 0);

    if (handles.length > 1 && /^handles?$/i.test(handles[0])) {
      handles.shift();
    }

    if (handles.length === 0) {
      throw new BadRequestException(
        "Uploaded file does not contain any handles.",
      );
    }

    return handles;
  }
}
