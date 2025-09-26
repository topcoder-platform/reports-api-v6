import { ApiProperty } from "@nestjs/swagger";

export class SubmissionsReviewDto {
  @ApiProperty({ description: "Name of the skill" })
  skillName: string;

  @ApiProperty({ description: "Count of distinct challenges for the skill" })
  challengeCount: number;
}
