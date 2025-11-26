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
  ChallengesReportQueryDto,
  ChallengesReportResponse,
  PaymentsReportQueryDto,
  PaymentsReportResponse,
  TaasJobsReportQueryDto,
  TaasJobsReportResponse,
  TaasMemberVerificationReportQueryDto,
  TaasMemberVerificationReportResponse,
  TaasResourceBookingsReportQueryDto,
  TaasResourceBookingsReportResponse,
  WesternUnionPaymentsReportQueryDto,
  WesternUnionPaymentsReportResponse,
} from "./sfdc-reports.dto";
import { ResponseDto } from "src/dto/api-response.dto";

@ApiTags("Sfdc Reports")
@Controller("/sfdc")
export class SfdcReportsController {
  constructor(private readonly reportsService: SfdcReportsService) {}

  @Get("/challenges")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.SFDC.ChallengesReport)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "SFDC Challenges report",
    description:
      "Retrieve challenge data with associated costs, payments, and member information for Salesforce integration",
  })
  @ApiResponse({
    status: 200,
    description: "Challenges report retrieved successfully",
    type: ResponseDto<ChallengesReportResponse>,
  })
  async getChallengesReport(@Query() query: ChallengesReportQueryDto) {
    const report = await this.reportsService.getChallengesReport(query);
    return report;
  }

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

  @Get("/taas/jobs")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.SFDC.TaasJobs)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "SFDC TaaS Jobs report",
    description:
      "Retrieve TaaS job listings with project, skill, and status filters for Salesforce integration",
  })
  @ApiResponse({
    status: 200,
    description: "TaaS jobs report retrieved successfully",
    type: ResponseDto<TaasJobsReportResponse>,
  })
  async getTaasJobsReport(@Query() query: TaasJobsReportQueryDto) {
    const report = await this.reportsService.getTaasJobsReport(query);
    return report;
  }

  @Get("/taas/resource-bookings")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.SFDC.TaasResourceBookings)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "SFDC TaaS Resource Bookings report",
    description:
      "Retrieve TaaS resource booking assignments with job, user, and date filters for Salesforce integration",
  })
  @ApiResponse({
    status: 200,
    description: "TaaS resource bookings report retrieved successfully",
    type: ResponseDto<TaasResourceBookingsReportResponse>,
  })
  async getTaasResourceBookingsReport(
    @Query() query: TaasResourceBookingsReportQueryDto,
  ) {
    const report =
      await this.reportsService.getTaasResourceBookingsReport(query);
    return report;
  }

  @Get("/taas/member-verification")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.SFDC.TaasMemberVerification)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "SFDC TaaS Member Verification report",
    description:
      "Retrieve member verification status by handles for TaaS resource validation in Salesforce",
  })
  @ApiResponse({
    status: 200,
    description: "Member verification report retrieved successfully",
    type: ResponseDto<TaasMemberVerificationReportResponse>,
  })
  async getTaasMemberVerificationReport(
    @Query() query: TaasMemberVerificationReportQueryDto,
  ) {
    const report =
      await this.reportsService.getTaasMemberVerificationReport(query);
    return report;
  }

  @Get("/taas/western-union-payments")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.SFDC.WesternUnionPayments)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "SFDC Western Union Payments report",
    description:
      "Retrieve Western Union payment records for remittance processing in Salesforce",
  })
  @ApiResponse({
    status: 200,
    description: "Western Union payments report retrieved successfully",
    type: ResponseDto<WesternUnionPaymentsReportResponse>,
  })
  async getWesternUnionPaymentsReport(
    @Query() query: WesternUnionPaymentsReportQueryDto,
  ) {
    const report =
      await this.reportsService.getWesternUnionPaymentsReport(query);
    return report;
  }

  @Get("/ba-fees")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.SFDC.BA)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "BA fees and member payments with optional monthly grouping",
    description:
      "Aggregates finance.payment challenge fees and member payments per billing account, returning totals plus the latest payment status. Supports billingAccountIds with !-prefixed exclusions (for example to omit Topgear) and optional start/end dates.",
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
