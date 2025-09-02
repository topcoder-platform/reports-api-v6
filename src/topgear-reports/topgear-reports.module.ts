import { Module } from "@nestjs/common";
import { TopgearReportsController } from "./topgear-reports.controller";
import { TopgearReportsService } from "./topgear-reports.service";
import { SqlLoaderService } from "../common/sql-loader.service";

@Module({
  controllers: [TopgearReportsController],
  providers: [TopgearReportsService, SqlLoaderService],
})
export class TopgearReportsModule {}
