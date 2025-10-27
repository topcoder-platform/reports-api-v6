import { Module } from "@nestjs/common";
import { TopcoderReportsController } from "./topcoder-reports.controller";
import { TopcoderReportsService } from "./topcoder-reports.service";
import { SqlLoaderService } from "../../common/sql-loader.service";

@Module({
  controllers: [TopcoderReportsController],
  providers: [TopcoderReportsService, SqlLoaderService],
})
export class TopcoderReportsModule {}
