import { Controller, Get, UseGuards } from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { PermissionsGuard } from "src/auth/guards/permissions.guard";
import { Scopes } from "src/auth/decorators/scopes.decorator";
import { Scopes as AppScopes } from "src/app-constants";
import { REPORTS_DIRECTORY, ReportsDirectory } from "./report-directory.data";

@ApiTags("Reports")
@Controller()
export class ReportsController {
  @Get()
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "List available report endpoints grouped by sub-path",
  })
  getReports(): ReportsDirectory {
    return REPORTS_DIRECTORY;
  }

  @Get("/directory")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports)
  @ApiBearerAuth()
  @ApiOperation({
    summary:
      "List available report endpoints grouped by sub-path (alias for /v6/reports)",
  })
  getReportsDirectory(): ReportsDirectory {
    return REPORTS_DIRECTORY;
  }
}
