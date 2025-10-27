import { Controller, Get } from "@nestjs/common";
import { ApiOperation, ApiTags } from "@nestjs/swagger";
import { TopcoderReportsService } from "./topcoder-reports.service";

@ApiTags("Topcoder Reports")
@Controller("/topcoder")
export class TopcoderReportsController {
  constructor(private readonly reports: TopcoderReportsService) {}

  @Get("/member-count")
  @ApiOperation({ summary: "Total number of active members" })
  getMemberCount() {
    return this.reports.getMemberCount();
  }

  @Get("/total-copilots")
  @ApiOperation({ summary: "Total number of Copilots" })
  getTotalCopilots() {
    return this.reports.getTotalCopilots();
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
}
