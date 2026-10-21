import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { SalesReportsController } from "./sales-reports.controller";
import { SalesReportsGuard } from "./sales-reports.guard";
import { SalesReportsService } from "./sales-reports.service";
import { SalesforceReportsClient } from "./salesforce-reports.client";
import { SalesProgressionController } from "./sales-progression.controller";
import { SalesProgressionService } from "./sales-progression.service";

/** Wires Salesforce reporting, shared snapshots and Sales/WIN authorization without database storage. */
@Module({
  imports: [ConfigModule],
  controllers: [SalesReportsController, SalesProgressionController],
  exports: [SalesReportsService],
  providers: [
    SalesReportsGuard,
    SalesReportsService,
    SalesforceReportsClient,
    SalesProgressionService,
  ],
})
export class SalesReportsModule {}
