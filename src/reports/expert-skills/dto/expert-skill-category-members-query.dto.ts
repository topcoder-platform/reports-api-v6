import { ApiProperty } from "@nestjs/swagger";
import { IsNotEmpty, IsString } from "class-validator";

export class ExpertSkillCategoryMembersQueryDto {
  @ApiProperty({
    name: "selectedcategory",
    description:
      "Category name from the standardized-skills catalog, or the category UUID",
    example: "Programming and Development",
  })
  @IsString()
  @IsNotEmpty()
  selectedcategory!: string;
}
