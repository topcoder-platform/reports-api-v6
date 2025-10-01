import { ApiProperty } from "@nestjs/swagger";
import {
  IsDateString,
  IsNotEmpty,
  IsOptional,
  IsString,
} from "class-validator";
import { ChallengeStatus } from "./challenge-status.enum";
import { Transform } from "class-transformer";
import { transformArray } from "src/common/validation.util";

export class SubmissionLinksQueryDto {
  @ApiProperty({
    required: true,
    description: "Filter by challenge completion date (from)",
    example: "2023-01-01T00:00:00.000Z",
  })
  @IsDateString()
  completionDateFrom?: Date;

  @ApiProperty({
    required: false,
    description: "Filter by challenge completion date (to)",
    example: "2026-01-31T23:59:59.000Z",
  })
  @IsOptional()
  @IsDateString()
  completionDateTo?: Date;

  @ApiProperty({
    required: false,
    enum: ChallengeStatus,
    example: [ChallengeStatus.COMPLETED],
    isArray: true,
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  challengeStatus?: ChallengeStatus[];
}

export class SubmissionLinksDto {
  @ApiProperty({
    description: "Challenge ID",
  })
  challengeId: number;

  @ApiProperty({
    description: "Status of the challenge",
  })
  challengeStatus: ChallengeStatus;

  @ApiProperty({
    description: "The date at which the challenge is completed",
  })
  challengeCompletedDate: string | null;

  @ApiProperty({
    description: "The registration handle of the submitter",
  })
  registrantHandle: string;

  @ApiProperty({
    description:
      "The final score received by the registrant on that submission",
  })
  registrantFinalScore: number;

  @ApiProperty({
    description:
      "This denotes if the submission has passed. If the final score is greater than 98 then its considered pass",
  })
  didSubmissionPass: boolean;

  @ApiProperty({
    description: "The link to the submission url",
  })
  submissionUrl: string;

  @ApiProperty({
    description: "Submission ID",
  })
  submissionId: number;

  @ApiProperty({
    description: "Submission creation date",
  })
  submissionCreatedDate: string;
}
