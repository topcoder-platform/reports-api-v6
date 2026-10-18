import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { CsvSerializer } from "../../common/csv/csv-serializer";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { ActiveMembersReportsService } from "./active-members-reports.service";
import { DashboardReportsController } from "./dashboard-reports.controller";
import { DashboardReportsService } from "./dashboard-reports.service";
import { DashboardReportsGuard } from "./guards/dashboard-reports.guard";

/**
 * Bundles dashboard report queries, authorization, JSON responses, and CSV
 * exports for the Reports Portal.
 */
@Module({
  imports: [ConfigModule],
  controllers: [DashboardReportsController],
  providers: [
    DashboardReportsService,
    ActiveMembersReportsService,
    DashboardReportsGuard,
    SqlLoaderService,
    CsvSerializer,
  ],
})
export class DashboardReportsModule {}
