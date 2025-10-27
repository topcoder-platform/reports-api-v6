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
}
