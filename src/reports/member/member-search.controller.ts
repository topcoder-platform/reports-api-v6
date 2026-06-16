import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Query,
  UseGuards,
  UseInterceptors,
} from "@nestjs/common";
import {
  ApiBearerAuth,
  ApiOperation,
  ApiProduces,
  ApiResponse,
  ApiTags,
} from "@nestjs/swagger";
import { MemberSearchBodyDto } from "./dto/member-search.dto";
import { MemberSearchResponseDto } from "./dto/member-search-response.dto";
import {
  OpenToWorkTalentQueryDto,
  OpenToWorkTalentResponseDto,
} from "./dto/open-to-work-talent.dto";
import { MemberSearchService } from "./member-search.service";
import { MemberSearchGuard } from "./guards/member-search.guard";
import { MemberTalentReportGuard } from "./guards/member-talent-report.guard";
import { CsvResponseInterceptor } from "../../common/interceptors/csv-response.interceptor";

@ApiTags("Member Search")
@ApiBearerAuth()
@UseGuards(MemberSearchGuard)
@Controller("member")
export class MemberSearchController {
  constructor(private readonly memberSearchService: MemberSearchService) {}

  /**
   * Returns dashboard data for the open-to-work Talent report.
   * @param query Role, availability, and pagination filters.
   * @returns Dashboard summary and paginated member rows.
   */
  @Get("open-to-work")
  @UseGuards(MemberTalentReportGuard)
  @ApiOperation({
    summary: "List open-to-work members by preferred role",
    description:
      "Returns open-to-work member totals, preferred-role counts, and a paginated member list. " +
      "Accessible by Administrator and Talent Manager users only.",
  })
  @ApiResponse({ status: 200, type: OpenToWorkTalentResponseDto })
  @ApiResponse({ status: 401, description: "Unauthenticated" })
  @ApiResponse({ status: 403, description: "Forbidden – insufficient role" })
  getOpenToWorkTalent(
    @Query() query: OpenToWorkTalentQueryDto,
  ): Promise<OpenToWorkTalentResponseDto> {
    return this.memberSearchService.getOpenToWorkTalent(query);
  }

  /**
   * Exports open-to-work Talent report rows including contact fields.
   * @param query Role and availability filters.
   * @returns Flat member rows serialized as CSV when requested with `Accept: text/csv`.
   */
  @Get("open-to-work/export")
  @UseGuards(MemberTalentReportGuard)
  @UseInterceptors(CsvResponseInterceptor)
  @ApiProduces("application/json", "text/csv")
  @ApiOperation({
    summary: "Export open-to-work members by preferred role",
    description:
      "Exports open-to-work members with email and phone fields. " +
      "Accessible by Administrator and Talent Manager users only.",
  })
  @ApiResponse({ status: 200, description: "Export successful." })
  @ApiResponse({ status: 401, description: "Unauthenticated" })
  @ApiResponse({ status: 403, description: "Forbidden – insufficient role" })
  exportOpenToWorkTalent(@Query() query: OpenToWorkTalentQueryDto) {
    return this.memberSearchService.exportOpenToWorkTalent(query);
  }

  @Post("search")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: "Search members for the Talent Search portal",
    description:
      "Returns a paginated list of members that satisfy the supplied filters, sorted by match index or handle in ascending or descending order. " +
      "Accessible by Administrator and Talent Manager roles only.",
  })
  @ApiResponse({ status: 200, type: MemberSearchResponseDto })
  @ApiResponse({ status: 400, description: "Validation error" })
  @ApiResponse({ status: 401, description: "Unauthenticated" })
  @ApiResponse({ status: 403, description: "Forbidden – insufficient role" })
  @ApiResponse({ status: 404, description: "One or more skill IDs not found" })
  search(@Body() body: MemberSearchBodyDto): Promise<MemberSearchResponseDto> {
    return this.memberSearchService.search(body);
  }
}
