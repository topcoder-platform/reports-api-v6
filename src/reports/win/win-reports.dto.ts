import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { Type } from "class-transformer";
import { IsInt, IsOptional, Matches, Max, Min } from "class-validator";

/** Filters and bounded pagination accepted by GET /v6/reports/WIN. */
export class WinReportQueryDto {
  @ApiPropertyOptional({ description: "Project ID, represented as a string." })
  @IsOptional()
  @Matches(/^[1-9]\d{0,17}$/)
  projectId?: string;

  @ApiPropertyOptional({ default: 1, minimum: 1, maximum: 1000000 })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(1000000)
  page = 1;

  @ApiPropertyOptional({ default: 100, minimum: 1, maximum: 100 })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  perPage = 100;
}

/**
 * WIN export rows retain all stored showcase fields and attach current project,
 * taxonomy and media metadata. IDs are strings to preserve bigint precision.
 */
export class WinShowcasePostDto {
  [key: string]: unknown;

  @ApiProperty() id: string;
  @ApiProperty() projectId: string;
  @ApiProperty() title: string;
  @ApiPropertyOptional() type: string | null;
  @ApiPropertyOptional() customer: string | null;
  @ApiPropertyOptional() smu: string | null;
  @ApiPropertyOptional() smuOther: string | null;
  @ApiPropertyOptional({ description: "YYYY-MM-DD calendar date." })
  dealCloseDate: string | null;
  @ApiPropertyOptional() challenge: string | null;
  @ApiProperty({ description: "The Solution, in the existing content field." })
  content: string;
  @ApiPropertyOptional() businessImpact: string | null;
  @ApiPropertyOptional() keyWin: string | null;
  @ApiPropertyOptional() currentStatus: string | null;
  @ApiPropertyOptional() owner: string | null;
  @ApiProperty() sendToWin: boolean;
  @ApiProperty({ type: [Object] }) challengeMetadata: Record<string, unknown>[];
  @ApiProperty({ type: [Object] }) industries: Record<string, unknown>[];
  @ApiProperty({ type: [Object] }) categories: Record<string, unknown>[];
  @ApiProperty({ type: [Object] }) media: Record<string, unknown>[];
  @ApiProperty({ type: Object }) project: Record<string, unknown>;
}

/** Paginated snapshot returned to a WIN API caller, including an empty-page total. */
export class WinReportResponseDto {
  @ApiProperty({ type: [WinShowcasePostDto] }) data: WinShowcasePostDto[];
  @ApiProperty() total: number;
  @ApiProperty() page: number;
  @ApiProperty() perPage: number;
}
