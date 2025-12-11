import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsDateString, IsOptional } from "class-validator";

export class MemberPaymentAccrualQueryDto {
  @ApiPropertyOptional({
    description:
      "Start date (inclusive) for filtering payment creation date in ISO 8601 format",
    example: "2024-01-01T00:00:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({
    description:
      "End date (inclusive) for filtering payment creation date in ISO 8601 format",
    example: "2024-01-31T23:59:59.000Z",
  })
  @IsOptional()
  @IsDateString()
  endDate?: string;
}
