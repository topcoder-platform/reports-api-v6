import { Controller, Get, Query } from "@nestjs/common";
import { ApiOperation, ApiQuery, ApiTags } from "@nestjs/swagger";
import { ExpertSkillsStatisticsService } from "./expert-skills-statistics.service";

@ApiTags("Statistics")
@Controller("/statistics/expert-skills")
export class StatisticsExpertSkillsController {
  constructor(private readonly expertSkills: ExpertSkillsStatisticsService) {}

  @Get("/categories")
  @ApiOperation({
    summary:
      "Skill categories from the standardized-skills catalog with win-normalized bubble sizes",
  })
  getCategories() {
    return this.expertSkills.getCategories();
  }

  @Get("/category-members")
  @ApiOperation({
    summary: "Top 100 members in a skill category, sorted by wins",
  })
  @ApiQuery({
    name: "selectedcategory",
    required: true,
    description: "Standardized-skills category name or UUID",
  })
  getCategoryMembers(@Query("selectedcategory") selectedcategory: string) {
    return this.expertSkills.getCategoryMembers(selectedcategory);
  }
}
