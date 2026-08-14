import { Injectable, NotFoundException, OnModuleDestroy } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { DbService } from "../../db/db.service";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { alpha3ToCountryName } from "../../common/country.util";
import { Pool } from "pg";

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

type LeaderboardGenericRow = {
  challengeId: string;
  challengeName: string;
  durationDays: number;
  prizePool: number;
  submissionsCount: number;
  placementPrizes: { placement: number; value: number }[] | null;
  userId: string;
  handle: string;
  name: string | null;
  country: string | null;
  countryCode: string | null;
  photoURL: string | null;
  rating: string | number | null;
  ratingColor: string | null;
  score: number;
  submittedDate: string;
  submissionCount: string | number | null;
  placement: number;
  challengeStatus: string;
  isAiOnlyChallenge: boolean;
  userSubmissionsCount: number;
};

type LeaderboardMmRow = {
  challengeId: string;
  challengeName: string;
  isMarathonMatch: boolean;
  userId: string;
  submissionId: string;
  handle: string;
  name: string | null;
  country: string | null;
  countryCode: string | null;
  photoURL: string | null;
  rating: string | number | null;
  ratingColor: string | null;
  placement: number;
  provisionalRank: number;
  provisionalScore: number | null;
  finalScore: number | null;
  score: number | null;
  submittedDate: string | null;
};

// Mirrors the web LeaderboardEntry shape. `finalScore` is intentionally optional and
// omitted (not null) when a match has no final results, because the leaderboard table
// decides between "Final" and "Provisional" columns via `finalScore !== undefined`.
type LeaderboardMmEntry = {
  challengeId: string;
  challengeName: string;
  userId: string;
  handle: string;
  placement: number;
  provisionalRank: number;
  provisionalScore?: number;
  finalScore?: number;
  score?: number;
};

