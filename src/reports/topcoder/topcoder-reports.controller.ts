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

  @Get("/90-day-member-spend")
  @ApiOperation({ summary: "Total gross amount paid to members in the last 90 days" })
  get90DayMemberSpend() {
    return this.reports.get90DayMemberSpend();
  }

  @Get("/90-day-new-members")
  @ApiOperation({ summary: "Total number of new active members created in the last 90 days" })
  get90DayNewMembers() {
    return this.reports.get90DayNewMembers();
  }
}
