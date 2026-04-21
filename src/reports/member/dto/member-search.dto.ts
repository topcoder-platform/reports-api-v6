import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { Type } from "class-transformer";
import {
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  ArrayNotEmpty,
  Max,
  Min,
  ValidateNested,
} from "class-validator";

export class SkillFilterDto {
  @ApiProperty({ description: "Skill UUID", format: "uuid" })
  @IsUUID("4")
  id!: string;

  @ApiPropertyOptional({
    description: "Minimum number of wins required for this skill (inclusive).",
    minimum: 1,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Type(() => Number)
  wins?: number;
}

export class MemberSearchBodyDto {
  @ApiPropertyOptional({
    description:
      "Skills to filter candidates by. Each entry references a skill ID and an optional minimum win count.",
    type: [SkillFilterDto],
  })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SkillFilterDto)
  skills?: SkillFilterDto[];

  @ApiPropertyOptional({
    description:
      "Controls how multiple skills are combined. OR returns candidates with any of the skills; AND requires all skills. Defaults to OR.",
    enum: ["OR", "AND"],
    default: "OR",
  })
  @IsOptional()
  @IsIn(["OR", "AND"])
  skillSearchType?: "OR" | "AND";

  @ApiPropertyOptional({
    description:
      "When true, only return members who have set the open-to-work / available-for-gigs flag.",
  })
  @IsOptional()
  @IsBoolean()
  openToWork?: boolean;

  @ApiPropertyOptional({
    description:
      "When true, only return members who registered for a challenge or work item in the past 3 months.",
  })
  @IsOptional()
  @IsBoolean()
  recentlyActive?: boolean;

  @ApiPropertyOptional({
    description:
      "When true, only return members with a verified Trolley payment profile.",
  })
  @IsOptional()
  @IsBoolean()
  verifiedProfile?: boolean;

  @ApiPropertyOptional({
    description:
      "Filter by multiple country names or country codes (case-insensitive).",
    type: [String],
    example: ["US", "Australia"],
  })
  @IsOptional()
  @IsArray()
  @ArrayNotEmpty()
  @IsString({ each: true })
  countries?: string[];

  @ApiPropertyOptional({
    description:
      "Sort field for returned members. matchIndex sorts by best skill match first; handle sorts alphabetically.",
    enum: ["matchIndex", "handle"],
    default: "matchIndex",
  })
  @IsOptional()
  @IsIn(["matchIndex", "handle"])
  sortBy?: "matchIndex" | "handle";

  @ApiPropertyOptional({
    description: "Sort direction for the selected sort field.",
    enum: ["asc", "desc"],
    default: "desc",
  })
  @IsOptional()
  @IsIn(["asc", "desc"])
  sortOrder?: "asc" | "desc";

  @ApiPropertyOptional({
    description: "Page number (1-based). Defaults to 1.",
    minimum: 1,
    default: 1,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Type(() => Number)
  page?: number;

  @ApiPropertyOptional({
    description: "Number of results per page. Defaults to 8, maximum 100.",
    minimum: 1,
    maximum: 100,
    default: 8,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(100)
  @Type(() => Number)
  limit?: number;
}
