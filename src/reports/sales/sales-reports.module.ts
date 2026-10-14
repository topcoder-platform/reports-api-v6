import { Module } from "@nestjs/common";
import { SalesReportsController } from "./sales-reports.controller";
import { SalesReportsGuard } from "./sales-reports.guard";
import { SalesReportsService } from "./sales-reports.service";
import { SalesforceReportsClient } from "./salesforce-reports.client";
import { SalesProgressionController } from "./sales-progression.controller";
import { SalesProgressionService } from "./sales-progression.service";

/** Wires Salesforce reporting, shared snapshots and Sales/WIN authorization without database storage. */
@Module({
  controllers: [SalesReportsController, SalesProgressionController],
  providers: [
    SalesReportsGuard,
    SalesReportsService,
    SalesforceReportsClient,
    SalesProgressionService,
  ],
})
export class SalesReportsModule {}
