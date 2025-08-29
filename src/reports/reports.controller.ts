import { Controller, Get, Query, UseGuards } from "@nestjs/common";

import {
  ApiTags,
  ApiOperation,
  ApiQuery,
  ApiBearerAuth,
} from "@nestjs/swagger";

import { PermissionsGuard } from "../auth/guards/permissions.guard";
import { Scopes } from "../auth/decorators/scopes.decorator";
import { Scopes as AppScopes } from "../app-constants";

import { ReportsService } from "./reports.service";

@ApiTags("Topcoder Reports")
@Controller("/")
export class ReportsController {
  constructor(private readonly reports: ReportsService) {}

  @Get("topgear/hourly")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.TopgearHourly)
  @ApiBearerAuth()
  @ApiOperation({ summary: "Return the Topgear Hourly report details" })
  getTopgearHourly() {
    return this.reports.getTopgearHourly();
  }

  @Get("topgear/payments")
  @UseGuards(PermissionsGuard)
  @Scopes(AppScopes.AllReports, AppScopes.TopgearHourly)
  @ApiBearerAuth()
  @ApiOperation({
    summary: "Return the Topgear Payments from start_date to end_date",
  })
  @ApiQuery({
    name: "start_date",
    required: false,
    type: Date,
    description: "Start date",
  })
  @ApiQuery({
    name: "end_date",
    required: false,
    type: Date,
    description: "End date",
  })
  getTopgearPayments(
    @Query("start_date") start?: string,
    @Query("end_date") end?: string,
  ) {
    return this.reports.getTopgearPayments({ start, end });
  }
}
