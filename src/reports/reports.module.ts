import { Module } from "@nestjs/common";
import { ReportsController } from "./reports.controller";
import { ReportsService } from "./reports.service";
import { SqlLoaderService } from "../common/sql-loader.service";

@Module({
  controllers: [ReportsController],
  providers: [ReportsService, SqlLoaderService],
})
export class ReportsModule {}
