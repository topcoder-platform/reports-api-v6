import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { SalesReportsModule } from "../sales/sales-reports.module";
import { SalesDashboardController } from "./sales-dashboard.controller";
import { SalesDashboardService } from "./sales-dashboard.service";
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
  imports: [ConfigModule, SalesReportsModule],
  controllers: [DashboardReportsController, SalesDashboardController],
  providers: [
    DashboardReportsService,
    SalesDashboardService,
    ActiveMembersReportsService,
    DashboardReportsGuard,
    SqlLoaderService,
    CsvSerializer,
  ],
})
export class DashboardReportsModule {}
