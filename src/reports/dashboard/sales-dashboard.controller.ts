import {
  Controller,
  Get,
  Param,
  ParseEnumPipe,
  Query,
  UseGuards,
} from "@nestjs/common";
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiTags,
} from "@nestjs/swagger";
import { DashboardReportsGuard } from "./guards/dashboard-reports.guard";
import {
  SalesDashboardDto,
  SalesDashboardQueryDto,
  SalesDashboardSection,
} from "./sales-dashboard.dto";
import { SalesDashboardService } from "./sales-dashboard.service";

/** Serves monthly business dashboards to authorized Reports and Sales portal users. */
@ApiTags("Dashboards")
@ApiBearerAuth()
@UseGuards(DashboardReportsGuard)
@Controller("/sales-dashboard")
export class SalesDashboardController {
  /** @param reports Monthly aggregation service. Does not throw. */
  constructor(private readonly reports: SalesDashboardService) {}

  /**
   * Loads one section so an unavailable source does not block the other charts.
   * @param section Supported dashboard section.
   * @param query Portal scope, date basis and optional half-open UTC range.
   * @returns Monthly charts and source notices.
   * @throws BadRequestException for invalid queries; sanitized source errors otherwise.
   */
  @Get(":section")
  @ApiOperation({ summary: "Get a monthly sales dashboard section" })
  @ApiParam({ name: "section", enum: SalesDashboardSection })
  @ApiOkResponse({ type: SalesDashboardDto })
  getSection(
    @Param("section", new ParseEnumPipe(SalesDashboardSection))
    section: SalesDashboardSection,
    @Query() query: SalesDashboardQueryDto,
  ): Promise<SalesDashboardDto> {
    return this.reports.load(section, query);
  }
}
