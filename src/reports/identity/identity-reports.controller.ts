import {
  Body,
  Controller,
  Get,
  Post,
  Query,
  UploadedFile,
  UseGuards,
  UseInterceptors,
  ValidationPipe,
} from "@nestjs/common";
import {
  ApiBody,
  ApiBearerAuth,
  ApiConsumes,
  ApiOperation,
  ApiProduces,
  ApiResponse,
  ApiTags,
} from "@nestjs/swagger";
import { FileInterceptor } from "@nestjs/platform-express";
import { Scopes as AppScopes } from "src/app-constants";
import { Scopes } from "src/auth/decorators/scopes.decorator";
import { PermissionsGuard } from "src/auth/guards/permissions.guard";
import { CsvResponseInterceptor } from "src/common/interceptors/csv-response.interceptor";
import {
  UsersByHandlesBodyDto,
  UsersByGroupQueryDto,
  UsersByRoleQueryDto,
} from "./dtos/identity-users.dto";
import { IdentityReportsService } from "./identity-reports.service";

type UploadedHandlesFile = {
  originalname?: string;
  buffer?: Buffer;
};

/**
 * Handles identity report endpoints and delegates query execution to the service layer.
 */
@ApiTags("Identity Reports")
@ApiProduces("application/json", "text/csv")
@UseInterceptors(CsvResponseInterceptor)
@Controller("/identity")
export class IdentityReportsController {
  constructor(private readonly service: IdentityReportsService) {}

  /**
   * Exports users matched by role ID and/or role name.
   * @param query Query-string filters for role lookup.
   * @returns List of matching identity users.
   */
  @Get("/users-by-role")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.Identity.UsersByRole)
  @ApiBearerAuth()
  @ApiOperation({ summary: "Export users for a given role (by ID or name)" })
  @ApiResponse({ status: 200, description: "Export successful." })
  async getUsersByRole(@Query() query: UsersByRoleQueryDto) {
    return this.service.getUsersByRole(query);
  }

  /**
   * Exports users matched by group ID and/or group description.
   * @param query Query-string filters for group lookup.
   * @returns List of matching identity users.
   */
  @Get("/users-by-group")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.Identity.UsersByGroup)
  @ApiBearerAuth()
  @ApiOperation({ summary: "Export users for a given group (by ID or name)" })
  @ApiResponse({ status: 200, description: "Export successful." })
  async getUsersByGroup(@Query() query: UsersByGroupQueryDto) {
    return this.service.getUsersByGroup(query);
  }

  /**
   * Exports user details for the provided list of handles.
   * Unknown handles are included with null values for unmatched fields.
   * @param body JSON payload containing handles to look up.
   * @returns List with one row per requested handle.
   */
  @Post("/users-by-handles")
  @UseGuards(PermissionsGuard)
  @UseInterceptors(FileInterceptor("file"))
  @Scopes(AppScopes.AllReports, AppScopes.Identity.UsersByHandles)
  @ApiBearerAuth()
  @ApiOperation({
    summary:
      "Export user details (ID, handle, email, country) for a list of handles",
  })
  @ApiConsumes("application/json", "multipart/form-data")
  @ApiBody({
    required: true,
    schema: {
      oneOf: [
        {
          type: "object",
          required: ["handles"],
          properties: {
            handles: {
              type: "array",
              items: { type: "string" },
              description: "List of handles to look up.",
            },
          },
        },
        {
          type: "object",
          required: ["file"],
          properties: {
            file: {
              type: "string",
              format: "binary",
              description:
                "Upload a .txt or .csv file with handles (one per line or comma-separated).",
            },
          },
        },
      ],
    },
  })
  @ApiResponse({ status: 200, description: "Export successful." })
  async getUsersByHandles(
    @Body(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        skipMissingProperties: true,
      }),
    )
    body: UsersByHandlesBodyDto,
    @UploadedFile() file?: UploadedHandlesFile,
  ) {
    return this.service.getUsersByHandles(body, file);
  }
}
