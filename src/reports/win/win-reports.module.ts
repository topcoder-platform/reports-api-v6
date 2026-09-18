import { Module } from "@nestjs/common";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { WinReportsController } from "./win-reports.controller";
import { WinReportsService } from "./win-reports.service";

/** Registers the WIN endpoint and its SQL-backed report reader. */
@Module({
  controllers: [WinReportsController],
  providers: [WinReportsService, SqlLoaderService],
})
export class WinReportsModule {}
