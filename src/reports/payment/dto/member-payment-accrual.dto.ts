import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsDateString, IsOptional } from "class-validator";

export class MemberPaymentAccrualQueryDto {
  @ApiPropertyOptional({
    description:
      "Start date (inclusive) for filtering payment creation date in YYYY-MM-DD format. For accepted ISO timestamps, only the written calendar-date portion is used",
    example: "2024-01-01",
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({
    description:
      "End date (inclusive through the full calendar day) for filtering payment creation date in YYYY-MM-DD format. For accepted ISO timestamps, only the written calendar-date portion is used",
    example: "2024-01-31",
  })
  @IsOptional()
  @IsDateString()
  endDate?: string;
}
