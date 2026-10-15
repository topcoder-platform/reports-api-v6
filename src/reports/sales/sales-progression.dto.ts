import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import {
  IsISO8601,
  IsOptional,
  IsString,
  Matches,
  MaxLength,
} from "class-validator";

/** Calendar period and exact stage filters for historical movement, validated at the HTTP boundary. */
export class SalesProgressionQueryDto {
  @ApiProperty({
    description:
      "Inclusive history event date, in the Salesforce reporting timezone.",
  })
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  @IsISO8601({ strict: true })
  dateFrom: string;

  @ApiProperty({
    description:
      "Inclusive history event date; maximum 366 inclusive days in the period.",
  })
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  @IsISO8601({ strict: true })
  dateTo: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(100)
  fromStage?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(100)
  toStage?: string;
}

/** One historical stage pair; opportunities are distinct within this pair only. */
export class SalesTransitionDto {
  @ApiProperty() fromStage: string;
  @ApiProperty() toStage: string;
  @ApiProperty() opportunities: number;
  @ApiProperty() transitions: number;
}

/** Salesforce-calculated distinct total and event count for a movement predicate. */
export class SalesMovementDto {
  @ApiProperty() opportunities: number;
  @ApiProperty() transitions: number;
  @ApiProperty({ type: [SalesTransitionDto] }) breakdown: SalesTransitionDto[];
}

/** Complete summary-only report; no opportunity snapshots or raw history are persisted. */
export class SalesProgressionDto {
  @ApiProperty() dateFrom: string;
  @ApiProperty() dateTo: string;
  @ApiPropertyOptional() fromStage?: string;
  @ApiPropertyOptional() toStage?: string;
  @ApiProperty() timeZone: string;
  @ApiProperty({ type: [String] }) stages: string[];
  @ApiProperty({ type: [String] }) openStages: string[];
  @ApiProperty({ type: [String] }) wonStages: string[];
  @ApiProperty({ type: SalesMovementDto }) progressed: SalesMovementDto;
  @ApiProperty({ type: SalesMovementDto }) won: SalesMovementDto;
  @ApiProperty() refreshedAt: string;
  @ApiProperty() refreshAfterSeconds: number;
}
