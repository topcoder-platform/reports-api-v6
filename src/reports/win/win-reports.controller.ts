import { Controller, Get, Query, UseGuards } from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from "@nestjs/swagger";
import { Scopes as AppScopes } from "../../app-constants";
import { Scopes } from "../../auth/decorators/scopes.decorator";
import { PermissionsGuard } from "../../auth/guards/permissions.guard";
import { WinReportQueryDto, WinReportResponseDto } from "./win-reports.dto";
import { WinReportsService } from "./win-reports.service";

/** Authenticated pull endpoint for showcase posts explicitly shared with WIN. */
@ApiTags("WIN")
@ApiBearerAuth()
@UseGuards(PermissionsGuard)
@Scopes(AppScopes.WIN)
@Controller("WIN")
export class WinReportsController {
  /**
   * @param service WIN report reader injected by the module.
   * @returns An authenticated WIN controller.
   * @throws Does not throw during construction.
   */
  constructor(private readonly service: WinReportsService) {}

  /**
   * Exposes opted-in showcase and project metadata to authorized API callers.
   * @param query Optional project ID and bounded pagination.
   * @returns A page of WIN showcase records and its total count.
   * @throws 400 for invalid filters, 401/403 for denied access, or database errors.
   */
  @Get()
  @ApiOperation({
    summary: "Showcases shared with WIN",
    description: "Requires reports:win scope, or an Administrator or Talent Manager user role.",
  })
  @ApiResponse({ status: 200, type: WinReportResponseDto })
  @ApiResponse({ status: 400, description: "Invalid query parameters" })
  @ApiResponse({ status: 401, description: "Unauthenticated" })
  @ApiResponse({ status: 403, description: "Missing WIN scope or role" })
  getReport(@Query() query: WinReportQueryDto): Promise<WinReportResponseDto> {
    return this.service.getReport(query);
  }
}
