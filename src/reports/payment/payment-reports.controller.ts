import {
  Controller,
  Get,
  Query,
  UseGuards,
  UseInterceptors,
} from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { TopcoderReportsService } from "../topcoder/topcoder-reports.service";
import { MemberPaymentAccrualQueryDto } from "../topcoder/dto/member-payment-accrual.dto";
import { CsvResponseInterceptor } from "../../common/interceptors/csv-response.interceptor";
import { AdminPaymentReportsGuard } from "./guards/admin-payment-reports.guard";

@ApiTags("Payment Reports")
@ApiBearerAuth()
@UseGuards(AdminPaymentReportsGuard)
@UseInterceptors(CsvResponseInterceptor)
@Controller()
export class PaymentReportsController {
  constructor(private readonly reports: TopcoderReportsService) {}

  @Get("/payment/member-payment-accrual")
  @ApiOperation({
    summary:
      "Member payment accruals for the provided date range (defaults to last 3 months)",
  })
  getMemberPaymentAccrual(@Query() query: MemberPaymentAccrualQueryDto) {
    const { startDate, endDate } = query;
    return this.reports.getMemberPaymentAccrual(startDate, endDate);
  }

  @Get("/payment/member-payment-accrual-taas")
  @ApiOperation({
    summary:
      "Member payment accruals for TaaS payments for the provided date range (defaults to last 3 months)",
  })
  getMemberPaymentAccrualTaas(@Query() query: MemberPaymentAccrualQueryDto) {
    const { startDate, endDate } = query;
    return this.reports.getMemberPaymentAccrual(startDate, endDate, [
      "TaaS Payment",
    ]);
  }

  @Get("/payment/member-payment-accrual-topgear")
  @ApiOperation({
    summary:
      "Member payment accruals for Topgear payments for the provided date range (defaults to last 3 months)",
  })
  getMemberPaymentAccrualTopgear(@Query() query: MemberPaymentAccrualQueryDto) {
    const { startDate, endDate } = query;
    return this.reports.getMemberPaymentAccrual(startDate, endDate, [
      "Topgear Payment",
    ]);
  }

  @Get("/payment/member-payment-accrual-engagement")
  @ApiOperation({
    summary:
      "Member payment accruals for engagement payments for the provided date range (defaults to last 3 months)",
  })
  getMemberPaymentAccrualEngagement(
    @Query() query: MemberPaymentAccrualQueryDto,
  ) {
    const { startDate, endDate } = query;
    return this.reports.getMemberPaymentAccrual(startDate, endDate, [
      "Engagement Payment",
    ]);
  }

  @Get("/payment/member-payment-accrual-task")
  @ApiOperation({
    summary:
      "Member payment accruals for task payments for the provided date range (defaults to last 3 months)",
  })
  getMemberPaymentAccrualTask(@Query() query: MemberPaymentAccrualQueryDto) {
    const { startDate, endDate } = query;
    return this.reports.getMemberPaymentAccrual(startDate, endDate, [
      "Task Payment",
    ]);
  }

  @Get("/payment/member-payment-accrual-challenge")
  @ApiOperation({
    summary:
      "Member payment accruals for challenge payments (contest, review board, copilot, checkpoint, and related challenge payouts) for the provided date range (defaults to last 3 months)",
  })
  getMemberPaymentAccrualChallenge(
    @Query() query: MemberPaymentAccrualQueryDto,
  ) {
    const { startDate, endDate } = query;
    return this.reports.getMemberPaymentAccrual(startDate, endDate, [
      "Challenge Payment",
    ]);
  }
}
