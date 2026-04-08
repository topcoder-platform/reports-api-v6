import { Body, Controller, HttpCode, HttpStatus, Post, UseGuards } from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from "@nestjs/swagger";
import { MemberSearchBodyDto } from "./dto/member-search.dto";
import { MemberSearchResponseDto } from "./dto/member-search-response.dto";
import { MemberSearchService } from "./member-search.service";
import { MemberSearchGuard } from "./guards/member-search.guard";

@ApiTags("Member Search")
@ApiBearerAuth()
@UseGuards(MemberSearchGuard)
@Controller("member")
export class MemberSearchController {
  constructor(private readonly memberSearchService: MemberSearchService) {}

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
