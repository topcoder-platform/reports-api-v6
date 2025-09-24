import { Injectable } from "@nestjs/common";
import { Logger } from "src/common/logger";
import { SqlLoaderService } from "src/common/sql-loader.service";
import { DbService } from "src/db/db.service";
import {
  ChallengeRegistrantsQueryDto,
  ChallengeRegistrantsResponseDto,
} from "./dtos/registrants.dto";
import { multiValueArrayFilter } from "src/common/filtering";

@Injectable()
export class ChallengesReportsService {
  private readonly logger = new Logger(ChallengesReportsService.name);

  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

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

    // console.log("here1", payments);
    return payments;
  }
}
