import {
  Injectable,
  Logger,
  NotFoundException,
  OnModuleDestroy,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { DbService } from "../../db/db.service";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { alpha3ToCountryName } from "../../common/country.util";
import { Pool } from "pg";
import * as core from "tc-core-library-js";

type RegistrantCountriesRow = {
  handle: string | null;
  email: string | null;
  home_country: string | null;
  competition_country: string | null;
};

type MarathonMatchStatsRow = {
  handle: string;
  first_name: string | null;
  last_name: string | null;
  competition_country: string | null;
  member_since: Date | string | null;
  marathon_match_rating: string | number | null;
  marathon_match_rank: string | number | null;
  highest_track_rating: string | number | null;
  marathon_matches_registered: string | number | null;
  marathon_match_wins: string | number | null;
  marathon_match_top_five_finishes: string | number | null;
  average_marathon_match_placement: string | number | null;
  marathon_submission_rate: string | number | null;
};

type MemberPaymentAccrualRow = {
  payment_created_at: Date | string | null;
  payment_id: string | null;
  payment_description: string | null;
  challenge_id: string | null;
  payment_status: string | null;
  payment_type: string | null;
  payee_handle: string | null;
  payment_method: string | null;
  billing_account_name: string | null;
  customer_name: string | null;
  reporting_account_name: string | null;
  member_id: string | null;
  challenge_created_date: string | null;
  user_payment_gross_amount: string | number | null;
};

type RecentMemberDataRow = {
  handle: string | null;
  email: string | null;
  country_code: string | null;
  role: string | null;
  skills:
    | {
        name: string | null;
        status: string | null;
      }[]
    | null;
  ratings: {
    rating?: string | number | null;
    track?: string | null;
    subTrack?: string | null;
    ratingColor?: string | null;
  } | null;
  member_since: Date | string | null;
  open_to_work: boolean | null;
  work_history:
    | {
        industry?: string | null;
        companyName?: string | null;
        position?: string | null;
        startDate?: Date | string | null;
        endDate?: Date | string | null;
        working?: boolean | null;
      }[]
    | null;
  education:
    | {
        collegeName?: string | null;
        degree?: string | null;
        endYear?: string | number | null;
      }[]
    | null;
  trolley_id_verified: boolean | null;
  challenge_wins: string | number | null;
  task_wins: string | number | null;
  registration_count: string | number | null;
  submissions_over_75: string | number | null;
};

type CompletedProfileRow = {
  userId: string | number | null;
  handle: string | null;
  firstName: string | null;
  lastName: string | null;
  photoURL: string | null;
  countryCode: string | null;
  countryName: string | null;
  city: string | null;
  skillCount: string | number | null;
  principalSkills: string[] | null;
  isOpenToWork?: boolean | null;
  openToWork?: { availability?: string; preferredRoles?: string[] } | null;
};

type CompletedProfilesCountRow = {
  total: string | number | null;
};

type ChallengeSubmitterDataRow = {
  userId: string | number | null;
  handle: string | null;
  email: string | null;
  country: string | null;
  place: string | number | null;
  provisionalScores: unknown;
  finalScore: string | number | null;
};

type EngagementDataBaseRow = {
  member_id: string | null;
  fallback_handle: string | null;
  application_email: string | null;
  application_address: string | null;
  application_phone: string | null;
  application_name: string | null;
  has_assignment: boolean | null;
  assigned_project_ids: string[] | null;
};

type MemberProfileAddress = {
  streetAddr1?: string | null;
  streetAddr2?: string | null;
  city?: string | null;
  stateCode?: string | null;
  zip?: string | null;
};

type MemberProfilePhone = {
  number?: string | null;
  type?: string | null;
};

type MemberProfile = {
  userId?: string | number | null;
  handle?: string | null;
  firstName?: string | null;
  lastName?: string | null;
  email?: string | null;
  homeCountryCode?: string | null;
  country?: string | null;
  addresses?: MemberProfileAddress[] | null;
  phones?: MemberProfilePhone[] | null;
};

type ProjectSummary = {
  id?: string | number | null;
  name?: string | null;
};

type ParsedName = {
  firstName: string | null;
  lastName: string | null;
};

@Injectable()
export class TopcoderReportsService implements OnModuleDestroy {
  private readonly logger = new Logger(TopcoderReportsService.name);
  private readonly m2m: {
    getMachineToken: (
      clientId: string,
      clientSecret: string,
    ) => Promise<string>;
  };
  private engagementsPool?: Pool;
  private readonly memberLookupBatchSize = 50;
  private readonly projectLookupBatchSize = 10;

  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
    private readonly config: ConfigService,
  ) {
    const authUrl = this.config.get<string>(
      "AUTH0_URL",
      "https://topcoder-dev.auth0.com/oauth/token",
    );
    const audience = this.config.get<string>(
      "AUTH0_AUDIENCE",
      "https://api.topcoder-dev.com",
    );

    this.m2m = core.auth.m2m({
      AUTH0_AUDIENCE: audience,
      AUTH0_URL: authUrl,
    }) as {
      getMachineToken: (
        clientId: string,
        clientSecret: string,
      ) => Promise<string>;
    };
  }

  async onModuleDestroy() {
    await this.engagementsPool?.end();
  }

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
    const query = this.sql.load("reports/topcoder/90-day-active-copilots.sql");
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
      this.sql.load("reports/topcoder/weekly-challenge-volume-row-totals.sql"),
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
        z__is_highest_ranked_cell: Number(row.z__is_highest_ranked_cell ?? 0),
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
        | string
        | number
        | null;
      "participant_funnel_monthly.new_signups": string | number | null;
      "participant_funnel_monthly.new_design_participants":
        | string
        | number
        | null;
      "participant_funnel_monthly.new_design_submitters":
        | string
        | number
        | null;
      "participant_funnel_monthly.new_dev_participants": string | number | null;
      "participant_funnel_monthly.new_dev_submitters": string | number | null;
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
        | string
        | number
        | null;
      "participant_funnel_monthly.new_design_submitters":
        | string
        | number
        | null;
      "participant_funnel_monthly.new_dev_participants": string | number | null;
      "participant_funnel_monthly.new_dev_submitters": string | number | null;
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
    const query = this.sql.load("reports/topcoder/weekly-active-copilots.sql");
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

  async getWeeklyMemberParticipation(startDate?: string, endDate?: string) {
    const query = this.sql.load(
      "reports/topcoder/weekly-member-participation.sql",
    );
    const rows = await this.db.query<{
      "challenge_stats.posting_date_week": string;
      "challenge_stats.count_distinct_registrant": string | number;
      "challenge_stats.count_distinct_submitter": string | number;
    }>(query, [startDate ?? null, endDate ?? null]);

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

  async getMemberPaymentAccrual(startDate?: string, endDate?: string) {
    const query = this.sql.load("reports/topcoder/member-payment-accrual.sql");
    const rows = await this.db.query<MemberPaymentAccrualRow>(query, [
      startDate ?? null,
      endDate ?? null,
    ]);
    return rows.map((row) => ({
      paymentCreatedAt: this.normalizeDate(row.payment_created_at),
      paymentId: row.payment_id ?? null,
      paymentDescription: row.payment_description ?? null,
      challengeId: row.challenge_id ?? null,
      paymentStatus: row.payment_status ?? null,
      paymentType: row.payment_type ?? null,
      payeeHandle: row.payee_handle ?? null,
      payeePaymentMethod: row.payment_method ?? null,
      billingAccountName: row.billing_account_name ?? null,
      customerName: row.customer_name ?? null,
      reportingAccountName: row.reporting_account_name ?? null,
      memberId: row.member_id ?? null,
      challengeCreatedAt: row.challenge_created_date ?? null,
      userPaymentGrossAmount: this.toNullableNumber(
        row.user_payment_gross_amount,
      ),
    }));
  }

  async getRecentMemberData(startDate?: string) {
    const query = this.sql.load("reports/topcoder/recent-member-data.sql");
    const rows = await this.db.query<RecentMemberDataRow>(query, [
      startDate ?? null,
    ]);

    return rows.map((row) => {
      const skills = Array.isArray(row.skills)
        ? row.skills.map((skill) => ({
            name: skill?.name ?? null,
            status: skill?.status ?? null,
          }))
        : [];

      const ratings = row.ratings
        ? {
            rating: this.toNullableNumber(row.ratings.rating),
            track: row.ratings.track ?? null,
            subTrack: row.ratings.subTrack ?? null,
            ratingColor: row.ratings.ratingColor ?? null,
          }
        : null;

      const workHistory = Array.isArray(row.work_history)
        ? row.work_history.map((item) => ({
            industry: item?.industry ?? null,
            companyName: item?.companyName ?? null,
            position: item?.position ?? null,
            startDate: this.normalizeDate(item?.startDate ?? null),
            endDate: this.normalizeDate(item?.endDate ?? null),
            working: item?.working ?? null,
          }))
        : [];

      const education = Array.isArray(row.education)
        ? row.education.map((item) => ({
            collegeName: item?.collegeName ?? null,
            degree: item?.degree ?? null,
            endYear: this.toNullableNumber(item?.endYear ?? null),
          }))
        : [];

      return {
        handle: row.handle ?? null,
        email: row.email ?? null,
        country: alpha3ToCountryName(row.country_code),
        role: row.role ?? null,
        skills,
        ratings,
        memberSince: this.normalizeDate(row.member_since),
        openToWork: row.open_to_work ?? null,
        workHistory,
        education,
        trolleyIdVerified: row.trolley_id_verified ?? false,
        challengeWins: Number(row.challenge_wins ?? 0),
        taskWins: Number(row.task_wins ?? 0),
        registrationCount: Number(row.registration_count ?? 0),
        submissionsOver75: Number(row.submissions_over_75 ?? 0),
      };
    });
  }

  /**
   * Returns the engagement data member report requested by PM-4800.
   *
   * The base member list comes from the engagements database, then member
   * profiles and project names are resolved through existing platform APIs so
   * the export includes handle, contact details, country, experience state, and
   * comma-separated project names for assigned members.
   *
   * @returns One row per member with the engagement experience summary fields.
   * @throws Error when required engagement or M2M configuration is missing.
   */
  async getEngagementData() {
    const rows = await this.queryEngagementDataRows();

    if (!rows.length) {
      return [];
    }

    const memberIds = Array.from(
      new Set(
        rows
          .map((row) => row.member_id?.trim())
          .filter((value): value is string => Boolean(value)),
      ),
    );
    const projectIds = Array.from(
      new Set(
        rows.flatMap((row) =>
          (row.assigned_project_ids ?? [])
            .map((value) => value?.trim())
            .filter((value): value is string => Boolean(value)),
        ),
      ),
    );

    const token = await this.getM2MToken();
    const [profilesById, projectNamesById] = await Promise.all([
      this.fetchMemberProfilesByUserIds(memberIds, token),
      this.fetchProjectNamesByIds(projectIds, token),
    ]);

    return rows.map((row) => {
      const memberId = row.member_id?.trim() ?? "";
      const member = profilesById.get(memberId);
      const parsedName = this.parseName(row.application_name);
      const handle =
        this.toOptionalString(member?.handle) ?? row.fallback_handle;
      const projectNames = Array.from(
        new Set(
          (row.assigned_project_ids ?? [])
            .map((projectId) =>
              projectNamesById.get(projectId?.trim() ?? "")?.trim(),
            )
            .filter((value): value is string => Boolean(value)),
        ),
      ).sort((left, right) => left.localeCompare(right));

      return {
        handle: handle ?? null,
        firstName:
          this.toOptionalString(member?.firstName) ?? parsedName.firstName,
        lastName:
          this.toOptionalString(member?.lastName) ?? parsedName.lastName,
        country: this.resolveMemberCountry(member),
        emailId:
          this.toOptionalString(member?.email) ?? row.application_email ?? null,
        phoneNumber:
          this.getPreferredPhoneNumber(member?.phones) ??
          row.application_phone ??
          null,
        address:
          this.formatAddress(member?.addresses) ??
          row.application_address ??
          null,
        engagementExperience: row.has_assignment ? "Assigned" : "Applicant",
        projectNames: projectNames.join(", "),
      };
    });
  }

  async getRegistrantCountries(challengeId: string) {
    const query = this.sql.load("reports/topcoder/registrant-countries.sql");
    const rows = await this.db.query<RegistrantCountriesRow>(query, [
      challengeId,
    ]);
    return rows.map((row) => ({
      handle: row.handle ?? null,
      email: row.email ?? null,
      homeCountry: row.home_country ?? null,
      competitionCountry: row.competition_country ?? null,
    }));
  }

  async getChallengeSubmitterData(challengeId: string) {
    const query = this.sql.load(
      "reports/topcoder/challenge-submitter-data.sql",
    );
    const rows = await this.db.query<ChallengeSubmitterDataRow>(query, [
      challengeId,
    ]);

    return rows.map((row) => ({
      userId: this.toNullableNumber(row.userId),
      handle: row.handle ?? null,
      email: row.email ?? null,
      country: row.country ?? null,
      place: this.toNullableNumber(row.place),
      provisionalScores: this.toNullableNumberArray(row.provisionalScores),
      finalScore: this.toNullableNumber(row.finalScore),
    }));
  }

  async getMarathonMatchStats(handle: string) {
    const query = this.sql.load("reports/topcoder/mm-stats.sql");
    const rows = await this.db.query<MarathonMatchStatsRow>(query, [handle]);
    const row = rows?.[0];

    if (!row) {
      throw new NotFoundException(
        `No member marathon stats found for handle: ${handle}`,
      );
    }

    return {
      handle: row.handle,
      firstName: row.first_name ?? null,
      lastName: row.last_name ?? null,
      competitionCountry: row.competition_country ?? null,
      memberSince: this.normalizeDate(row.member_since),
      marathonMatchRating: this.toNullableNumber(row.marathon_match_rating),
      marathonMatchRank: this.toNullableNumber(row.marathon_match_rank),
      highestTrackRating: this.toNullableNumber(row.highest_track_rating),
      marathonMatchesRegistered: this.toNullableNumber(
        row.marathon_matches_registered,
      ),
      marathonMatchWins: this.toNullableNumber(row.marathon_match_wins),
      marathonMatchTopFiveFinishes: this.toNullableNumber(
        row.marathon_match_top_five_finishes,
      ),
      averageMarathonMatchPlacement: this.toNullableNumber(
        row.average_marathon_match_placement,
      ),
      marathonSubmissionRate: this.toNullableNumber(
        row.marathon_submission_rate,
      ),
    };
  }

  async getCompletedProfiles(
    countryCode?: string,
    page = 1,
    perPage = 50,
    openToWork?: boolean,
  ) {
    const safePage = Number.isFinite(page) ? Math.max(Math.floor(page), 1) : 1;
    const safePerPage = Number.isFinite(perPage)
      ? Math.min(Math.max(Math.floor(perPage), 1), 200)
      : 50;
    const offset = (safePage - 1) * safePerPage;

    const countQuery = this.sql.load(
      "reports/topcoder/completed-profiles-count.sql",
    );
    const countRows = await this.db.query<CompletedProfilesCountRow>(
      countQuery,
      [
        countryCode || null,
        typeof openToWork === "boolean" ? openToWork : null,
      ],
    );
    const total = Number(countRows?.[0]?.total ?? 0);

    const query = this.sql.load("reports/topcoder/completed-profiles.sql");
    const rows = await this.db.query<CompletedProfileRow>(query, [
      countryCode || null,
      typeof openToWork === "boolean" ? openToWork : null,
      safePerPage,
      offset,
    ]);

    const data = rows.map((row) => ({
      userId: row.userId ? Number(row.userId) : null,
      handle: row.handle || "",
      firstName: row.firstName || undefined,
      lastName: row.lastName || undefined,
      photoURL: row.photoURL || undefined,
      countryCode: row.countryCode || undefined,
      countryName: row.countryName || undefined,
      city: row.city || undefined,
      skillCount:
        row.skillCount !== null && row.skillCount !== undefined
          ? Number(row.skillCount)
          : undefined,
      principalSkills: row.principalSkills || undefined,
      openToWork: row.openToWork ?? null,
      isOpenToWork:
        typeof row.isOpenToWork === "boolean" ? row.isOpenToWork : false,
    }));

    return {
      data,
      page: safePage,
      perPage: safePerPage,
      total,
      totalPages: total > 0 ? Math.ceil(total / safePerPage) : 1,
    };
  }

  /**
   * Loads the raw engagement report rows from the engagements database.
   *
   * @returns Aggregated rows keyed by member id with applicant fallbacks and
   * assigned project ids.
   * @throws Error when the engagements database URL is not configured.
   */
  private async queryEngagementDataRows(): Promise<EngagementDataBaseRow[]> {
    const query = this.sql.load("reports/topcoder/engagement-data.sql");
    const result =
      await this.getEngagementsPool().query<EngagementDataBaseRow>(query);

    return result.rows;
  }

  /**
   * Returns a cached pg pool for the engagements database.
   *
   * @returns Shared pool targeting the engagements database.
   * @throws Error when ENGAGEMENTS_DB_URL is missing.
   */
  private getEngagementsPool(): Pool {
    if (this.engagementsPool) {
      return this.engagementsPool;
    }

    const connectionString = this.config.get<string>("ENGAGEMENTS_DB_URL", "");
    if (!connectionString) {
      throw new Error(
        "ENGAGEMENTS_DB_URL must be configured to generate the engagement data report.",
      );
    }

    this.engagementsPool = new Pool({ connectionString });
    return this.engagementsPool;
  }

  /**
   * Fetches member profiles in batches so report rows can be enriched with
   * profile fields like names, email, country, addresses, and phones.
   *
   * @param userIds Report member ids from the engagements database.
   * @param token Auth token for the member API.
   * @returns Map of user id to member profile payload.
   */
  private async fetchMemberProfilesByUserIds(
    userIds: string[],
    token: string,
  ): Promise<Map<string, MemberProfile>> {
    const normalizedUserIds = Array.from(
      new Set(
        userIds
          .map((userId) => userId?.trim())
          .filter((userId): userId is string => Boolean(userId)),
      ),
    );

    const profilesById = new Map<string, MemberProfile>();

    for (
      let startIndex = 0;
      startIndex < normalizedUserIds.length;
      startIndex += this.memberLookupBatchSize
    ) {
      const batch = normalizedUserIds.slice(
        startIndex,
        startIndex + this.memberLookupBatchSize,
      );
      const params = new URLSearchParams();
      const baseUrl = this.getMemberApiBaseUrl();

      if (batch.length === 1) {
        params.set("userId", batch[0]);
      } else {
        batch.forEach((userId) => params.append("userIds", userId));
        params.set("perPage", String(batch.length));
      }

      params.set(
        "fields",
        [
          "userId",
          "handle",
          "firstName",
          "lastName",
          "email",
          "country",
          "homeCountryCode",
          "addresses",
          "phones",
        ].join(","),
      );

      const response = await this.fetchJson<MemberProfile[]>(
        `${baseUrl}?${params.toString()}`,
        token,
      );
      const members = Array.isArray(response) ? response : [];

      members.forEach((member) => {
        const userId = member?.userId;
        if (userId === undefined || userId === null) {
          return;
        }

        profilesById.set(String(userId), member);
      });
    }

    return profilesById;
  }

  /**
   * Resolves project names for the assigned project ids included in the report.
   *
   * Missing or inaccessible projects are skipped so the report can still render
   * the rest of the member data.
   *
   * @param projectIds Project ids collected from engagement assignments.
   * @param token Auth token for the projects API.
   * @returns Map of project id to project name.
   */
  private async fetchProjectNamesByIds(
    projectIds: string[],
    token: string,
  ): Promise<Map<string, string>> {
    const normalizedProjectIds = Array.from(
      new Set(
        projectIds
          .map((projectId) => projectId?.trim())
          .filter((projectId): projectId is string => Boolean(projectId)),
      ),
    );

    const projectNamesById = new Map<string, string>();

    for (
      let startIndex = 0;
      startIndex < normalizedProjectIds.length;
      startIndex += this.projectLookupBatchSize
    ) {
      const batch = normalizedProjectIds.slice(
        startIndex,
        startIndex + this.projectLookupBatchSize,
      );

      const responses = await Promise.all(
        batch.map((projectId) =>
          this.fetchJson<ProjectSummary>(
            `${this.getProjectApiBaseUrl()}/${encodeURIComponent(projectId)}?fields=id,name`,
            token,
          ).catch((error: unknown) => {
            const message =
              error instanceof Error ? error.message : "Unknown error";
            this.logger.warn(
              `Unable to resolve project name for projectId=${projectId}: ${message}`,
            );
            return null;
          }),
        ),
      );

      responses.forEach((project) => {
        const projectId =
          project?.id === undefined || project?.id === null
            ? null
            : String(project.id).trim();
        const projectName = this.toOptionalString(project?.name);

        if (!projectId || !projectName) {
          return;
        }

        projectNamesById.set(projectId, projectName);
      });
    }

    return projectNamesById;
  }

  /**
   * Retrieves an M2M token used for member and project API lookups.
   *
   * @returns Bearer token for platform API requests.
   * @throws Error when the M2M credentials are not configured.
   */
  private async getM2MToken(): Promise<string> {
    const clientId = this.config.get<string>("M2M_CLIENT_ID");
    const clientSecret = this.config.get<string>("M2M_CLIENT_SECRET");

    if (!clientId || !clientSecret) {
      throw new Error(
        "M2M_CLIENT_ID and M2M_CLIENT_SECRET must be configured for the engagement data report.",
      );
    }

    return this.m2m.getMachineToken(clientId, clientSecret);
  }

  /**
   * Executes an authenticated GET request and returns the parsed JSON body.
   *
   * @param url Absolute platform API URL.
   * @param token Bearer token for the request.
   * @returns Parsed JSON response body.
   * @throws Error when the response is not successful.
   */
  private async fetchJson<T>(url: string, token: string): Promise<T> {
    const response = await fetch(url, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      throw new Error(
        `Request failed (${response.status}) while fetching ${url}.`,
      );
    }

    return (await response.json()) as T;
  }

  /**
   * Returns the base v6 members URL used for report enrichment.
   *
   * @returns Base URL for member API requests.
   */
  private getMemberApiBaseUrl(): string {
    const apiBaseUrl = this.config.get<string>(
      "TOPCODER_API_URL_BASE",
      "https://api.topcoder-dev.com",
    );

    return `${apiBaseUrl.replace(/\/$/, "")}/v6/members`;
  }

  /**
   * Returns the base v6 projects URL used for project-name lookups.
   *
   * @returns Base URL for projects API requests.
   */
  private getProjectApiBaseUrl(): string {
    const apiBaseUrl = this.config.get<string>(
      "TOPCODER_API_URL_BASE",
      "https://api.topcoder-dev.com",
    );

    return `${apiBaseUrl.replace(/\/$/, "")}/v6/projects`;
  }

  /**
   * Formats the preferred address from a member profile.
   *
   * @param addresses Member profile addresses array.
   * @returns Comma-separated address string or null when unavailable.
   */
  private formatAddress(
    addresses?: MemberProfileAddress[] | null,
  ): string | null {
    const address = Array.isArray(addresses) ? addresses[0] : null;
    if (!address) {
      return null;
    }

    const parts = [
      address.streetAddr1,
      address.streetAddr2,
      address.city,
      address.stateCode,
      address.zip,
    ]
      .map((value) => this.toOptionalString(value))
      .filter((value): value is string => Boolean(value));

    return parts.length ? parts.join(", ") : null;
  }

  /**
   * Selects the preferred phone number from the member profile.
   *
   * Mobile numbers are preferred when present because that is how the
   * engagements UI chooses a single display phone for application forms.
   *
   * @param phones Member profile phone list.
   * @returns Preferred phone number or null when unavailable.
   */
  private getPreferredPhoneNumber(
    phones?: MemberProfilePhone[] | null,
  ): string | null {
    const normalizedPhones = Array.isArray(phones)
      ? phones
          .map((phone) => ({
            number: this.toOptionalString(phone?.number),
            type: this.toOptionalString(phone?.type),
          }))
          .filter((phone): phone is { number: string; type: string | null } =>
            Boolean(phone.number),
          )
      : [];

    if (!normalizedPhones.length) {
      return null;
    }

    const mobilePhone = normalizedPhones.find((phone) =>
      phone.type?.toLowerCase().includes("mobile"),
    );

    return mobilePhone?.number ?? normalizedPhones[0].number;
  }

  /**
   * Resolves the report country value from the member profile.
   *
   * @param member Member profile returned by member-api.
   * @returns Country name or null when unavailable.
   */
  private resolveMemberCountry(member?: MemberProfile): string | null {
    const countryFromCode = alpha3ToCountryName(
      this.toOptionalString(member?.homeCountryCode),
    );

    return countryFromCode ?? this.toOptionalString(member?.country);
  }

  /**
   * Splits a full name into first and last name fallbacks.
   *
   * @param value Full-name string captured on the engagement application.
   * @returns Parsed first and last name values.
   */
  private parseName(value?: string | null): ParsedName {
    const normalizedValue = this.toOptionalString(value);
    if (!normalizedValue) {
      return { firstName: null, lastName: null };
    }

    const parts = normalizedValue.split(/\s+/).filter(Boolean);
    if (parts.length === 1) {
      return { firstName: parts[0], lastName: null };
    }

    return {
      firstName: parts[0] ?? null,
      lastName: parts.slice(1).join(" ") || null,
    };
  }

  /**
   * Normalizes optional string values by trimming whitespace and dropping blanks.
   *
   * @param value Candidate string value.
   * @returns Trimmed string or null when empty.
   */
  private toOptionalString(value?: string | null): string | null {
    const normalizedValue = value?.trim();
    return normalizedValue ? normalizedValue : null;
  }

  private toNullableNumberArray(value: unknown): number[] | null {
    if (value === null || value === undefined) {
      return null;
    }

    let normalizedValue = value;

    if (typeof normalizedValue === "string") {
      try {
        normalizedValue = JSON.parse(normalizedValue);
      } catch {
        return null;
      }
    }

    if (!Array.isArray(normalizedValue)) {
      return null;
    }

    return normalizedValue.reduce<number[]>((scores, item) => {
      const numericValue = Number(item);
      if (Number.isFinite(numericValue)) {
        scores.push(numericValue);
      }
      return scores;
    }, []);
  }

  private toNullableNumber(value: string | number | null | undefined) {
    if (value === null || value === undefined) {
      return null;
    }
    return Number(value);
  }

  private normalizeDate(value: Date | string | null | undefined) {
    if (value === null || value === undefined) {
      return null;
    }
    if (value instanceof Date) {
      return value.toISOString();
    }
    return value;
  }
}
