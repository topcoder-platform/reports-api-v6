import { ApiProperty } from '@nestjs/swagger';

export class ChallengeTechnologyByUserDto {
  @ApiProperty({ description: 'Name of the challenge technology' })
  challengeTechnologyName: string;

  @ApiProperty({ description: 'Handle of the registrant/user' })
  challengeRegistrantHandle: string;

  @ApiProperty({ description: 'Email of the user' })
  userEmail: string;

  @ApiProperty({ description: 'Billing Account ID' })
  billingAccountID: number;

  @ApiProperty({ description: 'Count of distinct challenges the user participated in' })
  challengeDistinctCount: number;

  @ApiProperty({ description: 'Count of distinct challenges with submissions by the user' })
  submissionByAUser: number;

  @ApiProperty({ description: 'Count of distinct challenges won by the user' })
  challengeStatsWins: number;
}
