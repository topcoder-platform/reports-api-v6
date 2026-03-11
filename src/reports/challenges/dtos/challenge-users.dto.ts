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
 * Standard challenge submission-based reports expose submissionScore.
 * Marathon Match submission-based reports expose provisionalScore and finalRank.
 */
export interface ChallengeUserRecordDto {
  userId: number;
  handle: string;
  email: string | null;
  country: string | null;
  submissionScore?: number | null;
  provisionalScore?: number | null;
  finalRank?: number | null;
}
