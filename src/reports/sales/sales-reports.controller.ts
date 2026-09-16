import { Controller, Get, Header, Query, UseGuards } from "@nestjs/common";
import {
  ApiBadGatewayResponse,
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiForbiddenResponse,
  ApiOkResponse,
  ApiOperation,
  ApiServiceUnavailableResponse,
  ApiTags,
  ApiUnauthorizedResponse,
} from "@nestjs/swagger";
import { Scopes } from "../../auth/decorators/scopes.decorator";
import { Scopes as AppScopes } from "../../app-constants";
import { SalesReportDto, SalesReportQueryDto } from "./sales-reports.dto";
import { SalesReportsGuard } from "./sales-reports.guard";
import { SalesReportsService } from "./sales-reports.service";

/** Exposes read-only Sales and machine-only WIN views over the same Salesforce snapshot. */
@ApiTags("Sales")
@ApiBearerAuth()
@ApiUnauthorizedResponse({ description: "Missing or invalid bearer token." })
@ApiForbiddenResponse({
  description:
    "Sales requires Admin/Talent Manager; WIN requires M2M reports:sales.",
})
@ApiBadRequestResponse({
  description: "Invalid pagination, sort column or filter.",
})
@ApiBadGatewayResponse({
  description: "Salesforce unavailable or returned an invalid report.",
})
@ApiServiceUnavailableResponse({
  description: "Server Salesforce configuration is missing or invalid.",
})
@UseGuards(SalesReportsGuard)
@Controller()
export class SalesReportsController {
  /** @param reports Shared read-only report service. Does not throw. */
  constructor(private readonly reports: SalesReportsService) {}

  /**
   * Supplies the Sales app with report metadata and a page of detail rows.
   * @param query Validated view options.
   * @returns Current Salesforce report page for an authorized human caller.
   * @throws BadRequestException for invalid columns; sanitized upstream errors propagate.
   */
  @Get("sales")
  @Header("Cache-Control", "private, no-store")
  @ApiOperation({
    summary: "Sales report for Administrators and Talent Managers",
  })
  @ApiOkResponse({ type: SalesReportDto })
  getSales(@Query() query: SalesReportQueryDto): Promise<SalesReportDto> {
    return this.reports.getReport(query);
  }

  /**
   * Supplies WIN with the same report contract using dedicated machine authorization.
   * @param query Validated view options.
   * @returns Current Salesforce report page for an M2M reports:sales caller.
   * @throws BadRequestException for invalid columns; sanitized upstream errors propagate.
   */
  @Get("win/sales")
  @Scopes(AppScopes.Sales)
  @Header("Cache-Control", "private, no-store")
  @ApiOperation({ summary: "WIN sales report (M2M reports:sales required)" })
  @ApiOkResponse({ type: SalesReportDto })
  getWinSales(@Query() query: SalesReportQueryDto): Promise<SalesReportDto> {
    return this.reports.getReport(query);
  }
}
