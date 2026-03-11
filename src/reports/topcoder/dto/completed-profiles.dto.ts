import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsBoolean, IsOptional, IsString } from "class-validator";

export class CompletedProfilesQueryDto {
  @ApiPropertyOptional({
    description: "Filter by country code (ISO 3166-1 alpha-2)",
    example: "US",
  })
  @IsOptional()
  @IsString()
  countryCode?: string;

  @ApiPropertyOptional({
    description: "Filter to members who are currently open to work",
    example: true,
  })
  @IsOptional()
  @IsBoolean()
  openToWork?: boolean;
}
