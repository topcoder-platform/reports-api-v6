import { Controller, Get, Header, Query, UseGuards } from "@nestjs/common";
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from "@nestjs/swagger";
import { SalesReportsGuard } from "./sales-reports.guard";
import {
  SalesProgressionDto,
  SalesProgressionQueryDto,
} from "./sales-progression.dto";
import { SalesProgressionService } from "./sales-progression.service";

/** Human-only Sales history endpoint, protected by the same roles as the pipeline. */
@ApiTags("Sales")
@ApiBearerAuth()
@UseGuards(SalesReportsGuard)
@Controller("sales/progression")
export class SalesProgressionController {
  /** @param reports Read-only history service. Does not throw. */
  constructor(private readonly reports: SalesProgressionService) {}

  /**
   * Retrieves forward movement and entry into won stages for the selected period.
   * @param query Validated calendar range and optional stage pair filters.
   * @returns Complete Salesforce summaries. @throws Validation/configuration/upstream errors.
   */
  @Get()
  @Header("Cache-Control", "private, no-store")
  @ApiOperation({
    summary: "Historical sales stage progression (Admin/Talent Manager)",
  })
  @ApiOkResponse({ type: SalesProgressionDto })
  getProgression(
    @Query() query: SalesProgressionQueryDto,
  ): Promise<SalesProgressionDto> {
    return this.reports.getReport(query);
  }
}
