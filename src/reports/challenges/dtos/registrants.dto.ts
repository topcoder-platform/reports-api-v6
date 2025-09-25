import { ApiProperty } from "@nestjs/swagger";
import { Transform } from "class-transformer";
import {
  IsDateString,
  IsNotEmpty,
  IsOptional,
  IsString,
} from "class-validator";
import { transformArray } from "src/common/validation.util";

enum ChallengeStatus {
  NEW = "NEW",
  DRAFT = "DRAFT",
  APPROVED = "APPROVED",
  ACTIVE = "ACTIVE",
  COMPLETED = "COMPLETED",
  DELETED = "DELETED",
  CANCELLED = "CANCELLED",
  CANCELLED_FAILED_REVIEW = "CANCELLED_FAILED_REVIEW",
  CANCELLED_FAILED_SCREENING = "CANCELLED_FAILED_SCREENING",
  CANCELLED_ZERO_SUBMISSIONS = "CANCELLED_ZERO_SUBMISSIONS",
  CANCELLED_WINNER_UNRESPONSIVE = "CANCELLED_WINNER_UNRESPONSIVE",
  CANCELLED_CLIENT_REQUEST = "CANCELLED_CLIENT_REQUEST",
  CANCELLED_REQUIREMENTS_INFEASIBLE = "CANCELLED_REQUIREMENTS_INFEASIBLE",
  CANCELLED_ZERO_REGISTRATIONS = "CANCELLED_ZERO_REGISTRATIONS",
  CANCELLED_PAYMENT_FAILED = "CANCELLED_PAYMENT_FAILED",
}

export class ChallengeRegistrantsQueryDto {
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

  @ApiProperty({
    required: false,
    description:
      "List of billing account IDs associated with the payments to retrieve",
    example: ["80001012"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  billingAccountIds?: string[];

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
}

export interface ChallengeRegistrantsResponseDto {
  registrantHandle: string;
  challengeId: string;
  winnerHandle: string | null;
  challengeCompletedDate: string | null;
  registrantFinalScore?: number;
  challengeStatus: string;
}
