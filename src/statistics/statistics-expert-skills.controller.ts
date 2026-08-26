import { Controller, Get, Query, UseGuards } from "@nestjs/common";
import {
  ApiBearerAuth,
  ApiOperation,
  ApiQuery,
  ApiResponse,
  ApiTags,
} from "@nestjs/swagger";
import { ExpertSkillsStatisticsService } from "./expert-skills-statistics.service";
import { ExpertSkillsGuard } from "./guards/expert-skills.guard";

@ApiTags("Statistics")
@ApiBearerAuth()
@UseGuards(ExpertSkillsGuard)
@Controller("/statistics/expert-skills")
export class StatisticsExpertSkillsController {
  constructor(private readonly expertSkills: ExpertSkillsStatisticsService) {}

  @Get("/categories")
  @ApiOperation({
    summary:
      "Skill categories from skills.skill_category with win-normalized bubble sizes",
    description:
      "Returns skill categories from the standardized-skills catalog, with win-normalized bubble sizes (3–10). Accessible by Administrator and Talent Manager roles only.",
  })
  @ApiResponse({ status: 401, description: "Unauthenticated" })
  @ApiResponse({ status: 403, description: "Forbidden – insufficient role" })
  getCategories() {
    return this.expertSkills.getCategories();
  }

  @Get("/category-members")
  @ApiOperation({
    summary: "Top 100 members in a skill category, sorted by wins",
    description:
      "Returns up to 100 members with wins in the selected skill category, sorted by wins descending. selectedcategory is the standardized-skills category name or UUID. Accessible by Administrator and Talent Manager roles only.",
  })
  @ApiQuery({
    name: "selectedcategory",
    required: true,
    description: "Standardized-skills category name or UUID",
  })
  @ApiResponse({ status: 401, description: "Unauthenticated" })
  @ApiResponse({ status: 403, description: "Forbidden – insufficient role" })
  @ApiResponse({ status: 404, description: "Skill category not found" })
  getCategoryMembers(@Query("selectedcategory") selectedcategory: string) {
    return this.expertSkills.getCategoryMembers(selectedcategory);
  }
}
