import { Controller, Get, Query, UseGuards } from "@nestjs/common";
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from "@nestjs/swagger";
import { PermissionsGuard } from "src/auth/guards/permissions.guard";
import { ResponseDto } from "src/dto/api-response.dto";
import { PaymentsReportResponse } from "../sfdc/sfdc-reports.dto";
import { Scopes } from "../../auth/decorators/scopes.decorator";
import { Scopes as AppScopes } from "../../app-constants";
import { ChallengesReportsService } from "./challenges-reports.service";
import { ChallengeRegistrantsQueryDto } from "./dtos/registrants.dto";

@ApiTags("Challenges Reports")
@Controller("/challenges")
export class ChallengesReportsController {
  constructor(private readonly reportsService: ChallengesReportsService) {}

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
}
