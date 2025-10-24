import { Module } from "@nestjs/common";
import { SfdcReportsController } from "./sfdc-reports.controller";
import { SfdcReportsService } from "./sfdc-reports.service";
import { SqlLoaderService } from "../../common/sql-loader.service";

@Module({
  controllers: [SfdcReportsController],
  providers: [SfdcReportsService, SqlLoaderService],
})
export class SfdcReportsModule {}
