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
 * Marathon Match submission-based reports expose provisionalScore from the
 * latest submission. Completed Marathon Match reports also expose finalScore
 * and finalRank when final scoring data is available.
 */
export interface ChallengeUserRecordDto {
  userId: number;
  handle: string;
  email: string | null;
  firstName: string | null;
  lastName: string | null;
  country: string | null;
  submissionScore?: number | null;
  provisionalScore?: number | null;
  finalScore?: number | null;
  finalRank?: number | null;
}
