import { Controller, Get } from "@nestjs/common";
import { ApiOperation, ApiTags } from "@nestjs/swagger";
import { GeneralStatisticsService } from "./general-statistics.service";

@ApiTags("Statistics")
@Controller("/statistics/general")
export class StatisticsGeneralController {
  constructor(private readonly general: GeneralStatisticsService) {}

  // Top values
  @Get("/member-count")
  @ApiOperation({ summary: "Total number of member records" })
  getMemberCount() {
    return this.general.getMemberCount();
  }

  @Get("/total-prizes")
  @ApiOperation({ summary: "Total amount of all payments" })
  getTotalPrizes() {
    return this.general.getTotalPrizes();
  }

  @Get("/completed-challenges")
  @ApiOperation({ summary: "Total number of completed challenges" })
  getCompletedChallengesCount() {
    return this.general.getCompletedChallengesCount();
  }

  // General tab
  @Get("/countries-represented")
  @ApiOperation({ summary: "Member count by country (desc)" })
  getCountriesRepresented() {
    return this.general.getCountriesRepresented();
  }

  @Get("/country-member-details")
  @ApiOperation({
    summary: "Member, skill, and top-member details by country (desc)",
  })
  getCountryMemberDetails() {
    return this.general.getCountryMemberDetails();
  }

  @Get("/first-place-by-country")
  @ApiOperation({ summary: "First place finishes by country (desc)" })
  getFirstPlaceByCountry() {
    return this.general.getFirstPlaceByCountry();
  }

  @Get("/top-winners-by-country")
  @ApiOperation({
    summary: "First place finishes and top three winners by country (desc)",
  })
  getTopWinnersByCountry() {
    return this.general.getTopWinnersByCountry();
  }

  @Get("/copiloted-challenges")
  @ApiOperation({ summary: "Copiloted challenges by member (desc)" })
  getCopilotedChallenges() {
    return this.general.getCopilotedChallenges();
  }

  @Get("/reviews-by-member")
  @ApiOperation({ summary: "Review participation by member (desc)" })
  getReviewsByMember() {
    return this.general.getReviewCountsByMember();
  }
}
