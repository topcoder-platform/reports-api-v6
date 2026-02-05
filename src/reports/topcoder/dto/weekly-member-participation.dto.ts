import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsDateString, IsOptional } from "class-validator";

export class WeeklyMemberParticipationQueryDto {
  @ApiPropertyOptional({
    description:
      "Start date (inclusive) for filtering challenge posting date in ISO 8601 format",
    example: "2024-01-01T00:00:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({
    description:
      "End date (exclusive) for filtering challenge posting date in ISO 8601 format",
    example: "2024-02-01T00:00:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  endDate?: string;
}
