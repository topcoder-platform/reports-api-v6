import { BadRequestException, Injectable } from "@nestjs/common";
import { DbService } from "../../db/db.service";
import { Logger } from "src/common/logger";
import {
  BaFeesReportQueryDto,
  BaFeesReportResponse,
  ChallengesFilterMode,
  ChallengesReportQueryDto,
  ChallengesReportResponse,
  PaymentsReportQueryDto,
  PaymentsReportResponse,
  TaasJobsReportQueryDto,
  TaasJobsReportResponse,
  TaasMemberVerificationReportQueryDto,
  TaasMemberVerificationReportResponse,
  TaasResourceBookingsReportQueryDto,
  TaasResourceBookingsReportResponse,
  WesternUnionPaymentsReportQueryDto,
  WesternUnionPaymentsReportResponse,
} from "./sfdc-reports.dto";
import { SqlLoaderService } from "src/common/sql-loader.service";
import { multiValueArrayFilter } from "src/common/filtering";
import { normalizeChallengeStatus } from "./status-normalizer";

@Injectable()
export class SfdcReportsService {
  private readonly logger = new Logger(SfdcReportsService.name);

  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getChallengesReport(filters: ChallengesReportQueryDto) {
    this.logger.debug("Starting getChallengesReport with filters:", filters);

    const query = this.sql.load("reports/sfdc/challenges.sql");

    const resolvedFilterMode =
      filters.filterMode ??
      (filters.challengeIds?.length
        ? ChallengesFilterMode.CHALLENGE
        : ChallengesFilterMode.BILLING_ACCOUNT);

    const { include: billingAccountIds, exclude: excludeBillingAccountIds } =
      multiValueArrayFilter(filters.billingAccountIds);

    if (
      resolvedFilterMode === ChallengesFilterMode.CHALLENGE &&
      (billingAccountIds.length || excludeBillingAccountIds.length)
    ) {
      throw new BadRequestException(
        "billingAccountIds cannot be supplied when filterMode is 'challenge'.",
      );
    }

    if (
      resolvedFilterMode === ChallengesFilterMode.CHALLENGE &&
      !filters.challengeIds?.length
    ) {
      throw new BadRequestException(
        "challengeIds must be provided when filterMode is 'challenge'.",
      );
    }

    if (
      resolvedFilterMode === ChallengesFilterMode.BILLING_ACCOUNT &&
      filters.challengeIds?.length &&
      filters.filterMode === ChallengesFilterMode.BILLING_ACCOUNT
    ) {
      throw new BadRequestException(
        "challengeIds are only supported when filterMode is set to 'challenge'.",
      );
    }

    const challenges = await this.db.query<ChallengesReportResponse>(query, [
      resolvedFilterMode === ChallengesFilterMode.BILLING_ACCOUNT &&
      billingAccountIds.length
        ? billingAccountIds
        : undefined,
      resolvedFilterMode === ChallengesFilterMode.BILLING_ACCOUNT &&
      excludeBillingAccountIds.length
        ? excludeBillingAccountIds
        : undefined,
      resolvedFilterMode === ChallengesFilterMode.CHALLENGE
        ? filters.challengeIds
        : undefined,
      filters.challengeName,
      filters.challengeStatus,
      filters.startDate,
      filters.endDate,
      filters.isTask,
      filters.handles,
      filters.minAmount,
      filters.maxAmount,
    ]);

    this.logger.debug("Mapped challenges to the final report format");

    return challenges.map((challenge) => ({
      ...challenge,
      challengeStatus: normalizeChallengeStatus(challenge.challengeStatus),
    }));
  }

  async getPaymentsReport(filters: PaymentsReportQueryDto) {
    this.logger.debug("Starting getPaymentsReport with filters:", filters);

    const query = this.sql.load("reports/sfdc/payments.sql");

    const { include: billingAccountIds, exclude: excludeBillingAccountIds } =
      multiValueArrayFilter(filters.billingAccountIds);

    const payments = await this.db.query<PaymentsReportResponse>(query, [
      billingAccountIds.length ? billingAccountIds : undefined,
      excludeBillingAccountIds.length ? excludeBillingAccountIds : undefined,
      filters.challengeIds,
      filters.handles,
      filters.challengeName,
      filters.startDate,
      filters.endDate,
      filters.minPaymentAmount,
      filters.maxPaymentAmount,
      filters.challengeStatus,
      filters.status,
    ]);

    this.logger.debug("Mapped payments to the final report format");

    return payments.map((payment) => ({
      ...payment,
      challengeStatus: normalizeChallengeStatus(payment.challengeStatus),
    }));
  }