type LeaderboardMmMemberInfo = {
  userId: string;
  handle: string;
  name: string;
  country: string;
  countryCode: string;
  photoURL?: string;
  rating?: number;
  ratingColor?: string;
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

type EngagementMemberRow = {
  user_id: string | number | null;
  handle: string | null;
  first_name: string | null;
  last_name: string | null;
  email: string | null;
  home_country: string | null;
  competition_country: string | null;
  home_country_code: string | null;
  competition_country_code: string | null;
  street_addr_1: string | null;
  street_addr_2: string | null;
  city: string | null;
  state_code: string | null;
  zip: string | null;
  phone_number: string | null;
};

type FormattableAddress = {
  streetAddr1?: string | null;
  streetAddr2?: string | null;
  city?: string | null;
  stateCode?: string | null;
  zip?: string | null;
};

type EngagementProjectRow = {
  project_id: string | number | null;
  project_name: string | null;
};

type ParsedName = {
  firstName: string | null;
  lastName: string | null;
};

@Injectable()
export class TopcoderReportsService implements OnModuleDestroy {
  private engagementsPool?: Pool;

  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
    private readonly config: ConfigService,
  ) {}

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
   * The base member list comes from the engagements database, while member
   * profile/contact fields and project names are resolved directly from the
   * main reports database so the export stays DB-only. Country resolution
   * follows the same home-country-first profile fields used by the profile UI
   * and avoids the stale legacy members.member.country fallback.
   *
   * @returns One row per member with the engagement experience summary fields.
   * @throws Error when the engagements database URL is not configured.
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

    const [membersById, projectNamesById] = await Promise.all([
      this.fetchEngagementMembersByUserIds(memberIds),
      this.fetchProjectNamesByIds(projectIds),
    ]);

    return rows.map((row) => {
      const memberId = row.member_id?.trim() ?? "";
      const member = membersById.get(memberId);
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
          this.toOptionalString(member?.first_name) ?? parsedName.firstName,
        lastName:
          this.toOptionalString(member?.last_name) ?? parsedName.lastName,
        country: this.resolveEngagementMemberCountry(member),
        emailId:
          this.toOptionalString(member?.email) ?? row.application_email ?? null,
        phoneNumber:
          this.toOptionalString(member?.phone_number) ??
          row.application_phone ??
          null,
        address:
          this.formatAddress(
            member
              ? {
                  streetAddr1: member.street_addr_1,
                  streetAddr2: member.street_addr_2,
                  city: member.city,
                  stateCode: member.state_code,
                  zip: member.zip,
                }
              : null,
          ) ??
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
    skillIds?: string[],
  ) {
    const safePage = Number.isFinite(page) ? Math.max(Math.floor(page), 1) : 1;
    const safePerPage = Number.isFinite(perPage)
      ? Math.min(Math.max(Math.floor(perPage), 1), 200)
      : 50;
    const offset = (safePage - 1) * safePerPage;

    const hasSkillIds = Array.isArray(skillIds) && skillIds.length > 0;
    const skillIdsParam = hasSkillIds ? skillIds : null;

    const countQuery = this.sql.load(
      "reports/topcoder/completed-profiles-count.sql",
    );
    const countRows = await this.db.query<CompletedProfilesCountRow>(
      countQuery,
      [
        countryCode || null,
        typeof openToWork === "boolean" ? openToWork : null,
        skillIdsParam,
      ],
    );
    const total = Number(countRows?.[0]?.total ?? 0);

    const query = this.sql.load("reports/topcoder/completed-profiles.sql");
    const rows = await this.db.query<CompletedProfileRow>(query, [
      countryCode || null,
      typeof openToWork === "boolean" ? openToWork : null,
      safePerPage,
      offset,
      skillIdsParam,
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
   * Fetches member profile rows from the main reports database so the report
   * can be enriched without member-api calls.
   *
   * @param userIds Report member ids from the engagements database.
   * @returns Map of user id to member profile/contact row.
   */
  private async fetchEngagementMembersByUserIds(
    userIds: string[],
  ): Promise<Map<string, EngagementMemberRow>> {
    const normalizedUserIds = Array.from(
      new Set(
        userIds
          .map((userId) => userId?.trim())
          .filter((userId): userId is string => Boolean(userId)),
      ),
    );

    const membersById = new Map<string, EngagementMemberRow>();

    if (!normalizedUserIds.length) {
      return membersById;
    }

    const query = this.sql.load("reports/topcoder/engagement-data-members.sql");
    const rows = await this.db.query<EngagementMemberRow>(query, [
      normalizedUserIds,
    ]);

    rows.forEach((member) => {
      const userId =
        member?.user_id === undefined || member.user_id === null
          ? null
          : String(member.user_id).trim();

      if (!userId) {
        return;
      }

      membersById.set(userId, member);
    });

    return membersById;
  }

  /**
   * Resolves the report country using the same home-country-first fields the
   * profile UI uses for member location display.
   *
   * @param member DB-backed member enrichment row for the engagement report.
   * @returns Resolved country name or null when the profile has no known country.
   */
  private resolveEngagementMemberCountry(
    member?: EngagementMemberRow,
  ): string | null {
    return (
      this.toOptionalString(member?.home_country) ??
      alpha3ToCountryName(member?.home_country_code) ??
      this.toOptionalString(member?.competition_country) ??
      alpha3ToCountryName(member?.competition_country_code)
    );
  }

  /**
   * Resolves project names for the assigned project ids included in the report.
   *
   * @param projectIds Project ids collected from engagement assignments.
   * @returns Map of project id to project name.
   */
  private async fetchProjectNamesByIds(
    projectIds: string[],
  ): Promise<Map<string, string>> {
    const normalizedProjectIds = Array.from(
      new Set(
        projectIds
          .map((projectId) => projectId?.trim())
          .filter((projectId): projectId is string => Boolean(projectId)),
      ),
    );

    const projectNamesById = new Map<string, string>();

    if (!normalizedProjectIds.length) {
      return projectNamesById;
    }

    const query = this.sql.load(
      "reports/topcoder/engagement-data-projects.sql",
    );
    const rows = await this.db.query<EngagementProjectRow>(query, [
      normalizedProjectIds,
    ]);

    rows.forEach((project) => {
      const projectId =
        project?.project_id === undefined || project.project_id === null
          ? null
          : String(project.project_id).trim();
      const projectName = this.toOptionalString(project?.project_name);

      if (!projectId || !projectName) {
        return;
      }

      projectNamesById.set(projectId, projectName);
    });

    return projectNamesById;
  }

  async getLeaderboardGeneric(filters: {
    challengeIds: string[];
    pointsPerDay?: number;
    placementPrizeAmounts?: string[];
    showHeadingAndSubtitle?: boolean;
    showRealtimeScore?: boolean;
  }) {
    const query = this.sql.load("reports/topcoder/leaderboard-generic.sql");
    const rows = await this.db.query<LeaderboardGenericRow>(query, [
      filters.challengeIds,
      filters.showRealtimeScore === true,
    ]);

    const useCmsPlacementPrizes =
      Array.isArray(filters.placementPrizeAmounts) &&
      filters.placementPrizeAmounts.length > 0;
    const cmsPlacementPrizeAmounts = (filters.placementPrizeAmounts ?? [])
      .map((amount) => Number(amount))
      .filter((amount) => Number.isFinite(amount));

    const challenges: Record<
      string,
      { id: string; name: string; submissions: { [memberId: string]: number } }
    > = {};
    const entriesByUser: Record<
      string,
      {
        userId: string;
        handle: string;
        name: string | null;
        country: string | null;
        countryCode: string | null;
        wins: Record<string, number>;
        points: number;
        prizes: number;
        submissionCount: number;
        photoURL: string | null;
        rating: number;
        ratingColor: string | null;
        challengeScores: Record<
          string,
          { score: number; isProvisional: boolean }
        >;
      }
    > = {};

    rows.forEach((row) => {
      challenges[row.challengeId] = challenges[row.challengeId] ?? {
        id: row.challengeId,
        name: row.challengeName,
        submissions: {},
      };
      challenges[row.challengeId].submissions[row.userId] = row.placement;

      if (!entriesByUser[row.userId]) {
        entriesByUser[row.userId] = {
          userId: row.userId,
          handle: row.handle,
          name: row.name,
          country: row.country,
          countryCode: row.countryCode,
          photoURL: row.photoURL,
          wins: {},
          points: 0,
          prizes: 0,
          submissionCount: 0,
          rating: row.rating as number,
          ratingColor: row.ratingColor,
          challengeScores: {},
        };
      }

      const memberSubmissions = Number(row.submissionCount ?? 0);
      entriesByUser[row.userId].submissionCount += Number.isFinite(
        memberSubmissions,
      )
        ? memberSubmissions
        : 0;

      const log =
        Math.log10(Math.max(1, row.prizePool)) +
        row.durationDays * (filters.pointsPerDay ?? 0);
      const relativeRank = row.placement / Math.max(1, row.submissionsCount);
      const sqrt = Math.sqrt(relativeRank);
      const pointsByWin = log / sqrt;

      entriesByUser[row.userId].points += pointsByWin;
      entriesByUser[row.userId].wins[row.challengeId] = pointsByWin;
      entriesByUser[row.userId].challengeScores[row.challengeId] = {
        score: row.score,
        isProvisional:
          filters.showRealtimeScore === true &&
          row.challengeStatus !== "COMPLETED",
      };
      if (!useCmsPlacementPrizes) {
        const prizeValue =
          (row.placementPrizes ?? []).find((p) => p.placement === row.placement)
            ?.value ?? 0;
        entriesByUser[row.userId].prizes += prizeValue;
      }
    });

    const placementData = Object.values(entriesByUser)
      .filter((entry) => entry.points > 0)
      .sort((a, b) => b.points - a.points)
      .map((entry, index) => ({
        userId: entry.userId,
        handle: entry.handle,
        name: entry.name ?? "",
        country: entry.country ?? "",
        countryCode: entry.countryCode ?? "",
        photoURL: entry.photoURL,
        placement: index,
        points: entry.points,
        wins: entry.wins,
        challengeScores: entry.challengeScores,
        submissionCount: entry.submissionCount,
        rating: entry.rating,
        ratingColor: entry.ratingColor,
        prizes: useCmsPlacementPrizes
          ? (cmsPlacementPrizeAmounts[index] ?? 0)
          : entry.prizes,
      }));

    return {
      placementData: filters.showHeadingAndSubtitle
        ? placementData.slice(0, 10)
        : placementData,
      challenges,
    };
  }

  private calculateWriterTesterBonuses(
    placementData: Record<string, any[]>,
    writersAndTesters: string[] | undefined,
    pointsMap: number[] = [],
    baseScoringPoints = 1,
  ) {
    const contributions = (writersAndTesters ?? [])
      .map((entry) => {
        const [handle = "", challengeId = "", role = ""] = entry.split(":");
        if (!handle || !challengeId || !["writer", "tester"].includes(role)) {
          return null;
        }
        return { handle, challengeId, role: role as "writer" | "tester" };
      })
      .filter(Boolean) as {
      handle: string;
      challengeId: string;
      role: "writer" | "tester";
    }[];

    const bonusPoints: Record<string, number> = {};
    const eligibility: Record<string, any> = {};
    const writerTesterRoles: Record<
      string,
      Record<string, "writer" | "tester">
    > = {};

    if (!contributions.length) {
      return { bonusPoints, eligibility, writerTesterRoles };
    }

    const pointsFn = (winner: any) =>
      winner.score && winner.score <= 0
        ? 0
        : Number(pointsMap[winner.placement - 1] ?? baseScoringPoints);

    const challengeIds = Object.keys(placementData);
    const competitionMatchesByHandle: Record<string, Set<string>> = {};
    const competitionPointsByHandle: Record<string, number> = {};

    challengeIds.forEach((challengeId) => {
      placementData[challengeId].forEach((entry) => {
        competitionMatchesByHandle[entry.handle] =
          competitionMatchesByHandle[entry.handle] ?? new Set();
        competitionMatchesByHandle[entry.handle].add(challengeId);
        competitionPointsByHandle[entry.handle] =
          (competitionPointsByHandle[entry.handle] ?? 0) + pointsFn(entry);
      });
    });

    const matchCount = challengeIds.length;
    const minCompetitions = Math.ceil(matchCount / 2);
    const contributionByHandle: Record<string, Set<string>> = {};

    contributions.forEach(({ handle, challengeId, role }) => {
      if (!challengeIds.includes(challengeId)) {
        return;
      }
      if (competitionMatchesByHandle[handle]?.has(challengeId)) {
        return;
      }
      contributionByHandle[handle] = contributionByHandle[handle] ?? new Set();
      contributionByHandle[handle].add(challengeId);
      writerTesterRoles[handle] = writerTesterRoles[handle] ?? {};
      writerTesterRoles[handle][challengeId] = role;
    });

    Object.entries(contributionByHandle).forEach(
      ([handle, contributionsSet]) => {
        const contributionMatches = contributionsSet.size;
        const competitionMatches =
          competitionMatchesByHandle[handle]?.size ?? 0;
        const competitionPoints = competitionPointsByHandle[handle] ?? 0;
        const averageCompetitionPoints = competitionMatches
          ? competitionPoints / competitionMatches
          : 0;
        const eligibleForChampionship =
          competitionMatches >= minCompetitions &&
          contributionMatches <= matchCount / 2;
        const bonus = eligibleForChampionship
          ? averageCompetitionPoints * contributionMatches
          : 0;

        bonusPoints[handle] = Number(bonus.toFixed(2));
        eligibility[handle] = {
          competitionMatches,
          contributionMatches,
          averageCompetitionPoints: Number(averageCompetitionPoints.toFixed(2)),
          bonusPoints: bonusPoints[handle],
          eligibleForChampionship,
        };
      },
    );

    return { bonusPoints, eligibility, writerTesterRoles };
  }

  async getLeaderboardMm(filters: {
    challengeIds: string[];
    placementPoints?: number[];
    defaultPlacementPoints?: number;
    writersAndTesters?: string[];
  }) {
    const query = this.sql.load("reports/topcoder/leaderboard-mm.sql");
    const rows = await this.db.query<LeaderboardMmRow>(query, [
      filters.challengeIds,
    ]);

    const placementData = rows.reduce(
      (acc: Record<string, LeaderboardMmEntry[]>, row) => {
        acc[row.challengeId] = acc[row.challengeId] ?? [];
        acc[row.challengeId].push({
          challengeId: row.challengeId,
          challengeName: row.challengeName,
          userId: row.userId,
          handle: row.handle,
          placement: Number(row.placement),
          provisionalRank: Number(row.provisionalRank),
          ...(row.provisionalScore !== null && {
            provisionalScore: Number(row.provisionalScore),
          }),
          ...(row.finalScore !== null && {
            finalScore: Number(row.finalScore),
          }),
          ...(row.score !== null && { score: Number(row.score) }),
        });
        return acc;
      },
      {} as Record<string, LeaderboardMmEntry[]>,
    );

    const membersDetails: Record<string, LeaderboardMmMemberInfo> = {};
    rows.forEach((row) => {
      const rating = row.rating === null ? undefined : Number(row.rating);
      membersDetails[row.handle] = {
        ...membersDetails[row.handle],
        userId: row.userId,
        handle: row.handle,
        name: row.name ?? row.handle,
        country: row.country ?? "",
        countryCode: row.countryCode ?? "",
        ...(row.photoURL && { photoURL: row.photoURL }),
        ...(rating !== undefined && Number.isFinite(rating) && { rating }),
        ...(row.ratingColor && { ratingColor: row.ratingColor }),
      };
    });

    const writerTesterData = this.calculateWriterTesterBonuses(
      placementData,
      filters.writersAndTesters,
      filters.placementPoints ?? [],
      filters.defaultPlacementPoints ?? 1,
    );

    return {
      membersDetails,
      challengesDetails: Object.fromEntries(
        Object.entries(placementData).map(([challengeId, entries]) => [
          challengeId,
          { name: entries[0]?.challengeName ?? "" },
        ]),
      ),
      placementData,
      writerTesterBonusPoints: writerTesterData.bonusPoints,
      writerTesterRoles: writerTesterData.writerTesterRoles,
      writerTesterEligibility: writerTesterData.eligibility,
    };
  }

  /**
   * Formats a preferred address row into the report output string.
   *
   * @param address Address row selected for a member.
   * @returns Comma-separated address string or null when unavailable.
   */
  private formatAddress(address?: FormattableAddress | null): string | null {
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
