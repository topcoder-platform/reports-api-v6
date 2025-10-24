import { Controller, Get, Query, UseGuards } from "@nestjs/common";

import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from "@nestjs/swagger";

import { PermissionsGuard } from "../../auth/guards/permissions.guard";
import { Scopes } from "../../auth/decorators/scopes.decorator";
import { Scopes as AppScopes } from "../../app-constants";

import { SfdcReportsService } from "./sfdc-reports.service";
import {
  BaFeesReportQueryDto,
  BaFeesReportResponse,
  PaymentsReportQueryDto,
  PaymentsReportResponse,
} from "./sfdc-reports.dto";
import { ResponseDto } from "src/dto/api-response.dto";

@ApiTags("Sfdc Reports")
@Controller("/sfdc")
export class SfdcReportsController {
  constructor(private readonly reportsService: SfdcReportsService) {}

  @Get("/payments")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.SFDC.PaymentsReport)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "SFDC Payments report",
    description: "",
  })
  @ApiResponse({
    status: 200,
    description: "Export successfully.",
    type: ResponseDto<PaymentsReportResponse>,
  })
  async getPaymentsReport(@Query() query: PaymentsReportQueryDto) {
    const report = await this.reportsService.getPaymentsReport(query);
    return report;
  }

  @Get("/ba-fees")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.SFDC.BA)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "Report of BA to fee / member payment",
    description: "",
  })
  @ApiResponse({
    status: 200,
    description: "Export successfully.",
    type: ResponseDto<BaFeesReportResponse>,
  })
  async getBaFeesReport(@Query() query: BaFeesReportQueryDto) {
    const report = await this.reportsService.getBaFeesReport(query);
    return report;
  }
}
