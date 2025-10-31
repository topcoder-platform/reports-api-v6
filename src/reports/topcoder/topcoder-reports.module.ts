import { Module } from "@nestjs/common";
import { TopcoderReportsService } from "./topcoder-reports.service";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { TopcoderReportsController } from "./topcoder-reports.controller";
import { TopcoderReportsGuard } from "../../auth/guards/topcoder-reports.guard";

@Module({
  controllers: [TopcoderReportsController],
  providers: [TopcoderReportsService, SqlLoaderService, TopcoderReportsGuard],
})
export class TopcoderReportsModule {}
