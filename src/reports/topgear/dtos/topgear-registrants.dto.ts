import { ApiProperty } from "@nestjs/swagger";

export class TopgearRegistrantDto {
  @ApiProperty({ description: "Handle of the registrant" })
  registrantHandle: string;
  @ApiProperty({ description: "Challenge Id" })
  challengeId: number;
  @ApiProperty({ description: "Did registrant submitted?" })
  didRegistrantSubmit: boolean;
  @ApiProperty({ description: "Hanlde of the winner" })
  winnerHandle: string | null;
  @ApiProperty({ description: "Challenge completion date" })
  challengeCompletionDate: string | null;
  @ApiProperty({ description: "Challenge status" })
  challengeStatus: string;
  @ApiProperty({ description: "Project ID" })
  projectId: number;
  @ApiProperty({ description: "Name of the customer" })
  customerName: string | null;
  @ApiProperty({ description: "Registrant email id" })
  registrantEmail: string | null;
  @ApiProperty({ description: "Project scheduled end date" })
  projectScheduledEndDate: string | null;
  @ApiProperty({ description: "Submission score" })
  submissionScore: number | null;
}
