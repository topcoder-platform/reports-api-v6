import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsDateString, IsOptional } from "class-validator";

export class RecentMemberDataQueryDto {
  @ApiPropertyOptional({
    description:
      "Start date (inclusive) for registration/payment filtering in ISO 8601 format",
    example: "2024-01-01T00:00:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;
}
