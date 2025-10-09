import { Controller, Get } from "@nestjs/common";
import { ApiOperation, ApiTags } from "@nestjs/swagger";
import { SrmDataService } from "./srm-data.service";
import { MmDataService } from "./mm-data.service";

@ApiTags("Statistics")
@Controller("/statistics")
export class StatisticsController {
  constructor(
    private readonly srm: SrmDataService,
    private readonly mm: MmDataService,
  ) {}

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

  @Get("/mm/top-rated")
  @ApiOperation({ summary: "Highest rated Marathon Matches (static)" })
  getMmTopRated() {
    return this.mm.getTopRated();
  }

  @Get("/mm/country-ratings")
  @ApiOperation({ summary: "Marathon Match country ratings (static)" })
  getMmCountryRatings() {
    return this.mm.getCountryRatings();
  }

  @Get("/mm/top-10-finishes")
  @ApiOperation({ summary: "Marathon Match Top 10 finishes (static)" })
  getMmTop10Finishes() {
    return this.mm.getTop10Finishes();
  }

  @Get("/mm/competitions-count")
  @ApiOperation({ summary: "Marathon Match number of competitions (static)" })
  getMmCompetitionsCount() {
    return this.mm.getCompetitionsCount();
  }
}
