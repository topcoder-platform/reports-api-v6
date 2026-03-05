import { Injectable } from "@nestjs/common";
import { Logger } from "src/common/logger";
import { SqlLoaderService } from "src/common/sql-loader.service";
import { DbService } from "src/db/db.service";
import {
  ChallengeRegistrantsQueryDto,
  ChallengeRegistrantsResponseDto,
} from "./dtos/registrants.dto";
import { multiValueArrayFilter } from "src/common/filtering";
import { ChallengesReportResponseDto } from "./dtos/challenge.dto";
import { SubmissionLinksQueryDto } from "./dtos/submission-links.dto";
import {
  ChallengeUserRecordDto,
  ChallengeUsersPathParamDto,
} from "./dtos/challenge-users.dto";

@Injectable()
export class ChallengesReportsService {
  private readonly logger = new Logger(ChallengesReportsService.name);

  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getSubmissionLinks(filters: SubmissionLinksQueryDto) {
    this.logger.debug("Starting getSubmissionLinks", filters);
    const query = this.sql.load("reports/challenges/submission-links.sql");

    try {
      const results = await this.db.query<any>(query, [
        filters.challengeStatus,
        filters.completionDateFrom,
        filters.completionDateTo,
      ]);

      return results;
    } catch (e) {
      this.logger.error(e);
    }
  }

  async getChallengesReport(filters: ChallengeRegistrantsQueryDto) {
    this.logger.debug("Starting getChallengesReport with filters:", filters);

    const query = this.sql.load("reports/challenges/challenges-history.sql");

    const { include: billingAccountIds, exclude: excludeBillingAccountIds } =
      multiValueArrayFilter(filters.billingAccountIds);

    const payments = await this.db.query<ChallengesReportResponseDto>(query, [
      billingAccountIds.length ? billingAccountIds : undefined,
      excludeBillingAccountIds.length ? excludeBillingAccountIds : undefined,
      filters.challengeStatus,
      filters.completionDateFrom,
      filters.completionDateTo,
    ]);

    return payments;
  }

  async getRegistrantsReport(filters: ChallengeRegistrantsQueryDto) {
    this.logger.debug("Starting getRegistrantsReport with filters:", filters);

    const query = this.sql.load("reports/challenges/registrants-history.sql");

    const { include: billingAccountIds, exclude: excludeBillingAccountIds } =
      multiValueArrayFilter(filters.billingAccountIds);

    const payments = await this.db.query<ChallengeRegistrantsResponseDto>(
      query,
      [
        billingAccountIds.length ? billingAccountIds : undefined,
        excludeBillingAccountIds.length ? excludeBillingAccountIds : undefined,
        filters.challengeStatus,
        filters.completionDateFrom,
        filters.completionDateTo,
      ],
    );

    return payments;
  }

  /**
   * Retrieves all users registered for the specified challenge.
   * @param filters Path params containing challengeId.
   * @returns Registered user records with handle, email, country, and MM score when applicable.
   * @throws Does not throw. Logs query errors and returns an empty array.
   */
  async getRegisteredUsers(
    filters: ChallengeUsersPathParamDto,
  ): Promise<ChallengeUserRecordDto[]> {
    this.logger.debug("Starting getRegisteredUsers with filters:", filters);
    const query = this.sql.load("reports/challenges/registered-users.sql");

    try {
      const results = await this.db.query<ChallengeUserRecordDto>(query, [
        filters.challengeId,
      ]);

      return results;
    } catch (e) {
      this.logger.error(e);
      return [];
    }
  }

  /**
   * Retrieves users who submitted at least one submission for the specified challenge.
   * @param filters Path params containing challengeId.
   * @returns Submitter records with handle, email, country, and MM score when applicable.
   * @throws Does not throw. Logs query errors and returns an empty array.
   */
  async getSubmitters(
    filters: ChallengeUsersPathParamDto,
  ): Promise<ChallengeUserRecordDto[]> {
    this.logger.debug("Starting getSubmitters with filters:", filters);
    const query = this.sql.load("reports/challenges/submitters.sql");

    try {
      const results = await this.db.query<ChallengeUserRecordDto>(query, [
        filters.challengeId,
      ]);

      return results;
    } catch (e) {
      this.logger.error(e);
      return [];
    }
  }

  /**
   * Retrieves users with at least one passing submission for the specified challenge.
   * @param filters Path params containing challengeId.
   * @returns Valid submitter records with handle, email, country, and MM score when applicable.
   * @throws Does not throw. Logs query errors and returns an empty array.
   */
  async getValidSubmitters(
    filters: ChallengeUsersPathParamDto,
  ): Promise<ChallengeUserRecordDto[]> {
    this.logger.debug("Starting getValidSubmitters with filters:", filters);
    const query = this.sql.load("reports/challenges/valid-submitters.sql");

    try {
      const results = await this.db.query<ChallengeUserRecordDto>(query, [
        filters.challengeId,
      ]);

      return results;
    } catch (e) {
      this.logger.error(e);
      return [];
    }
  }

  /**
   * Retrieves winner records for the specified challenge.
   * @param filters Path params containing challengeId.
   * @returns Winner records with handle, email, country, and MM score when applicable.
   * @throws Does not throw. Logs query errors and returns an empty array.
   */
  async getWinners(
    filters: ChallengeUsersPathParamDto,
  ): Promise<ChallengeUserRecordDto[]> {
    this.logger.debug("Starting getWinners with filters:", filters);
    const query = this.sql.load("reports/challenges/winners.sql");

    try {
      const results = await this.db.query<ChallengeUserRecordDto>(query, [
        filters.challengeId,
      ]);

      return results;
    } catch (e) {
      this.logger.error(e);
      return [];
    }
  }
}
