import { Module } from "@nestjs/common";
import { CsvSerializer } from "src/common/csv/csv-serializer";
import { CsvResponseInterceptor } from "src/common/interceptors/csv-response.interceptor";
import { SqlLoaderService } from "src/common/sql-loader.service";
import { IdentityReportsController } from "./identity-reports.controller";
import { IdentityReportsService } from "./identity-reports.service";

/**
 * Nest module that wires identity report controller, service, and CSV helpers.
 */
@Module({
  controllers: [IdentityReportsController],
  providers: [
    IdentityReportsService,
    SqlLoaderService,
    CsvSerializer,
    CsvResponseInterceptor,
  ],
})
export class IdentityReportsModule {}
