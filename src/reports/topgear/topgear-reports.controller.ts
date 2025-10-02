import { Controller, Get, Query, UseGuards } from "@nestjs/common";

import {
  ApiTags,
  ApiOperation,
  ApiQuery,
  ApiBearerAuth,
} from "@nestjs/swagger";

import { PermissionsGuard } from "../../auth/guards/permissions.guard";
import { Scopes } from "../../auth/decorators/scopes.decorator";
import { Scopes as AppScopes } from "../../app-constants";

import { TopgearReportsService } from "./topgear-reports.service";
import { ChallengesCountBySkillDto } from "./dtos/submissions-review.dto";
import { ChallengeStatsByUserDto } from "./dtos/challenge-stats-by-user.dto";

@ApiTags("Topgear Reports")
@Controller("/topgear")
export class TopgearReportsController {
  constructor(private readonly reports: TopgearReportsService) {}

  @Get("hourly")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.TopgearHourly)
  @ApiBearerAuth()
  @ApiOperation({ summary: "Return the Topgear Hourly report details" })
  getTopgearHourly() {
    return this.reports.getTopgearHourly();
  }

  @Get("challenge-stats-by-user")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.TopgearChallengeStatsByUser)
  @ApiBearerAuth()
  @ApiOperation({ summary: "Get challenge stats per user" })
  async getChallengeStatsByUser(
    @Query("start_date") startDate?: string,
    @Query("end_date") endDate?: string,
  ): Promise<ChallengeStatsByUserDto[]> {
    return this.reports.getChallengeStatsByUser({ startDate, endDate });
  }

  @Get("challenges-count-by-skill")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.TopgearChallengeTechnology)
  @ApiBearerAuth()
  @ApiOperation({ summary: "Return challenges count by skill" })
  async getChallengesCountBySkill(): Promise<ChallengesCountBySkillDto[]> {
    return this.reports.getChallengesCountBySkill();
  }

  @Get("payments")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.TopgearHourly)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "Return the Topgear Payments from start_date to end_date",
  })
  @ApiQuery({
    name: "start_date",
    required: false,
    type: Date,
    description: "Start date",
  })
  @ApiQuery({
    name: "end_date",
    required: false,
    type: Date,
    description: "End date",
  })
  getTopgearPayments(
    @Query("start_date") start?: string,
    @Query("end_date") end?: string,
  ) {
    return this.reports.getTopgearPayments({ start, end });
  }

  @Get("challenge")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.TopgearChallenge)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "Return the Topgear Challenge report from start_date to end_date",
  })
  @ApiQuery({
    name: "start_date",
    required: false,
    type: Date,
    description: "Start date",
  })
  @ApiQuery({
    name: "end_date",
    required: false,
    type: Date,
    description: "End date",
  })
  getTopgearChallenge(
    @Query("start_date") start?: string,
    @Query("end_date") end?: string,
  ) {
    return this.reports.getTopgearChallenge({ start, end });
  }

  @Get("cancelled-challenge")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.TopgearCancelledChallenge)
  @ApiBearerAuth()
  @ApiOperation({
    summary:
      "Return the Topgear Cancelled Challenge report from start_date to end_date",
  })
  @ApiQuery({
    name: "start_date",
    required: false,
    type: Date,
    description: "Start date",
  })
  @ApiQuery({
    name: "end_date",
    required: false,
    type: Date,
    description: "End date",
  })
  getTopgearCancelledChallenge(
    @Query("start_date") start?: string,
    @Query("end_date") end?: string,
  ) {
    return this.reports.getTopgearCancelledChallenge({ start, end });
  }

  @Get("registrants-details")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.TopgearChallengeRegistrantDetails)
  @ApiBearerAuth()
  @ApiOperation({
    summary:
      "Return the Topgear Registrants Details report from start_date to end_date",
  })
  @ApiQuery({
    name: "start_date",
    required: false,
    type: Date,
    description: "Start date",
  })
  @ApiQuery({
    name: "end_date",
    required: false,
    type: Date,
    description: "End date",
  })
  getTopgearRegistrantsDetails(
    @Query("start_date") start?: string,
    @Query("end_date") end?: string,
  ) {
    return this.reports.getTopgearRegistrantsDetails({ start, end });
  }
}
