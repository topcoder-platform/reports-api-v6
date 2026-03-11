import { Controller, Get, Req, UseGuards } from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { PermissionsGuard } from "src/auth/guards/permissions.guard";
import { Scopes } from "src/auth/decorators/scopes.decorator";
import { Scopes as AppScopes } from "src/app-constants";
import { AuthUserLike } from "src/auth/permissions.util";
import {
  REPORTS_DIRECTORY_REQUIRED_SCOPES,
  ReportsDirectory,
  getAccessibleReportsDirectory,
} from "./report-directory.data";

@ApiTags("Reports")
@Controller()
export class ReportsController {
  @Get()
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, ...REPORTS_DIRECTORY_REQUIRED_SCOPES)
  @ApiBearerAuth()
  @ApiOperation({
    summary:
      "List available report endpoints grouped by sub-path and filtered by the caller's permissions",
  })
  getReports(@Req() request: { authUser?: AuthUserLike }): ReportsDirectory {
    return getAccessibleReportsDirectory(request.authUser);
  }

  @Get("/directory")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, ...REPORTS_DIRECTORY_REQUIRED_SCOPES)
  @ApiBearerAuth()
  @ApiOperation({
    summary:
      "List available report endpoints grouped by sub-path and filtered by the caller's permissions (alias for /v6/reports)",
  })
  getReportsDirectory(
    @Req() request: { authUser?: AuthUserLike },
  ): ReportsDirectory {
    return getAccessibleReportsDirectory(request.authUser);
  }
}