  async getTaasJobsReport(filters: TaasJobsReportQueryDto) {
    this.logger.debug("Starting getTaasJobsReport with filters:", filters);

    const query = this.sql.load("reports/sfdc/taas-jobs.sql");

    const report = await this.db.query<TaasJobsReportResponse>(query, [
      filters.jobIds,
      filters.projectIds,
      filters.status,
      filters.resourceType,
      filters.skills,
      filters.startDate,
      filters.endDate,
      filters.minPositions,
      filters.maxPositions,
    ]);

    this.logger.debug("Mapped TaaS jobs to the final report format");

    return report;
  }

  async getTaasResourceBookingsReport(
    filters: TaasResourceBookingsReportQueryDto,
  ) {
    this.logger.debug(
      "Starting getTaasResourceBookingsReport with filters:",
      filters,
    );

    const query = this.sql.load("reports/sfdc/taas-resource-bookings.sql");
    const handles = filters.handles?.map((handle) => handle.toLowerCase());

    const report = await this.db.query<TaasResourceBookingsReportResponse>(
      query,
      [
        filters.resourceBookingIds,
        filters.jobIds,
        filters.projectIds,
        filters.userIds,
        handles,
        filters.status,
        filters.billingAccountIds,
        filters.startDate,
        filters.endDate,
        filters.minCustomerRate,
        filters.maxCustomerRate,
      ],
    );

    this.logger.debug(
      "Mapped TaaS resource bookings to the final report format",
    );

    return report;
  }

  async getTaasMemberVerificationReport(
    filters: TaasMemberVerificationReportQueryDto,
  ) {
    this.logger.debug(
      "Starting getTaasMemberVerificationReport with filters:",
      filters,
    );

    const query = this.sql.load("reports/sfdc/taas-member-verification.sql");
    const handleLower = filters.handles.map((handle) => handle.toLowerCase());

    const report = await this.db.query<TaasMemberVerificationReportResponse>(
      query,
      [handleLower],
    );

    this.logger.debug(
      "Mapped TaaS member verification to the final report format",
    );

    return report;
  }

  async getWesternUnionPaymentsReport(
    filters: WesternUnionPaymentsReportQueryDto,
  ) {
    this.logger.debug(
      "Starting getWesternUnionPaymentsReport with filters:",
      filters,
    );

    const query = this.sql.load("reports/sfdc/western-union-payments.sql");
    const paymentStatus =
      filters.paymentStatus ?? "Entered into payment system";
    const paymentMethod = filters.paymentMethod ?? "Western Union";
    const handles = filters.handles?.map((handle) => handle.toLowerCase());

    const report = await this.db.query<WesternUnionPaymentsReportResponse>(
      query,
      [
        paymentStatus,
        paymentMethod,
        filters.startDate,
        filters.endDate,
        handles,
      ],
    );

    this.logger.debug(
      "Mapped Western Union payments to the final report format",
    );

    return report;
  }

  async getBaFeesReport(filters: BaFeesReportQueryDto) {
    this.logger.debug("Starting getBaFeesReport with filters:", filters);

    const { include: billingAccountIds, exclude: excludeBillingAccountIds } =
      multiValueArrayFilter(filters.billingAccountIds);

    const query = this.sql.load(
      filters.groupBy === "month"
        ? "reports/sfdc/ba-fees-monthly.sql"
        : "reports/sfdc/ba-fees.sql",
    );

    this.logger.debug(
      "Resolved BA fee filters",
      billingAccountIds,
      excludeBillingAccountIds,
      filters.groupBy,
    );

    const report = await this.db.query<BaFeesReportResponse>(query, [
      filters.startDate ?? null,
      filters.endDate ?? null,
      billingAccountIds.length ? billingAccountIds : null,
      excludeBillingAccountIds.length ? excludeBillingAccountIds : null,
    ]);

    this.logger.debug("Mapped BA fees to the final report format");

    return report;
  }
}
