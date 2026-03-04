import { ApiProperty } from "@nestjs/swagger";
import { IsNotEmpty, IsString } from "class-validator";

/**
 * Path parameters used to retrieve challenge user reports by challenge ID.
 */
export class ChallengeUsersPathParamDto {
  @ApiProperty({
    required: true,
    description: "Challenge ID to retrieve user report data for",
  })
  @IsString()
  @IsNotEmpty()
  challengeId: string;
}

/**
 * User record returned by challenge user reports including resolved country.
 * For Marathon Match challenges, submissionScore contains the best aggregate score.
 */
export interface ChallengeUserRecordDto {
  userId: number;
  handle: string;
  email: string | null;
  country: string | null;
  submissionScore?: number | null;
}
