import { Controller, Get, Query, UseGuards } from "@nestjs/common";

import {
  ApiBearerAuth,
  ApiOperation,
  ApiQuery,
  ApiResponse,
  ApiTags,
} from "@nestjs/swagger";

import { PermissionsGuard } from "../auth/guards/permissions.guard";
import { Scopes } from "../auth/decorators/scopes.decorator";
import { Scopes as AppScopes } from "../app-constants";

import { SfdcReportsService } from "./sfdc-reports.service";
import {
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
  @Scopes(AppScopes.AllReports)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "Export search winnings result in csv file format",
    description: "Roles: Payment Admin, Payment Editor, Payment Viewer",
  })
  @ApiQuery({
    type: PaymentsReportQueryDto,
  })
  @ApiResponse({
    status: 200,
    description: "Export winnings successfully.",
    type: ResponseDto<PaymentsReportResponse>,
  })
  async getPaymentsReport(@Query() query: PaymentsReportQueryDto) {
    const report = await this.reportsService.getPaymentsReport(query);
    return report;
  }
}
