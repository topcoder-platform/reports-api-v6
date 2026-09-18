import { Module } from "@nestjs/common";
import { SalesReportsController } from "./sales-reports.controller";
import { SalesReportsGuard } from "./sales-reports.guard";
import { SalesReportsService } from "./sales-reports.service";
import { SalesforceReportsClient } from "./salesforce-reports.client";

/** Wires Salesforce reporting, shared snapshots and Sales/WIN authorization without database storage. */
@Module({
  controllers: [SalesReportsController],
  providers: [SalesReportsGuard, SalesReportsService, SalesforceReportsClient],
})
export class SalesReportsModule {}
