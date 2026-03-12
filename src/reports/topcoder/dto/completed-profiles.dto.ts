import { ApiPropertyOptional } from "@nestjs/swagger";
import { Transform } from "class-transformer";
import {
  IsBoolean,
  IsNumberString,
  IsOptional,
  IsString,
} from "class-validator";

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
  @Transform(({ value }) =>
    value === undefined || value === null
      ? undefined
      : value === true || value === "true",
  )
  @IsBoolean()
  openToWork?: boolean;

  @ApiPropertyOptional({
    name: "skillId",
    description: "Filter by member skill IDs",
    type: String,
    isArray: true,
    example: ["123", "456"],
  })
  @IsOptional()
  @Transform(({ value }) => {
    if (value === undefined || value === null) {
      return undefined;
    }
    const values = Array.isArray(value) ? value : [value];
    return values.map((v) => String(v)).filter((v) => v.trim().length > 0);
  })
  @IsNumberString({}, { each: true })
  skillId?: string[];

  @ApiPropertyOptional({
    description: "Page number (1-based)",
    example: "1",
  })
  @IsOptional()
  @IsNumberString()
  page?: string;

  @ApiPropertyOptional({
    description: "Number of records per page",
    example: "50",
  })
  @IsOptional()
  @IsNumberString()
  perPage?: string;
}
