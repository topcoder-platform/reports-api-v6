import {
  Controller,
  Get,
  Query,
  UseGuards,
  UseInterceptors,
} from "@nestjs/common";
import {
  ApiBearerAuth,
  ApiOperation,
  ApiProduces,
  ApiResponse,
  ApiTags,
} from "@nestjs/swagger";
import { PermissionsGuard } from "src/auth/guards/permissions.guard";
import { ResponseDto } from "src/dto/api-response.dto";
import { PaymentsReportResponse } from "../sfdc/sfdc-reports.dto";
import { Scopes } from "../../auth/decorators/scopes.decorator";
import { Scopes as AppScopes } from "../../app-constants";
import { ChallengesReportsService } from "./challenges-reports.service";
import { CsvResponseInterceptor } from "../../common/interceptors/csv-response.interceptor";
import { ChallengeRegistrantsQueryDto } from "./dtos/registrants.dto";
import { ChallengesReportQueryDto } from "./dtos/challenge.dto";
import {
  SubmissionLinksDto,
  SubmissionLinksQueryDto,
} from "./dtos/submission-links.dto";

@ApiTags("Challenges Reports")
@ApiProduces("application/json", "text/csv")
@UseInterceptors(CsvResponseInterceptor)
@Controller("/challenges")
export class ChallengesReportsController {
  constructor(private readonly reportsService: ChallengesReportsService) {}

  @Get()
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.Challenge.History)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "Return the challenge history report",
  })
  @ApiResponse({
    status: 200,
    description: "Export successful.",
    type: ResponseDto<PaymentsReportResponse>,
  })
  async getChallengeHistoryReport(@Query() query: ChallengesReportQueryDto) {
    const report = await this.reportsService.getChallengesReport(query);
    return report;
  }

  @Get("/registrants")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.Challenge.Registrants)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "Return the challenge registrants history report",
  })
  @ApiResponse({
    status: 200,
    description: "Export successful.",
    type: ResponseDto<PaymentsReportResponse>,
  })
  async getRegistrantsHistory(@Query() query: ChallengeRegistrantsQueryDto) {
    const report = await this.reportsService.getRegistrantsReport(query);
    return report;
  }

  @Get("/submission-links")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.Challenge.SubmissionLinks)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "Return the submission links report",
  })
  @ApiResponse({
    status: 200,
    description: "Export successful.",
    type: ResponseDto<SubmissionLinksDto[]>,
  })
  async getSubmissionLinks(@Query() query: SubmissionLinksQueryDto) {
    const report = await this.reportsService.getSubmissionLinks(query);
    return report;
  }
}
