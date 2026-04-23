import { Module } from "@nestjs/common";
import { TopcoderReportsService } from "./topcoder-reports.service";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { TopcoderReportsController } from "./topcoder-reports.controller";
import { TopcoderReportsGuard } from "../../auth/guards/topcoder-reports.guard";
import { CsvSerializer } from "../../common/csv/csv-serializer";
import { CsvResponseInterceptor } from "../../common/interceptors/csv-response.interceptor";

@Module({
  controllers: [TopcoderReportsController],
  providers: [
    TopcoderReportsService,
    SqlLoaderService,
    TopcoderReportsGuard,
    CsvSerializer,
    CsvResponseInterceptor,
  ],
})
export class TopcoderReportsModule {}
