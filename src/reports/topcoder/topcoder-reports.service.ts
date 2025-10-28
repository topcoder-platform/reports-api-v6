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

  async get90DayChallengeDuration() {
    const query = this.sql.load(
      "reports/topcoder/90-day-challenge-duration.sql",
    );
    const rows = await this.db.query<{
      "challenge.duration": string | number;
      "challenge.count": string | number;
    }>(query);

    const duration = rows?.[0]?.["challenge.duration"];
    const count = rows?.[0]?.["challenge.count"];

    return {
      "challenge.duration": Number(duration ?? 0),
      "challenge.count": Number(count ?? 0),
    };
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

  async getWeeklyChallengeFulfillment() {
    const query = this.sql.load(
      "reports/topcoder/weekly-challenge-fulfillment.sql",
    );
    const rows = await this.db.query<{
      "challenge.complete_week": string;
      "challenge.fulfillment": string | number | null;
      "challenge.count": string | number | null;
    }>(query);

    return rows.map((row) => ({
      "challenge.complete_week": row["challenge.complete_week"],
      "challenge.fulfillment": Number(row["challenge.fulfillment"] ?? 0),
      "challenge.count": Number(row["challenge.count"] ?? 0),
    }));
  }

  async getWeeklyChallengeVolume() {
    const [dataQuery, totalsQuery] = [
      this.sql.load("reports/topcoder/weekly-challenge-volume.sql"),
      this.sql.load(
        "reports/topcoder/weekly-challenge-volume-row-totals.sql",
      ),
    ];

    const [challengeRows, totalRows] = await Promise.all([
      this.db.query<{
        "challenge.task_ind": string | number | null;
        "challenge.posting_week": string;
        "challenge.count": string | number | null;
        z__pivot_col_rank: string | number | null;
        z___rank: string | number | null;
        z___min_rank: string | number | null;
        z___pivot_row_rank: string | number | null;
        z__pivot_col_ordering: string | number | null;
        z__is_highest_ranked_cell: string | number | null;
      }>(dataQuery),
      this.db.query<{
        "challenge.posting_week": string;
        "challenge.count": string | number | null;
      }>(totalsQuery),
    ]);

    return {
      rows: challengeRows.map((row) => ({
        "challenge.task_ind": Number(row["challenge.task_ind"] ?? 0),
        "challenge.posting_week": row["challenge.posting_week"],
        "challenge.count": Number(row["challenge.count"] ?? 0),
        z__pivot_col_rank: Number(row.z__pivot_col_rank ?? 0),
        z___rank: Number(row.z___rank ?? 0),
        z___min_rank: Number(row.z___min_rank ?? 0),
        z___pivot_row_rank: Number(row.z___pivot_row_rank ?? 0),
        z__pivot_col_ordering: Number(row.z__pivot_col_ordering ?? 0),
        z__is_highest_ranked_cell: Number(
          row.z__is_highest_ranked_cell ?? 0,
        ),
      })),
      totals: totalRows.map((row) => ({
        "challenge.posting_week": row["challenge.posting_week"],
        "challenge.count": Number(row["challenge.count"] ?? 0),
      })),
    };
  }

  async get90DayMembershipParticipationFunnel() {
    const query = this.sql.load(
      "reports/topcoder/90-day-membership-participation-funnel.sql",
    );
    const rows = await this.db.query<{
      "participant_funnel_monthly.member_since_date_year":
        string | number | null;
      "participant_funnel_monthly.new_signups": string | number | null;
      "participant_funnel_monthly.new_design_participants":
        string | number | null;
      "participant_funnel_monthly.new_design_submitters":
        string | number | null;
      "participant_funnel_monthly.new_dev_participants":
        string | number | null;
      "participant_funnel_monthly.new_dev_submitters":
        string | number | null;
    }>(query);

    const row = rows?.[0];

    return {
      "participant_funnel_monthly.member_since_date_year": Number(
        row?.["participant_funnel_monthly.member_since_date_year"] ?? 0,
      ),
      "participant_funnel_monthly.new_signups": Number(
        row?.["participant_funnel_monthly.new_signups"] ?? 0,
      ),
      "participant_funnel_monthly.new_design_participants": Number(
        row?.["participant_funnel_monthly.new_design_participants"] ?? 0,
      ),
      "participant_funnel_monthly.new_design_submitters": Number(
        row?.["participant_funnel_monthly.new_design_submitters"] ?? 0,
      ),
      "participant_funnel_monthly.new_dev_participants": Number(
        row?.["participant_funnel_monthly.new_dev_participants"] ?? 0,
      ),
      "participant_funnel_monthly.new_dev_submitters": Number(
        row?.["participant_funnel_monthly.new_dev_submitters"] ?? 0,
      ),
    };
  }

  async getMembershipParticipationFunnelData() {
    const query = this.sql.load(
      "reports/topcoder/membership-participation-funnel-data.sql",
    );
    const rows = await this.db.query<{
      "participant_funnel_monthly.member_since_date_week": string;
      "participant_funnel_monthly.new_signups": string | number | null;
      "participant_funnel_monthly.new_design_participants":
        string | number | null;
      "participant_funnel_monthly.new_design_submitters":
        string | number | null;
      "participant_funnel_monthly.new_dev_participants":
        string | number | null;
      "participant_funnel_monthly.new_dev_submitters":
        string | number | null;
    }>(query);

    return rows.map((row) => ({
      "participant_funnel_monthly.member_since_date_week":
        row["participant_funnel_monthly.member_since_date_week"],
      "participant_funnel_monthly.new_signups": Number(
        row["participant_funnel_monthly.new_signups"] ?? 0,
      ),
      "participant_funnel_monthly.new_design_participants": Number(
        row["participant_funnel_monthly.new_design_participants"] ?? 0,
      ),
      "participant_funnel_monthly.new_design_submitters": Number(
        row["participant_funnel_monthly.new_design_submitters"] ?? 0,
      ),
      "participant_funnel_monthly.new_dev_participants": Number(
        row["participant_funnel_monthly.new_dev_participants"] ?? 0,
      ),
      "participant_funnel_monthly.new_dev_submitters": Number(
        row["participant_funnel_monthly.new_dev_submitters"] ?? 0,
      ),
    }));
  }

  async getTotalCopilots() {
    const query = this.sql.load("reports/topcoder/total-copilots.sql");
    const rows = await this.db.query<{
      "group_membership.count": string | number;
    }>(query);
    const value = rows?.[0]?.["group_membership.count"];
    return { "group_membership.count": Number(value ?? 0) };
  }

  async getWeeklyActiveCopilots() {
    const query = this.sql.load(
      "reports/topcoder/weekly-active-copilots.sql",
    );
    const rows = await this.db.query<{
      "challenge_stats.posting_week": string;
      "challenge.track": string;
      "challenge.count": string | number;
      "copilot.count": string | number;
    }>(query);

    return rows.map((row) => ({
      "challenge_stats.posting_week": row["challenge_stats.posting_week"],
      "challenge.track": row["challenge.track"],
      "challenge.count": Number(row["challenge.count"] ?? 0),
      "copilot.count": Number(row["copilot.count"] ?? 0),
    }));
  }

  async getWeeklyMemberParticipation() {
    const query = this.sql.load(
      "reports/topcoder/weekly-member-participation.sql",
    );
    const rows = await this.db.query<{
      "challenge_stats.posting_date_week": string;
      "challenge_stats.count_distinct_registrant": string | number;
      "challenge_stats.count_distinct_submitter": string | number;
    }>(query);

    return rows.map((row) => ({
      "challenge_stats.posting_date_week":
        row["challenge_stats.posting_date_week"],
      "challenge_stats.count_distinct_registrant": Number(
        row["challenge_stats.count_distinct_registrant"] ?? 0,
      ),
      "challenge_stats.count_distinct_submitter": Number(
        row["challenge_stats.count_distinct_submitter"] ?? 0,
      ),
    }));
  }
}
