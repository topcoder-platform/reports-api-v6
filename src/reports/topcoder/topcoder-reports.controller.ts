import {
  Controller,
  Get,
  Param,
  Query,
  UseGuards,
  UseInterceptors,
} from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { TopcoderReportsService } from "./topcoder-reports.service";
import { RegistrantCountriesQueryDto } from "./dto/registrant-countries.dto";
import { TopcoderReportsGuard } from "../../auth/guards/topcoder-reports.guard";
import { CsvResponseInterceptor } from "../../common/interceptors/csv-response.interceptor";

@ApiTags("Topcoder Reports")
@ApiBearerAuth()
@UseGuards(TopcoderReportsGuard)
@UseInterceptors(CsvResponseInterceptor)
@Controller("/topcoder")
export class TopcoderReportsController {
  constructor(private readonly reports: TopcoderReportsService) {}

  @Get("/member-count")
  @ApiOperation({ summary: "Total number of active members" })
  getMemberCount() {
    return this.reports.getMemberCount();
  }

  @Get("/registrant-countries")
  @ApiOperation({
    summary: "Countries of all registrants for the specified challenge",
  })
  async getRegistrantCountries(@Query() query: RegistrantCountriesQueryDto) {
    const { challengeId } = query;
    return this.reports.getRegistrantCountries(challengeId);
  }

  @Get("/mm-stats/:handle")
  @ApiOperation({
    summary: "Marathon match performance snapshot for a specific handle",
  })
  getMarathonMatchStats(@Param("handle") handle: string) {
    return this.reports.getMarathonMatchStats(handle);
  }

  @Get("/total-copilots")
  @ApiOperation({ summary: "Total number of Copilots" })
  getTotalCopilots() {
    return this.reports.getTotalCopilots();
  }

  @Get("/weekly-active-copilots")
  @ApiOperation({
    summary:
      "Weekly challenge and copilot counts by track for the last six months",
  })
  getWeeklyActiveCopilots() {
    return this.reports.getWeeklyActiveCopilots();
  }

  @Get("/weekly-member-participation")
  @ApiOperation({
    summary:
      "Weekly distinct registrants and submitters for the last five weeks",
  })
  getWeeklyMemberParticipation() {
    return this.reports.getWeeklyMemberParticipation();
  }

  @Get("/30-day-payments")
  @ApiOperation({
    summary: "Member payments for the last 30 days",
  })
  get30DayPayments() {
    return this.reports.get30DayPayments();
  }

  @Get("/member-payments")
  @ApiOperation({
    summary:
      "List of member payments (optional query params: startDate, endDate in YYYY-MM-DD)",
  })
  getMemberPayments(
    @Query("startDate") startDate?: string,
    @Query("endDate") endDate?: string,
  ) {
    return this.reports.getMemberPayments(startDate, endDate);
  }

  @Get("/90-day-member-spend")
  @ApiOperation({
    summary: "Total gross amount paid to members in the last 90 days",
  })
  get90DayMemberSpend() {
    return this.reports.get90DayMemberSpend();
  }

  @Get("/90-day-members-paid")
  @ApiOperation({
    summary: "Total number of distinct members paid in the last 90 days",
  })
  get90DayMembersPaid() {
    return this.reports.get90DayMembersPaid();
  }

  @Get("/90-day-new-members")
  @ApiOperation({
    summary: "Total number of new active members created in the last 90 days",
  })
  get90DayNewMembers() {
    return this.reports.get90DayNewMembers();
  }

  @Get("/90-day-active-copilots")
  @ApiOperation({
    summary: "Total number of distinct copilots active in the last 90 days",
  })
  get90DayActiveCopilots() {
    return this.reports.get90DayActiveCopilots();
  }

  @Get("/90-day-user-login")
  @ApiOperation({
    summary:
      "Total number of active members who logged in during the last 90 days",
  })
  get90DayUserLogin() {
    return this.reports.get90DayUserLogin();
  }

  @Get("/90-day-challenge-volume")
  @ApiOperation({
    summary: "Total number of challenges launched in the last 90 days",
  })
  get90DayChallengeVolume() {
    return this.reports.get90DayChallengeVolume();
  }

  @Get("/90-day-challenge-duration")
  @ApiOperation({
    summary:
      "Total duration and count of completed challenges in the last 90 days",
  })
  get90DayChallengeDuration() {
    return this.reports.get90DayChallengeDuration();
  }

  @Get("/90-day-challenge-registrants")
  @ApiOperation({
    summary:
      "Distinct challenge registrants and submitters in the last 90 days",
  })
  get90DayChallengeRegistrants() {
    return this.reports.get90DayChallengeRegistrants();
  }

  @Get("/90-day-challenge-submitters")
  @ApiOperation({
    summary:
      "Distinct challenge registrants and submitters in the last 90 days",
  })
  get90DayChallengeSubmitters() {
    return this.reports.get90DayChallengeSubmitters();
  }

  @Get("/90-day-challenge-member-cost")
  @ApiOperation({
    summary:
      "Member payment totals and averages for challenges completed in the last 90 days",
  })
  get90DayChallengeMemberCost() {
    return this.reports.get90DayChallengeMemberCost();
  }

  @Get("/90-day-task-member-cost")
  @ApiOperation({
    summary:
      "Member payment totals and averages for tasks completed in the last 90 days",
  })
  get90DayTaskMemberCost() {
    return this.reports.get90DayTaskMemberCost();
  }

  @Get("/90-day-fulfillment")
  @ApiOperation({
    summary:
      "Share of challenges completed versus cancelled in the last 90 days",
  })
  get90DayFulfillment() {
    return this.reports.get90DayFulfillment();
  }

  @Get("/90-day-fulfillment-with-tasks")
  @ApiOperation({
    summary:
      "Share of challenges and tasks completed versus cancelled in the last 90 days",
  })
  get90DayFulfillmentWithTasks() {
    return this.reports.get90DayFulfillmentWithTasks();
  }

  @Get("/weekly-challenge-fulfillment")
  @ApiOperation({
    summary:
      "Weekly share of challenges completed versus cancelled for the last four weeks",
  })
  getWeeklyChallengeFulfillment() {
    return this.reports.getWeeklyChallengeFulfillment();
  }

  @Get("/weekly-challenge-volume")
  @ApiOperation({
    summary:
      "Weekly challenge counts by task indicator for the last four weeks",
  })
  getWeeklyChallengeVolume() {
    return this.reports.getWeeklyChallengeVolume();
  }

  @Get("/90-day-membership-participation-funnel")
  @ApiOperation({
    summary:
      "New member counts with design and development participation indicators for the last 90 days",
  })
  get90DayMembershipParticipationFunnel() {
    return this.reports.get90DayMembershipParticipationFunnel();
  }

  @Get("/membership-participation-funnel-data")
  @ApiOperation({
    summary:
      "Weekly new member counts with design and development participation indicators for the last four weeks",
  })
  getMembershipParticipationFunnelData() {
    return this.reports.getMembershipParticipationFunnelData();
  }
}
