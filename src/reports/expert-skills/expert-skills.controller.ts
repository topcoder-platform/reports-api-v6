import { Controller, Get, Query, UseGuards } from "@nestjs/common";
import {
  ApiBearerAuth,
  ApiOperation,
  ApiQuery,
  ApiResponse,
  ApiTags,
} from "@nestjs/swagger";
import { ExpertSkillCategoryMembersQueryDto } from "./dto/expert-skill-category-members-query.dto";
import {
  ExpertSkillCategoryDto,
  ExpertSkillCategoryMemberDto,
} from "./dto/expert-skill-category.dto";
import { ExpertSkillsGuard } from "./guards/expert-skills.guard";
import { ExpertSkillsService } from "./expert-skills.service";

@ApiTags("Expert Skills")
@ApiBearerAuth()
@UseGuards(ExpertSkillsGuard)
@Controller()
export class ExpertSkillsController {
  constructor(private readonly expertSkillsService: ExpertSkillsService) {}

  @Get("expert-skill-categories")
  @ApiOperation({
    summary: "List skill categories for the Skill Statistics bubble view",
    description:
      "Returns skill categories from the standardized-skills catalog, with win-normalized bubble sizes (3–10). Accessible by Administrator and Talent Manager roles only.",
  })
  @ApiResponse({ status: 200, type: [ExpertSkillCategoryDto] })
  @ApiResponse({ status: 401, description: "Unauthenticated" })
  @ApiResponse({ status: 403, description: "Forbidden – insufficient role" })
  getCategories(): Promise<ExpertSkillCategoryDto[]> {
    return this.expertSkillsService.getCategories();
  }

  @Get("expert-skill-category-members")
  @ApiOperation({
    summary: "List top members for a skill category",
    description:
      "Returns up to 100 members with wins in the selected skill category, sorted by wins descending. selectedcategory is the standardized-skills category name or UUID. Accessible by Administrator and Talent Manager roles only.",
  })
  @ApiQuery({
    name: "selectedcategory",
    required: true,
    description: "Standardized-skills category name or UUID",
  })
  @ApiResponse({ status: 200, type: [ExpertSkillCategoryMemberDto] })
  @ApiResponse({ status: 400, description: "Validation error" })
  @ApiResponse({ status: 401, description: "Unauthenticated" })
  @ApiResponse({ status: 403, description: "Forbidden – insufficient role" })
  @ApiResponse({ status: 404, description: "Skill category not found" })
  getCategoryMembers(
    @Query() query: ExpertSkillCategoryMembersQueryDto,
  ): Promise<ExpertSkillCategoryMemberDto[]> {
    return this.expertSkillsService.getCategoryMembers(query.selectedcategory);
  }
}
