import { Module } from "@nestjs/common";
import { CsvSerializer } from "../../common/csv/csv-serializer";
import { CsvResponseInterceptor } from "../../common/interceptors/csv-response.interceptor";
import { TopcoderReportsModule } from "../topcoder/topcoder-reports.module";
import { PaymentReportsController } from "./payment-reports.controller";
import { AdminPaymentReportsGuard } from "./guards/admin-payment-reports.guard";

@Module({
  imports: [TopcoderReportsModule],
  controllers: [PaymentReportsController],
  providers: [AdminPaymentReportsGuard, CsvSerializer, CsvResponseInterceptor],
})
export class PaymentReportsModule {}
