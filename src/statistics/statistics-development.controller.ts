import { Controller, Get } from "@nestjs/common";
import { ApiOperation, ApiTags } from "@nestjs/swagger";
import { DevelopmentStatisticsService } from "./development-statistics.service";

@ApiTags("Statistics")
@Controller("/statistics/development")
export class StatisticsDevelopmentController {
  constructor(private readonly development: DevelopmentStatisticsService) {}

  @Get("/code-wins")
  @ApiOperation({
    summary: "Development challenge wins by member (desc)",
  })
  getCodeWins() {
    return this.development.getCodeWins();
  }

  @Get("/f2f-wins")
  @ApiOperation({
    summary: "Development First2Finish wins by member (desc)",
  })
  getDevelopmentF2FWins() {
    return this.development.getDevelopmentF2FWins();
  }

  @Get("/prototype-wins")
  @ApiOperation({
    summary: "Development prototype challenge wins by member (desc)",
  })
  getPrototypeWins() {
    return this.development.getPrototypeWins();
  }

  @Get("/first-place-wins")
  @ApiOperation({
    summary: "Development overall wins by member (desc)",
  })
  getDevelopmentFirstPlaceWins() {
    return this.development.getDevelopmentFirstPlaceWins();
  }

  @Get("/first-time-submitters")
  @ApiOperation({
    summary: "First-time development submitters in last 3 months",
  })
  getFirstTimeDevelopmentSubmitters() {
    return this.development.getFirstTimeDevelopmentSubmitters();
  }

  @Get("/countries-represented")
  @ApiOperation({
    summary: "Development submitters by country (desc)",
  })
  getDevelopmentCountriesRepresented() {
    return this.development.getDevelopmentCountriesRepresented();
  }

  @Get("/challenges-technology")
  @ApiOperation({
    summary: "Development challenges by standardized skill (desc)",
  })
  getDevelopmentChallengesByTechnology() {
    return this.development.getDevelopmentChallengesByTechnology();
  }
}
