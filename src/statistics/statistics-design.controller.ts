import { Controller, Get } from "@nestjs/common";
import { ApiOperation, ApiTags } from "@nestjs/swagger";
import { DesignStatisticsService } from "./design-statistics.service";

@ApiTags("Statistics")
@Controller("/statistics/design")
export class StatisticsDesignController {
  constructor(private readonly design: DesignStatisticsService) {}

  @Get("/ui-design-wins")
  @ApiOperation({ summary: "Design 'Challenge' wins by member (desc)" })
  getUiDesignWins() {
    return this.design.getUiDesignWins();
  }

  @Get("/f2f-wins")
  @ApiOperation({ summary: "Design First2Finish wins by member (desc)" })
  getDesignF2FWins() {
    return this.design.getDesignF2FWins();
  }

  @Get("/lux-first-place-wins")
  @ApiOperation({ summary: "Design LUX first place wins by member (desc)" })
  getLuxFirstPlaceWins() {
    return this.design.getLuxFirstPlaceWins();
  }

  @Get("/lux-placements")
  @ApiOperation({ summary: "Design LUX placements by member (desc)" })
  getLuxPlacements() {
    return this.design.getLuxPlacements();
  }

  @Get("/rux-placements")
  @ApiOperation({ summary: "Design RUX placements by member (desc)" })
  getRuxPlacements() {
    return this.design.getRuxPlacements();
  }

  @Get("/first-time-submitters")
  @ApiOperation({ summary: "First-time design submitters in last 3 months" })
  getFirstTimeDesignSubmitters() {
    return this.design.getFirstTimeDesignSubmitters();
  }

  @Get("/countries-represented")
  @ApiOperation({ summary: "Design submitters by country (desc)" })
  getDesignCountriesRepresented() {
    return this.design.getDesignCountriesRepresented();
  }

  @Get("/first-place-by-country")
  @ApiOperation({ summary: "Design first place finishes by country (desc)" })
  getDesignFirstPlaceByCountry() {
    return this.design.getFirstPlaceByCountry();
  }

  @Get("/rux-first-place-wins")
  @ApiOperation({
    summary: "RUX first place design challenge wins by member (desc)",
  })
  getRuxFirstPlaceWins() {
    return this.design.getRuxFirstPlaceWins();
  }

  @Get("/wireframe-wins")
  @ApiOperation({
    summary: "Design wireframe challenge wins by member (desc)",
  })
  getWireframeWins() {
    return this.design.getWireframeWins();
  }
}
