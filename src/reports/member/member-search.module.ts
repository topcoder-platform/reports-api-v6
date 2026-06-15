import { Module } from "@nestjs/common";
import { CsvSerializer } from "src/common/csv/csv-serializer";
import { CsvResponseInterceptor } from "src/common/interceptors/csv-response.interceptor";
import { MemberSearchController } from "./member-search.controller";
import { MemberSearchService } from "./member-search.service";
import { MemberSearchGuard } from "./guards/member-search.guard";
import { MemberTalentReportGuard } from "./guards/member-talent-report.guard";

@Module({
  controllers: [MemberSearchController],
  providers: [
    MemberSearchService,
    MemberSearchGuard,
    MemberTalentReportGuard,
    CsvSerializer,
    CsvResponseInterceptor,
  ],
})
export class MemberSearchModule {}
