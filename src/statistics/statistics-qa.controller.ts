import { Controller, Get } from "@nestjs/common";
import { ApiOperation, ApiTags } from "@nestjs/swagger";
import { QaStatisticsService } from "./qa-statistics.service";

@ApiTags("Statistics")
@Controller("/statistics/qa")
export class StatisticsQaController {
  constructor(private readonly qa: QaStatisticsService) {}

  @Get("/wins")
  @ApiOperation({ summary: "Quality Assurance challenge wins by member (desc)" })
  getQaWins() {
    return this.qa.getWins();
  }
}
