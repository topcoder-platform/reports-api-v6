import { ApiProperty } from "@nestjs/swagger";
import {
  IsDateString,
  IsNotEmpty,
  IsOptional,
  IsString,
} from "class-validator";
import { Transform } from "class-transformer";
import { transformArray } from "src/common/validation.util";
import { ChallengeStatus } from "./challenge-status.enum";

/** Filters for the AI-assisted submissions report. All filters are optional. */
export class AiAssistedSubmissionsQueryDto {
  @ApiProperty({
    required: false,
    description: "Only include submissions for this challenge ID",
  })
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  challengeId?: string;

  @ApiProperty({
    required: false,
    enum: ChallengeStatus,
    example: [ChallengeStatus.ACTIVE, ChallengeStatus.COMPLETED],
    isArray: true,
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  challengeStatus?: ChallengeStatus[];

  @ApiProperty({
    required: false,
    description: "Only include submissions made on or after this date",
    example: "2026-11-01T00:00:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  submittedDateFrom?: string;

  @ApiProperty({
    required: false,
    description: "Only include submissions made on or before this date",
    example: "2026-11-30T23:59:59.000Z",
  })
  @IsOptional()
  @IsDateString()
  submittedDateTo?: string;
}

/** One submission whose submitter answered the AI-usage question. */
export class AiAssistedSubmissionDto {
  @ApiProperty({ description: "Challenge ID" })
  challengeId: string;

  @ApiProperty({ description: "Challenge name" })
  challengeName: string;

  @ApiProperty({ description: "Challenge track name", nullable: true })
  challengeTrack: string | null;

  @ApiProperty({ description: "Challenge type name", nullable: true })
  challengeType: string | null;

  @ApiProperty({ description: "Challenge status", enum: ChallengeStatus })
  challengeStatus: ChallengeStatus;

  @ApiProperty({ description: "Submission ID" })
  submissionId: string;

  @ApiProperty({ description: "Submission type" })
  submissionType: string;

  @ApiProperty({ description: "Submitter member ID" })
  memberId: string;

  @ApiProperty({ description: "Submitter handle", nullable: true })
  submitterHandle: string | null;

  @ApiProperty({
    description:
      "The submitter's answer: true when they reported that AI tools did most of the work",
  })
  aiAssisted: boolean;

  @ApiProperty({ description: "Submission date" })
  submittedDate: string;
}
