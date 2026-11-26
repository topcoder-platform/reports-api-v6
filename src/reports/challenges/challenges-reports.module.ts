import { Module } from "@nestjs/common";
import { CsvSerializer } from "../../common/csv/csv-serializer";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { CsvResponseInterceptor } from "../../common/interceptors/csv-response.interceptor";
import { ChallengesReportsController } from "./challenges-reports.controller";
import { ChallengesReportsService } from "./challenges-reports.service";

@Module({
  controllers: [ChallengesReportsController],
  providers: [
    ChallengesReportsService,
    SqlLoaderService,
    CsvSerializer,
    CsvResponseInterceptor,
  ],
})
export class ChallengesReportsModule {}
