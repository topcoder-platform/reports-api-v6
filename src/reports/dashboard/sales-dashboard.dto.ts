import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { Transform } from "class-transformer";
import {
  ArrayMaxSize,
  IsArray,
  IsEnum,
  IsOptional,
  IsString,
  MaxLength,
} from "class-validator";
import { DashboardQueryDto } from "./dashboard-reports.dto";

export enum SalesDashboardSection {
  Bookings = "bookings",
  Pipeline = "pipeline",
  TaasPayments = "taas-payments",
  Revenue = "revenue",
  Payments = "payments",
  Talent = "talent",
  GrossMargin = "gross-margin",
}

/** Monthly dashboard controls, shared by both portals; Sales payment scope is applied in SQL. */
export class SalesDashboardQueryDto extends DashboardQueryDto {
  @ApiPropertyOptional({ enum: ["reports", "sales"], default: "reports" })
  @IsOptional()
  @IsEnum({ reports: "reports", sales: "sales" })
  portal?: "reports" | "sales";

  @ApiPropertyOptional({ enum: ["close", "created"], default: "close" })
  @IsOptional()
  @IsEnum({ close: "close", created: "created" })
  dateBasis?: "close" | "created";
  @ApiPropertyOptional({
    type: [String],
    description:
      "Exact category values, OR within a field and AND across fields; omit for all.",
  })
  @IsOptional()
  @Transform(({ value }: { value: unknown }) =>
    value === "" ? undefined : Array.isArray(value) ? value : [value],
  )
  @IsArray()
  @ArrayMaxSize(25)
  @IsString({ each: true })
  @MaxLength(100, { each: true })
  offeringType?: string[];

  @ApiPropertyOptional({
    type: [String],
    description:
      "Exact category values, OR within a field and AND across fields; omit for all.",
  })
  @IsOptional()
  @Transform(({ value }: { value: unknown }) =>
    value === "" ? undefined : Array.isArray(value) ? value : [value],
  )
  @IsArray()
  @ArrayMaxSize(25)
  @IsString({ each: true })
  @MaxLength(100, { each: true })
  dealCategory?: string[];

  @ApiPropertyOptional({
    type: [String],
    description:
      "Exact category values, OR within a field and AND across fields; omit for all.",
  })
  @IsOptional()
  @Transform(({ value }: { value: unknown }) =>
    value === "" ? undefined : Array.isArray(value) ? value : [value],
  )
  @IsArray()
  @ArrayMaxSize(25)
  @IsString({ each: true })
  @MaxLength(100, { each: true })
  customerType?: string[];
}

/** One zero-filled monthly chart, with nullable values for unknown percentages. */
export class SalesDashboardChartDto {
  @ApiProperty() id: string;
  @ApiProperty() title: string;
  @ApiProperty() description: string;
  @ApiProperty({ enum: ["currency", "count", "percent"] }) unit:
    | "currency"
    | "count"
    | "percent";
  @ApiProperty() stacked: boolean;
  @ApiProperty({ type: [Object] }) series: Array<{
    key: string;
    label: string;
  }>;
  @ApiProperty({ type: [Object] }) months: Array<{
    month: string;
    values: Record<string, number | null>;
  }>;
}

/** Independently loaded section; notices expose missing source data without fabricating metrics. */
export class SalesDashboardDto {
  @ApiProperty({ type: [SalesDashboardChartDto] })
  charts: SalesDashboardChartDto[];
  /** Unfiltered source categories so selecting one value does not remove the other choices. */
  @ApiPropertyOptional({ type: Object })
  filterOptions?: {
    offeringType: string[];
    dealCategory: string[];
    customerType: string[];
  };
  @ApiProperty({ type: [String] }) notices: string[];
  /** Full customer series for the payments matrix, before top-five/Other grouping. */
  @ApiPropertyOptional({ type: SalesDashboardChartDto })
  customerPayments?: SalesDashboardChartDto;
  /** All customer names from the revenue report, without top-category/Other grouping. */
  @ApiPropertyOptional({ type: SalesDashboardChartDto })
  customerRevenue?: SalesDashboardChartDto;
}
