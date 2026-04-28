import { Module } from "@nestjs/common";
import { CsvSerializer } from "../../common/csv/csv-serializer";
import { CsvResponseInterceptor } from "../../common/interceptors/csv-response.interceptor";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { SfdcReportsController } from "./sfdc-reports.controller";
import { SfdcReportsService } from "./sfdc-reports.service";

@Module({
  controllers: [SfdcReportsController],
  providers: [
    SfdcReportsService,
    SqlLoaderService,
    CsvSerializer,
    CsvResponseInterceptor,
  ],
})
export class SfdcReportsModule {}
