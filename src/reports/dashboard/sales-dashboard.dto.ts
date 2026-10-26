import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { IsEnum, IsOptional } from "class-validator";
import { DashboardQueryDto } from "./dashboard-reports.dto";

export enum SalesDashboardSection {
  Pipeline = "pipeline",
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
  @ApiProperty({ type: [String] }) notices: string[];
  /** Full customer series for the payments matrix, before top-five/Other grouping. */
  @ApiPropertyOptional({ type: SalesDashboardChartDto })
  customerPayments?: SalesDashboardChartDto;
}
