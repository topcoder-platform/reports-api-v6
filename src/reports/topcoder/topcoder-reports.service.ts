import { Injectable } from "@nestjs/common";
import { DbService } from "../../db/db.service";
import { SqlLoaderService } from "../../common/sql-loader.service";

@Injectable()
export class TopcoderReportsService {
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getMemberCount() {
    const query = this.sql.load("reports/topcoder/member-count.sql");
    const rows = await this.db.query<{ "user.count": string | number }>(query);
    const value = rows?.[0]?.["user.count"];
    return { "user.count": Number(value ?? 0) };
  }

  async get90DayMemberSpend() {
    const query = this.sql.load("reports/topcoder/90-day-member-spend.sql");
    const rows = await this.db.query<{
      "user_payment.gross_amount": string | number;
    }>(query);
    const value = rows?.[0]?.["user_payment.gross_amount"];
    return { "user_payment.gross_amount": Number(value ?? 0) };
  }

  async get90DayMembersPaid() {
    const query = this.sql.load("reports/topcoder/90-day-members-paid.sql");
    const rows = await this.db.query<{ "payee.count": string | number }>(query);
    const value = rows?.[0]?.["payee.count"];
    return { "payee.count": Number(value ?? 0) };
  }

  async get90DayNewMembers() {
    const query = this.sql.load("reports/topcoder/90-day-new-members.sql");
    const rows = await this.db.query<{ "user.count": string | number }>(query);
    const value = rows?.[0]?.["user.count"];
    return { "user.count": Number(value ?? 0) };
  }

  async get90DayActiveCopilots() {
    const query = this.sql.load(
      "reports/topcoder/90-day-active-copilots.sql",
    );
    const rows = await this.db.query<{ "copilot.count": string | number }>(
      query,
    );
    const value = rows?.[0]?.["copilot.count"];
    return { "copilot.count": Number(value ?? 0) };
  }

  async get90DayUserLogin() {
    const query = this.sql.load("reports/topcoder/90-day-user-login.sql");
    const rows = await this.db.query<{ "user.count": string | number }>(query);
    const value = rows?.[0]?.["user.count"];
    return { "user.count": Number(value ?? 0) };
  }

  async get90DayChallengeVolume() {
    const query = this.sql.load("reports/topcoder/90-day-challenge-volume.sql");
    const rows = await this.db.query<{ "challenge.count": string | number }>(
      query,
    );
    const value = rows?.[0]?.["challenge.count"];
    return { "challenge.count": Number(value ?? 0) };
  }

  async get90DayChallengeRegistrants() {
    const query = this.sql.load(
      "reports/topcoder/90-day-challenge-registrants.sql",
    );
    const rows = await this.db.query<{
      "challenge_stats.count_distinct_registrant": string | number;
      "challenge_stats.count_distinct_submitter": string | number;
    }>(query);

    const distinctRegistrant =
      rows?.[0]?.["challenge_stats.count_distinct_registrant"];
    const distinctSubmitter =
      rows?.[0]?.["challenge_stats.count_distinct_submitter"];

    return {
      "challenge_stats.count_distinct_registrant": Number(
        distinctRegistrant ?? 0,
      ),
      "challenge_stats.count_distinct_submitter": Number(
        distinctSubmitter ?? 0,
      ),
    };
  }

  async get90DayChallengeSubmitters() {
    const query = this.sql.load(
      "reports/topcoder/90-day-challenge-submitters.sql",
    );
    const rows = await this.db.query<{
      "challenge_stats.count_distinct_registrant": string | number;
      "challenge_stats.count_distinct_submitter": string | number;
    }>(query);

    const distinctRegistrant =
      rows?.[0]?.["challenge_stats.count_distinct_registrant"];
    const distinctSubmitter =
      rows?.[0]?.["challenge_stats.count_distinct_submitter"];

    return {
      "challenge_stats.count_distinct_registrant": Number(
        distinctRegistrant ?? 0,
      ),
      "challenge_stats.count_distinct_submitter": Number(
        distinctSubmitter ?? 0,
      ),
    };
  }

  async get90DayChallengeMemberCost() {
    const query = this.sql.load(
      "reports/topcoder/90-day-challenge-member-cost.sql",
    );
    const rows = await this.db.query<{
      "cost_transaction.average_member_payments": string | number;
      "cost_transaction.member_payments": string | number;
      "cost_transaction.count_challenges": string | number;
    }>(query);

    const average =
      rows?.[0]?.["cost_transaction.average_member_payments"] ?? 0;
    const total = rows?.[0]?.["cost_transaction.member_payments"] ?? 0;
    const count = rows?.[0]?.["cost_transaction.count_challenges"] ?? 0;

    return {
      "cost_transaction.average_member_payments": Number(average ?? 0),
      "cost_transaction.member_payments": Number(total ?? 0),
      "cost_transaction.count_challenges": Number(count ?? 0),
    };
  }

  async get90DayTaskMemberCost() {
    const query = this.sql.load("reports/topcoder/90-day-task-member-cost.sql");
    const rows = await this.db.query<{
      "cost_transaction.average_member_payments": string | number;
      "cost_transaction.member_payments": string | number;
      "cost_transaction.count_challenges": string | number;
    }>(query);

    const average =
      rows?.[0]?.["cost_transaction.average_member_payments"] ?? 0;
    const total = rows?.[0]?.["cost_transaction.member_payments"] ?? 0;
    const count = rows?.[0]?.["cost_transaction.count_challenges"] ?? 0;

    return {
      "cost_transaction.average_member_payments": Number(average ?? 0),
      "cost_transaction.member_payments": Number(total ?? 0),
      "cost_transaction.count_challenges": Number(count ?? 0),
    };
  }

  async get90DayFulfillment() {
    const query = this.sql.load("reports/topcoder/90-day-fulfillment.sql");
    const rows = await this.db.query<{
      "challenge.fulfillment": string | number;
    }>(query);
    const value = rows?.[0]?.["challenge.fulfillment"];
    return { "challenge.fulfillment": Number(value ?? 0) };
  }

  async get90DayFulfillmentWithTasks() {
    const query = this.sql.load(
      "reports/topcoder/90-day-fulfillment-with-tasks.sql",
    );
    const rows = await this.db.query<{
      "challenge.fulfillment": string | number;
    }>(query);
    const value = rows?.[0]?.["challenge.fulfillment"];
    return { "challenge.fulfillment": Number(value ?? 0) };
  }

  async getTotalCopilots() {
    const query = this.sql.load("reports/topcoder/total-copilots.sql");
    const rows = await this.db.query<{
      "group_membership.count": string | number;
    }>(query);
    const value = rows?.[0]?.["group_membership.count"];
    return { "group_membership.count": Number(value ?? 0) };
  }
}
