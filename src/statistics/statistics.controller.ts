import { Controller, Get } from "@nestjs/common";
import { ApiOperation, ApiTags } from "@nestjs/swagger";
import { SrmDataService } from "./srm-data.service";

@ApiTags("Statistics")
@Controller("/statistics")
export class StatisticsController {
  constructor(private readonly srm: SrmDataService) {}

  @Get("/srm/top-rated")
  @ApiOperation({ summary: "Highest rated SRMs (static)" })
  getSrmTopRated() {
    return this.srm.getTopRated();
  }

  @Get("/srm/country-ratings")
  @ApiOperation({ summary: "SRM country ratings (static)" })
  getSrmCountryRatings() {
    return this.srm.getCountryRatings();
  }

  @Get("/srm/competitions-count")
  @ApiOperation({ summary: "SRM number of competitions (static)" })
  getSrmCompetitionsCount() {
    return this.srm.getCompetitionsCount();
  }
}

