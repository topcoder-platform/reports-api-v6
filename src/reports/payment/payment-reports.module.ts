import { Module } from "@nestjs/common";
import { CsvSerializer } from "../../common/csv/csv-serializer";
import { CsvResponseInterceptor } from "../../common/interceptors/csv-response.interceptor";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { PaymentReportsController } from "./payment-reports.controller";
import { AdminPaymentReportsGuard } from "./guards/admin-payment-reports.guard";
import { PaymentReportsService } from "./payment-reports.service";

@Module({
  controllers: [PaymentReportsController],
  providers: [
    PaymentReportsService,
    SqlLoaderService,
    AdminPaymentReportsGuard,
    CsvSerializer,
    CsvResponseInterceptor,
  ],
})
export class PaymentReportsModule {}
