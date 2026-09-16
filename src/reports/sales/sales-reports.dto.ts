import { Transform, Type } from "class-transformer";
import {
  IsBoolean,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
} from "class-validator";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";

/** Validated view options shared by the Sales UI and WIN report endpoint. */
export class SalesReportQueryDto {
  @ApiPropertyOptional({ default: 1, minimum: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(1000000)
  page = 1;

  @ApiPropertyOptional({ default: 25, minimum: 1, maximum: 200 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(200)
  perPage = 25;

  @ApiPropertyOptional({
    description: "Case-insensitive search across displayed values.",
  })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  search?: string;

  @ApiPropertyOptional({ description: "Column ID returned in columns[].id." })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  sortBy?: string;

  @ApiPropertyOptional({ enum: ["asc", "desc"], default: "asc" })
  @IsOptional()
  @IsIn(["asc", "desc"])
  sortOrder: "asc" | "desc" = "asc";

  @ApiPropertyOptional({
    description: "Column ID to filter; requires filterValue.",
  })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  filterColumn?: string;

  @ApiPropertyOptional({
    description: "Case-insensitive substring of the column's displayed value.",
  })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  filterValue?: string;

  @ApiPropertyOptional({
    default: false,
    description: "Refresh Salesforce data (minimum five-second interval).",
  })
  @IsOptional()
  @Transform(({ value }: { value: unknown }) =>
    value === "true" ? true : value === "false" ? false : value,
  )
  @IsBoolean()
  refresh = false;
}

/** Salesforce report metadata determines display labels and sortable column IDs. */
export class SalesColumnDto {
  @ApiProperty() id: string;
  @ApiProperty() label: string;
  @ApiProperty() dataType: string;
}

/** A safe display label paired with a typed value for sorting and WIN consumption. */
export class SalesCellDto {
  @ApiProperty() label: string;
  @ApiProperty({
    nullable: true,
    oneOf: [{ type: "string" }, { type: "number" }, { type: "boolean" }],
  })
  value: string | number | boolean | null;
  @ApiPropertyOptional() currencyCode?: string;
}

/** Detail cells in the same order as columns; ID identifies a row within a report snapshot. */
export class SalesRowDto {
  @ApiProperty() id: string;
  @ApiProperty({ type: [SalesCellDto] }) cells: SalesCellDto[];
}

/** Read-only report snapshot with explicit completeness and filtered pagination metadata. */
export class SalesReportDto {
  @ApiProperty() reportId: string;
  @ApiProperty() reportName: string;
  @ApiProperty({ type: [SalesColumnDto] }) columns: SalesColumnDto[];
  @ApiProperty({ type: [SalesRowDto] }) rows: SalesRowDto[];
  @ApiProperty({
    description:
      "Whether Salesforce returned every detail row, before local filtering.",
  })
  allData: boolean;
  @ApiProperty({
    description:
      "Number of detail rows received from Salesforce before local filtering.",
  })
  sourceRowCount: number;
  @ApiProperty({ description: "Number of matching rows in this snapshot." })
  total: number;
  @ApiProperty() page: number;
  @ApiProperty() perPage: number;
  @ApiProperty() totalPages: number;
  @ApiProperty({ format: "date-time" }) refreshedAt: string;
  @ApiProperty() refreshAfterSeconds: number;
}
