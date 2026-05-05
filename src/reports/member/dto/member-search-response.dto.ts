import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";

export class MatchedSkillDto {
  @ApiProperty({ description: "Skill UUID" })
  id!: string;

  @ApiProperty({ description: "Skill name" })
  name!: string;

  @ApiProperty({
    description:
      "True when the member has win credit and/or at least one platform skill event for this skill (e.g. submission, review); false for self-declared only.",
  })
  isVerified!: boolean;

  @ApiProperty({ description: "Total challenge-win events for this skill" })
  wins!: number;

  @ApiProperty({
    description: "Total skill events (all types) for this skill",
  })
  submitted!: number;
}

export class MemberResultDto {
  @ApiProperty({ description: "Member user ID" })
  id!: string;

  @ApiProperty({ description: "Member handle" })
  handle!: string;

  @ApiProperty({ description: "Full name (first + last)" })
  name!: string;

  @ApiPropertyOptional({ description: "Profile photo URL", nullable: true })
  photoUrl!: string | null;

  @ApiProperty({
    description:
      "True when the member registered for any work type in the past 3 months.",
  })
  isRecentlyActive!: boolean;

  @ApiProperty({
    description: "True when the member has a verified Trolley payment profile.",
  })
  isVerified!: boolean;

  @ApiProperty({
    description: "True when the member is available for gigs.",
  })
  openToWork!: boolean;

  @ApiProperty({
    description: 'Member location in "city country" format.',
    example: "Sydney Australia",
  })
  location!: string;

  @ApiProperty({ type: [MatchedSkillDto] })
  matchedSkills!: MatchedSkillDto[];

  @ApiProperty({
    description:
      "Match score 0–100 based on skill win rate. Ceiled to nearest integer.",
  })
  matchIndex!: number;
}

export class MemberSearchResponseDto {
  @ApiProperty({ description: "Total number of matching members" })
  total!: number;

  @ApiProperty({ description: "Current page number" })
  page!: number;

  @ApiProperty({ description: "Results per page" })
  limit!: number;

  @ApiProperty({ type: [MemberResultDto] })
  data!: MemberResultDto[];
}
