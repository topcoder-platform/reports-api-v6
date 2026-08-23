import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";

export class ExpertSkillBreakdownDto {
  @ApiProperty({ description: "Skill name" })
  name!: string;

  @ApiProperty({
    description: "Share of category wins for this skill, rounded to an integer",
  })
  percentage!: number;
}

export class ExpertSkillCategoryDto {
  @ApiProperty({ description: "Skill category UUID" })
  id!: string;

  @ApiProperty({
    description: "Category name from the standardized-skills catalog",
  })
  name!: string;

  @ApiProperty({
    description: "Official category name from the standardized-skills catalog",
  })
  officialName!: string;

  @ApiProperty({ description: "Hex color for the bubble" })
  color!: string;

  @ApiProperty({
    description: "Heroicon outline name used by the bubble UI",
    example: "TerminalIcon",
  })
  icon!: string;

  @ApiProperty({
    description:
      "Bubble size from 3–10, min-max normalized on sqrt(category wins) so outliers do not dominate",
  })
  size!: number;

  @ApiProperty({
    description: "Distinct members with a skill in this category",
  })
  totalMembers!: number;

  @ApiProperty({ description: "Active skills in this category" })
  totalSkills!: number;

  @ApiProperty({ type: [ExpertSkillBreakdownDto] })
  skillsBreakdown!: ExpertSkillBreakdownDto[];
}

export class ExpertSkillCategoryMemberDto {
  @ApiProperty({
    description: "ISO 3166-1 alpha-2 country code",
    example: "US",
  })
  countryCode!: string;

  @ApiProperty({ description: "Country display name", example: "USA" })
  countryName!: string;

  @ApiProperty({ description: "Member handle" })
  handle!: string;

  @ApiProperty({ description: "Display name (first name and last initial)" })
  name!: string;

  @ApiPropertyOptional({ description: "Profile photo URL", nullable: true })
  photoURL?: string | null;

  @ApiProperty({ description: "Maximum member rating" })
  rating!: number;

  @ApiProperty({ description: "Wins in the selected skill category" })
  wins!: number;
}
