import {
  Controller,
  Get,
  Header,
  Param,
  ParseEnumPipe,
  Query,
  UseGuards,
} from "@nestjs/common";
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiExtraModels,
  ApiForbiddenResponse,
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiProduces,
  ApiTags,
  ApiUnauthorizedResponse,
  getSchemaPath,
} from "@nestjs/swagger";
import { CsvSerializer } from "../../common/csv/csv-serializer";
import {
  AllDashboardsDto,
  ChallengeParticipationDashboardDto,
  DashboardQueryDto,
  DashboardResponse,
  DashboardSlug,
  MembersPaidDashboardDto,
  NewSignupsDashboardDto,
} from "./dashboard-reports.dto";
import { DashboardReportsService } from "./dashboard-reports.service";
import { DashboardReportsGuard } from "./guards/dashboard-reports.guard";

/**
 * Exposes landing, detail, and CSV endpoints for Reports Portal dashboards.
 */
@ApiTags("Dashboards")
@ApiBearerAuth()
@ApiExtraModels(
  NewSignupsDashboardDto,
  MembersPaidDashboardDto,
  ChallengeParticipationDashboardDto,
)
@ApiUnauthorizedResponse({ description: "Unauthenticated." })
@ApiForbiddenResponse({
  description:
    "Requires an Administrator or Talent Manager role for a human token, or the reports:all scope for a machine token.",
})
@UseGuards(DashboardReportsGuard)
@Controller("/dashboard")
export class DashboardReportsController {
  /**
   * Creates a dashboard controller.
   *
   * @param reports Dashboard query and mapping service.
   * @param csvSerializer Serializer used by explicit download endpoints.
   */
  constructor(
    private readonly reports: DashboardReportsService,
    private readonly csvSerializer: CsvSerializer,
  ) {}

  /**
   * Retrieves all dashboards for the landing page.
   *
   * @param query Optional half-open reporting range.
   * @returns All three complete dashboard responses.
   * @throws BadRequestException when the range is invalid.
   */
  @Get()
  @ApiOperation({
    summary: "Get all Reports Portal dashboards",
    description:
      "Returns monthly data for new signups, unique paid members, and challenge participation. The default range is the latest six UTC calendar months; summary metrics are all-time.",
  })
  @ApiOkResponse({ type: AllDashboardsDto })
  @ApiBadRequestResponse({ description: "Invalid reporting date range." })
  getAllDashboards(
    @Query() query: DashboardQueryDto,
  ): Promise<AllDashboardsDto> {
    return this.reports.getAllDashboards(query);
  }

  /**
   * Downloads all dashboard month data as one flat CSV.
   *
   * @param query Optional half-open reporting range.
   * @returns CSV text containing a dashboard discriminator on every row.
   * @throws BadRequestException when the range is invalid.
   */
  @Get("/export")
  @ApiOperation({ summary: "Export all dashboard month data as CSV" })
  @ApiProduces("text/csv")
  @ApiOkResponse({
    description: "Flat CSV rows for all three dashboards.",
    type: String,
  })
  @ApiBadRequestResponse({ description: "Invalid reporting date range." })
  @Header("Content-Type", "text/csv; charset=utf-8")
  @Header("Content-Disposition", 'attachment; filename="dashboards.csv"')
  async exportAllDashboards(
    @Query() query: DashboardQueryDto,
  ): Promise<string> {
    const rows = await this.reports.exportAllDashboards(query);
    return this.csvSerializer.serialize(rows);
  }

  /**
   * Downloads one dashboard's month data as a flat CSV.
   *
   * @param dashboard Public dashboard slug.
   * @param query Optional half-open reporting range.
   * @returns CSV text containing the selected dashboard's month rows.
   * @throws BadRequestException when the dashboard or range is invalid.
   */
  @Get("/:dashboard/export")
  @ApiOperation({ summary: "Export one dashboard's month data as CSV" })
  @ApiParam({ name: "dashboard", enum: DashboardSlug })
  @ApiProduces("text/csv")
  @ApiOkResponse({
    description: "Flat CSV rows for the selected dashboard.",
    type: String,
  })
  @ApiBadRequestResponse({
    description: "Invalid dashboard slug or reporting date range.",
  })
  @Header("Content-Type", "text/csv; charset=utf-8")
  @Header("Content-Disposition", 'attachment; filename="dashboard.csv"')
  async exportDashboard(
    @Param("dashboard", new ParseEnumPipe(DashboardSlug))
    dashboard: DashboardSlug,
    @Query() query: DashboardQueryDto,
  ): Promise<string> {
    const rows = await this.reports.exportDashboard(dashboard, query);
    return this.csvSerializer.serialize(rows);
  }

  /**
   * Retrieves one full dashboard for its detail view.
   *
   * @param dashboard Public dashboard slug.
   * @param query Optional half-open reporting range.
   * @returns Selected complete dashboard response.
   * @throws BadRequestException when the dashboard or range is invalid.
   */
  @Get("/:dashboard")
  @ApiOperation({ summary: "Get one Reports Portal dashboard" })
  @ApiParam({ name: "dashboard", enum: DashboardSlug })
  @ApiOkResponse({
    schema: {
      oneOf: [
        { $ref: getSchemaPath(NewSignupsDashboardDto) },
        { $ref: getSchemaPath(MembersPaidDashboardDto) },
        { $ref: getSchemaPath(ChallengeParticipationDashboardDto) },
      ],
    },
  })
  @ApiBadRequestResponse({
    description: "Invalid dashboard slug or reporting date range.",
  })
  getDashboard(
    @Param("dashboard", new ParseEnumPipe(DashboardSlug))
    dashboard: DashboardSlug,
    @Query() query: DashboardQueryDto,
  ): Promise<DashboardResponse> {
    return this.reports.getDashboard(dashboard, query);
  }
}
