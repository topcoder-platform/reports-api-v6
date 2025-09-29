import { ApiProperty } from '@nestjs/swagger';

export class ChallengeStatsByUserDto {
  @ApiProperty({ description: 'Handle of the registrant/user' })
  challengeRegistrantHandle: string;

  @ApiProperty({ description: 'Email of the user' })
  userEmail: string;

  @ApiProperty({ description: 'Count of distinct challenges the user participated in' })
  challengeDistinctCount: number;

  @ApiProperty({ description: 'Number of submissions made by the user' })
  submissionByAUser: number;

  @ApiProperty({ description: 'Number of challenges won by the user' })
  challengeStatsWins: number;
}
