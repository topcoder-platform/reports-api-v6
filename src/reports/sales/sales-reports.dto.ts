import { Transform, Type } from "class-transformer";
import {
  IsBoolean,
  IsIn,
  IsInt,
  IsISO8601,
  IsOptional,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
} from "class-validator";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";

/** Rejects datetimes and offsets so a bound is always a plain calendar day. */
const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

/**
 * Applies both shape and calendar validation to a range bound: the pattern keeps
 * the value date-only, and strict ISO 8601 rejects impossible days such as
 * 2026-02-30 and non-leap 2027-02-29 before they reach the snapshot comparison.
 * @param field Query parameter name used in the validation message.
 * @returns The decorators to spread onto the property.
 * @throws Does not throw.
 */
function IsCalendarDate(field: string): PropertyDecorator {
  const message = `${field} must be a real YYYY-MM-DD calendar date.`;
  return function apply(target: object, key: string | symbol): void {
    Matches(DATE_ONLY, { message })(target, key);
    IsISO8601({ strict: true, strictSeparator: true }, { message })(
      target,
      key,
    );
  };
}

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
    description:
      "Date or datetime column ID to range-filter; required with dateFrom/dateTo.",
  })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  dateColumn?: string;

  @ApiPropertyOptional({
    description: "Inclusive lower bound as a YYYY-MM-DD calendar date.",
    example: "2026-09-01",
  })
  @IsOptional()
  @IsCalendarDate("dateFrom")
  dateFrom?: string;

  @ApiPropertyOptional({
    description: "Inclusive upper bound as a YYYY-MM-DD calendar date.",
    example: "2026-09-30",
  })
  @IsOptional()
  @IsCalendarDate("dateTo")
  dateTo?: string;

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

/** A numeric column totalled across every matching row, not only the current page. */
export class SalesSummaryAmountDto {
  @ApiProperty() columnId: string;
  @ApiProperty() label: string;
  @ApiProperty({ description: "Sum of the matching rows' underlying values." })
  total: number;
  @ApiProperty({ description: "Rows contributing a value to this total." })
  count: number;
  @ApiPropertyOptional({
    description:
      "Shared currency of every contributing row; omitted when rows mix currencies.",
  })
  currencyCode?: string;
}

/** One distinct value of a category column, such as a pipeline stage. */
export class SalesSummaryBucketDto {
  @ApiProperty() label: string;
  @ApiProperty() count: number;
  @ApiProperty({
    description: "Sum of the primary amount column within this bucket.",
  })
  total: number;
}

/** A category column broken down into its distinct values, largest total first. */
export class SalesSummaryGroupDto {
  @ApiProperty() columnId: string;
  @ApiProperty() label: string;
  @ApiPropertyOptional({ description: "Column totalled in each bucket." })
  amountColumnId?: string;
  @ApiPropertyOptional() currencyCode?: string;
  @ApiProperty({ type: [SalesSummaryBucketDto] })
  buckets: SalesSummaryBucketDto[];
  @ApiProperty({
    description: "Buckets beyond the returned set, omitted from buckets[].",
  })
  otherBuckets: number;
}

/** Aggregates over every matching row in the snapshot, recomputed for each query. */
export class SalesSummaryDto {
  @ApiProperty({ description: "Matching rows; equal to total." })
  recordCount: number;
  @ApiProperty({ type: [SalesSummaryAmountDto] })
  amounts: SalesSummaryAmountDto[];
  @ApiProperty({ type: [SalesSummaryGroupDto] })
  groups: SalesSummaryGroupDto[];
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
  @ApiProperty({
    description:
      "Aggregates over all matching rows in the snapshot, not just this page.",
    type: SalesSummaryDto,
  })
  summary: SalesSummaryDto;
}
