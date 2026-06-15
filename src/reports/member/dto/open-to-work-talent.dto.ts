import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { Type } from "class-transformer";
import { IsIn, IsInt, IsOptional, IsString, Max, Min } from "class-validator";

export type OpenToWorkAvailability = "FULL_TIME" | "PART_TIME";

/**
 * Query filters for the open-to-work Talent report.
 *
 * The reports UI uses these filters to page through deployment-ready members
 * and to request role-specific CSV exports.
 */
export class OpenToWorkTalentQueryDto {
  @ApiPropertyOptional({
    description:
      "Preferred role value from the openToWork personalization trait.",
    example: "FULL_STACK_DEVELOPER",
  })
  @IsOptional()
  @IsString()
  role?: string;

  @ApiPropertyOptional({
    description:
      "Availability value from the openToWork personalization trait.",
    enum: ["FULL_TIME", "PART_TIME"],
  })
  @IsOptional()
  @IsIn(["FULL_TIME", "PART_TIME"])
  availability?: OpenToWorkAvailability;

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
    description: "Number of results per page. Defaults to 10, maximum 100.",
    minimum: 1,
    maximum: 100,
    default: 10,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(100)
  @Type(() => Number)
  perPage?: number;
}

/**
 * Preferred-role aggregate for the open-to-work Talent report.
 */
export class OpenToWorkTalentRoleCountDto {
  @ApiProperty({ description: "Preferred role value." })
  role!: string;

  @ApiProperty({
    description: "Number of open-to-work members with this role.",
  })
  count!: number;
}

/**
 * Member row returned to the reports UI Talent tab.
 */
export class OpenToWorkTalentMemberDto {
  @ApiProperty({ description: "Member user ID." })
  userId!: string;

  @ApiProperty({ description: "Topcoder handle." })
  handle!: string;

  @ApiPropertyOptional({ description: "First name.", nullable: true })
  firstName!: string | null;

  @ApiPropertyOptional({ description: "Last name.", nullable: true })
  lastName!: string | null;

  @ApiPropertyOptional({
    description: "Country or country code.",
    nullable: true,
  })
  country!: string | null;

  @ApiPropertyOptional({
    description: "Open-to-work availability value.",
    nullable: true,
  })
  availability!: string | null;

  @ApiProperty({ description: "Preferred role values.", type: [String] })
  preferredRoles!: string[];

  @ApiPropertyOptional({ description: "Member signup date.", nullable: true })
  memberSince!: string | null;

  @ApiPropertyOptional({
    description: "Highest Topcoder rating.",
    nullable: true,
  })
  maxRating!: number | null;

  @ApiProperty({ description: "First-place challenge wins." })
  challengeWins!: number;

  @ApiProperty({ description: "First-place task wins." })
  taskWins!: number;

  @ApiProperty({ description: "Combined first-place challenge and task wins." })
  totalWins!: number;
}

/**
 * Dashboard response for the reports UI Talent tab.
 */
export class OpenToWorkTalentResponseDto {
  @ApiProperty({ description: "Distinct open-to-work member count." })
  totalMembers!: number;

  @ApiProperty({ description: "Members matching the selected filters." })
  total!: number;

  @ApiProperty({ description: "Current page number." })
  page!: number;

  @ApiProperty({ description: "Results per page." })
  perPage!: number;

  @ApiProperty({ type: [OpenToWorkTalentRoleCountDto] })
  roleCounts!: OpenToWorkTalentRoleCountDto[];

  @ApiProperty({ type: [OpenToWorkTalentMemberDto] })
  data!: OpenToWorkTalentMemberDto[];
}
