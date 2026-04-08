import { Scopes as AppScopes } from "../app-constants";
import { AuthUserLike, hasAccessToScopes } from "../auth/permissions.util";
import { ChallengeStatus } from "./challenges/dtos/challenge-status.enum";

export type ReportGroupKey =
  | "challenges"
  | "sfdc"
  | "statistics"
  | "topcoder"
  | "member"
  | "admin"
  | "identity";

type HttpMethod = "GET" | "POST";

type ParameterLocation = "query" | "path" | "body";

type ReportParameterType =
  | "string"
  | "string[]"
  | "number"
  | "number[]"
  | "boolean"
  | "date"
  | "enum"
  | "enum[]";

export type ReportParameter = {
  name: string;
  type: ReportParameterType;
  description?: string;
  required?: boolean;
  location?: ParameterLocation;
  options?: string[];
};

export type AvailableReport = {
  name: string;
  path: string;
  description: string;
  method: HttpMethod;
  parameters: ReportParameter[];
};

export type ReportGroup = {
  label: string;
  basePath: string;
  reports: AvailableReport[];
};

export type ReportsDirectory = Partial<Record<ReportGroupKey, ReportGroup>>;

type RegisteredReport = AvailableReport & {
  requiredScopes: readonly string[];
};

type RegisteredReportGroup = Omit<ReportGroup, "reports"> & {
  reports: RegisteredReport[];
};

type RegisteredReportsDirectory = Record<ReportGroupKey, RegisteredReportGroup>;

const report = (
  name: string,
  path: string,
  description: string,
  requiredScopes: readonly string[] = [],
  parameters: ReportParameter[] = [],
): RegisteredReport => ({
  name,
  path,
  description,
  method: "GET",
  parameters,
  requiredScopes,
});

const postReport = (
  name: string,
  path: string,
  description: string,
  requiredScopes: readonly string[] = [],
  parameters: ReportParameter[] = [],
): RegisteredReport => ({
  name,
  path,
  description,
  method: "POST",
  parameters,
  requiredScopes,
});

const challengeReport = (
  name: string,
  path: string,
  description: string,
  scope: string,
  parameters: ReportParameter[] = [],
): RegisteredReport =>
  report(name, path, description, [AppScopes.AllReports, scope], parameters);

const identityReport = (
  name: string,
  path: string,
  description: string,
  scope: string,
  parameters: ReportParameter[] = [],
): RegisteredReport =>
  report(name, path, description, [AppScopes.AllReports, scope], parameters);

const identityPostReport = (
  name: string,
  path: string,
  description: string,
  scope: string,
  parameters: ReportParameter[] = [],
): RegisteredReport =>
  postReport(
    name,
    path,
    description,
    [AppScopes.AllReports, scope],
    parameters,
  );

const sfdcReport = (
  name: string,
  path: string,
  description: string,
  scope: string,
  parameters: ReportParameter[] = [],
): RegisteredReport =>
  report(name, path, description, [AppScopes.AllReports, scope], parameters);

const topcoderReport = (
  name: string,
  path: string,
  description: string,
  parameters: ReportParameter[] = [],
): RegisteredReport =>
  report(
    name,
    path,
    description,
    [AppScopes.AllReports, AppScopes.TopcoderReports],
    parameters,
  );

const publicReport = (
  name: string,
  path: string,
  description: string,
  parameters: ReportParameter[] = [],
): RegisteredReport => report(name, path, description, [], parameters);

const challengeStatusParam: ReportParameter = {
  name: "challengeStatus",
  type: "enum[]",
  description: "Filter by challenge status",
  location: "query",
  options: Object.values(ChallengeStatus),
};

const billingAccountIdsParam: ReportParameter = {
  name: "billingAccountIds",
  type: "string[]",
  description:
    "List of billing account IDs associated with the payments to retrieve",
  location: "query",
};

const completionDateFromParam: ReportParameter = {
  name: "completionDateFrom",
  type: "date",
  description: "Filter by challenge completion date (from)",
  location: "query",
  required: true,
};

const completionDateToParam: ReportParameter = {
  name: "completionDateTo",
  type: "date",
  description: "Filter by challenge completion date (to)",
  location: "query",
};

const challengeDateRangeParams = [
  completionDateFromParam,
  completionDateToParam,
];

const challengeHistoryFilters = [
  challengeStatusParam,
  billingAccountIdsParam,
  ...challengeDateRangeParams,
];

const submissionLinksFilters = [
  completionDateFromParam,
  completionDateToParam,
  challengeStatusParam,
];

const paymentsStartDateParam: ReportParameter = {
  name: "startDate",
  type: "date",
  description: "Start date for the report query in ISO format",
  location: "query",
};

const paymentsEndDateParam: ReportParameter = {
  name: "endDate",
  type: "date",
  description: "End date for the report query in ISO format",
  location: "query",
};

const challengeNameParam: ReportParameter = {
  name: "challengeName",
  type: "string",
  description: "Challenge name to search for",
  location: "query",
};

const challengeIdsParam: ReportParameter = {
  name: "challengeIds",
  type: "string[]",
  description: "List of challenge IDs",
  location: "query",
};

const handlesParam: ReportParameter = {
  name: "handles",
  type: "string[]",
  description: "List of user handles",
  location: "query",
};

const handlesBodyParam: ReportParameter = {
  name: "handles",
  type: "string[]",
  description: "List of user handles to look up",
  required: true,
  location: "body",
};

const minPaymentParam: ReportParameter = {
  name: "minPaymentAmount",
  type: "number",
  description: "Minimum payment amount for filtering the report",
  location: "query",
};

const maxPaymentParam: ReportParameter = {
  name: "maxPaymentAmount",
  type: "number",
  description: "Maximum payment amount for filtering the report",
  location: "query",
};

const paymentStatusParam: ReportParameter = {
  name: "status",
  type: "string[]",
  description:
    "Payment status codes to filter by (for example ON_HOLD, PROCESSING, CANCELLED). Leave blank to include all statuses.",
  location: "query",
};

const paymentsFilters = [
  billingAccountIdsParam,
  challengeNameParam,
  challengeIdsParam,
  paymentsStartDateParam,
  paymentsEndDateParam,
  handlesParam,
  minPaymentParam,
  maxPaymentParam,
  paymentStatusParam,
];

const baFeesDateParams: ReportParameter[] = [
  {
    name: "startDate",
    type: "date",
    description: "Start date for the report query in ISO format",
    location: "query",
    required: true,
  },
  {
    name: "endDate",
    type: "date",
    description: "End date for the report query in ISO format",
    location: "query",
  },
];

const registrantCountriesParam: ReportParameter = {
  name: "challengeId",
  type: "string",
  description: "Challenge ID to retrieve registrant countries for",
  location: "query",
  required: true,
};

const challengeIdParam: ReportParameter = {
  name: "challengeId",
  type: "string",
  description: "Challenge ID to retrieve report data for",
  location: "path",
  required: true,
};

const challengeSubmitterDataParam: ReportParameter = {
  name: "challengeId",
  type: "string",
  description: "Challenge ID to retrieve submitter profile data for",
  location: "query",
  required: true,
};

const marathonMatchHandleParam: ReportParameter = {
  name: "handle",
  type: "string",
  description: "Marathon Match competitor handle",
  location: "path",
  required: true,
};

const roleIdParam: ReportParameter = {
  name: "roleId",
  type: "number",
  description: "Role ID",
  location: "query",
};

const roleNameParam: ReportParameter = {
  name: "roleName",
  type: "string",
  description: "Role name",
  location: "query",
};

const groupIdParam: ReportParameter = {
  name: "groupId",
  type: "string",
  description: "Group UUID or legacy numeric group ID",
  location: "query",
};

const groupNameParam: ReportParameter = {
  name: "groupName",
  type: "string",
  description: "Group name",
  location: "query",
};

const REGISTERED_REPORTS_DIRECTORY: RegisteredReportsDirectory = {
  challenges: {
    label: "Challenges Reports",
    basePath: "/challenges",
    reports: [
      challengeReport(
        "Challenge History",
        "/challenges",
        "Return the challenge history report",
        AppScopes.Challenge.History,
        challengeHistoryFilters,
      ),
      challengeReport(
        "Challenge Registrants",
        "/challenges/registrants",
        "Return the challenge registrants history report",
        AppScopes.Challenge.Registrants,
        challengeHistoryFilters,
      ),
      challengeReport(
        "Submission Links",
        "/challenges/submission-links",
        "Return the submission links report",
        AppScopes.Challenge.SubmissionLinks,
        submissionLinksFilters,
      ),
      challengeReport(
        "Challenge Registered Users",
        "/challenges/:challengeId/registered-users",
        "Return the challenge registered users report",
        AppScopes.Challenge.RegisteredUsers,
        [challengeIdParam],
      ),
      challengeReport(
        "Challenge Submitters",
        "/challenges/:challengeId/submitters",
        "Return the challenge submitters report. Marathon Match exports use the latest submission provisionalScore and current effective rank, with earlier submission times winning score ties.",
        AppScopes.Challenge.Submitters,
        [challengeIdParam],
      ),
      challengeReport(
        "Challenge Valid Submitters",
        "/challenges/:challengeId/valid-submitters",
        "Return the challenge valid submitters report. Marathon Match exports use the latest submission provisionalScore and current effective rank, with earlier submission times winning score ties.",
        AppScopes.Challenge.ValidSubmitters,
        [challengeIdParam],
      ),
      challengeReport(
        "Challenge Winners",
        "/challenges/:challengeId/winners",
        "Return the challenge winners report with placement winners only. Marathon Match exports include provisionalScore and the challenge-result finalRank.",
        AppScopes.Challenge.Winners,
        [challengeIdParam],
      ),
    ],
  },
  identity: {
    label: "Identity Reports",
    basePath: "/identity",
    reports: [
      identityReport(
        "Users by Role",
        "/identity/users-by-role",
        "Export user ID, handle, and email for all users assigned to the specified role",
        AppScopes.Identity.UsersByRole,
        [roleIdParam, roleNameParam],
      ),
      identityReport(
        "Users by Group",
        "/identity/users-by-group",
        "Export user ID, handle, and email for all users belonging to the specified group",
        AppScopes.Identity.UsersByGroup,
        [groupIdParam, groupNameParam],
      ),
      identityPostReport(
        "Users by Handles",
        "/identity/users-by-handles",
        "Export user ID, handle, email, and country for each supplied handle; unknown handles return empty fields",
        AppScopes.Identity.UsersByHandles,
        [handlesBodyParam],
      ),
    ],
  },
  sfdc: {
    label: "SFDC Reports",
    basePath: "/sfdc",
    reports: [
      sfdcReport(
        "Payments",
        "/sfdc/payments",
        "SFDC Payments report",
        AppScopes.SFDC.PaymentsReport,
        paymentsFilters,
      ),
      sfdcReport(
        "BA Fees",
        "/sfdc/ba-fees",
        "Report of BA to fee / member payment",
        AppScopes.SFDC.BA,
        baFeesDateParams,
      ),
    ],
  },
  statistics: {
    label: "Statistics",
    basePath: "/statistics",
    reports: [
      publicReport(
        "SRM Top Rated",
        "/statistics/srm/top-rated",
        "Highest rated SRMs (static)",
      ),
      publicReport(
        "SRM Country Ratings",
        "/statistics/srm/country-ratings",
        "SRM country ratings (static)",
      ),
      publicReport(
        "SRM Competitions Count",
        "/statistics/srm/competitions-count",
        "SRM number of competitions (static)",
      ),
      publicReport(
        "MM Top Rated",
        "/statistics/mm/top-rated",
        "Highest rated Marathon Matches (static)",
      ),
      publicReport(
        "MM Country Ratings",
        "/statistics/mm/country-ratings",
        "Marathon Match country ratings (static)",
      ),
      publicReport(
        "MM Top 10 Finishes",
        "/statistics/mm/top-10-finishes",
        "Marathon Match Top 10 finishes (static)",
      ),
      publicReport(
        "MM Competitions Count",
        "/statistics/mm/competitions-count",
        "Marathon Match number of competitions (static)",
      ),
      publicReport(
        "Member Count",
        "/statistics/general/member-count",
        "Total number of member records",
      ),
      publicReport(
        "Total Prizes",
        "/statistics/general/total-prizes",
        "Total amount of all payments",
      ),
      publicReport(
        "Completed Challenges",
        "/statistics/general/completed-challenges",
        "Total number of completed challenges",
      ),
      publicReport(
        "Countries Represented",
        "/statistics/general/countries-represented",
        "Member count by country (desc)",
      ),
      publicReport(
        "First Place by Country",
        "/statistics/general/first-place-by-country",
        "First place finishes by country (desc)",
      ),
      publicReport(
        "Copiloted Challenges",
        "/statistics/general/copiloted-challenges",
        "Copiloted challenges by member (desc)",
      ),
      publicReport(
        "Reviews by Member",
        "/statistics/general/reviews-by-member",
        "Review participation by member (desc)",
      ),
      publicReport(
        "UI Design Wins",
        "/statistics/design/ui-design-wins",
        "Design 'Challenge' wins by member (desc)",
      ),
      publicReport(
        "Design First2Finish Wins",
        "/statistics/design/f2f-wins",
        "Design First2Finish wins by member (desc)",
      ),
      publicReport(
        "LUX First Place Wins",
        "/statistics/design/lux-first-place-wins",
        "Design LUX first place wins by member (desc)",
      ),
      publicReport(
        "LUX Placements",
        "/statistics/design/lux-placements",
        "Design LUX placements by member (desc)",
      ),
      publicReport(
        "RUX Placements",
        "/statistics/design/rux-placements",
        "Design RUX placements by member (desc)",
      ),
      publicReport(
        "First-time Design Submitters",
        "/statistics/design/first-time-submitters",
        "First-time design submitters in last 3 months",
      ),
      publicReport(
        "Design Countries Represented",
        "/statistics/design/countries-represented",
        "Design submitters by country (desc)",
      ),
      publicReport(
        "Design First Place by Country",
        "/statistics/design/first-place-by-country",
        "Design first place finishes by country (desc)",
      ),
      publicReport(
        "RUX First Place Wins",
        "/statistics/design/rux-first-place-wins",
        "RUX first place design challenge wins by member (desc)",
      ),
      publicReport(
        "Wireframe Wins",
        "/statistics/design/wireframe-wins",
        "Design wireframe challenge wins by member (desc)",
      ),
      publicReport(
        "Development Challenge Wins",
        "/statistics/development/code-wins",
        "Development challenge wins by member (desc)",
      ),
      publicReport(
        "Development First2Finish Wins",
        "/statistics/development/f2f-wins",
        "Development First2Finish wins by member (desc)",
      ),
      publicReport(
        "Prototype Wins",
        "/statistics/development/prototype-wins",
        "Development prototype challenge wins by member (desc)",
      ),
      publicReport(
        "Development First Place Wins",
        "/statistics/development/first-place-wins",
        "Development overall wins by member (desc)",
      ),
      publicReport(
        "First-time Development Submitters",
        "/statistics/development/first-time-submitters",
        "First-time development submitters in last 3 months",
      ),
      publicReport(
        "Development Countries Represented",
        "/statistics/development/countries-represented",
        "Development submitters by country (desc)",
      ),
      publicReport(
        "Development First Place by Country",
        "/statistics/development/first-place-by-country",
        "Development first place finishes by country (desc)",
      ),
      publicReport(
        "Development Challenges by Technology",
        "/statistics/development/challenges-technology",
        "Development challenges by standardized skill (desc)",
      ),
      publicReport(
        "QA Wins",
        "/statistics/qa/wins",
        "Quality Assurance challenge wins by member (desc)",
      ),
    ],
  },
  topcoder: {
    label: "Topcoder Reports",
    basePath: "/topcoder",
    reports: [
      topcoderReport(
        "Member Count",
        "/topcoder/member-count",
        "Total number of active members",
      ),
      topcoderReport(
        "Registrant Countries",
        "/topcoder/registrant-countries",
        "Countries of all registrants for the specified challenge",
        [registrantCountriesParam],
      ),
      topcoderReport(
        "challenge_submitter_data",
        "/topcoder/challenge_submitter_data",
        "Submitter profile data for a challenge, with Marathon Match placements and scores",
        [challengeSubmitterDataParam],
      ),
      topcoderReport(
        "Marathon Match Stats",
        "/topcoder/mm-stats/:handle",
        "Marathon match performance snapshot for a specific handle",
        [marathonMatchHandleParam],
      ),
      topcoderReport(
        "Total Copilots",
        "/topcoder/total-copilots",
        "Total number of Copilots",
      ),
      topcoderReport(
        "Weekly Active Copilots",
        "/topcoder/weekly-active-copilots",
        "Weekly challenge and copilot counts by track for the last six months",
      ),
      topcoderReport(
        "Weekly Member Participation",
        "/topcoder/weekly-member-participation",
        "Weekly distinct registrants and submitters for the provided date range (defaults to last five weeks)",
        [paymentsStartDateParam, paymentsEndDateParam],
      ),
      topcoderReport(
        "90 Day Member Spend",
        "/topcoder/90-day-member-spend",
        "Total gross amount paid to members in the last 90 days",
      ),
      topcoderReport(
        "90 Day Members Paid",
        "/topcoder/90-day-members-paid",
        "Total number of distinct members paid in the last 90 days",
      ),
      topcoderReport(
        "90 Day New Members",
        "/topcoder/90-day-new-members",
        "Total number of new active members created in the last 90 days",
      ),
      topcoderReport(
        "90 Day Active Copilots",
        "/topcoder/90-day-active-copilots",
        "Total number of distinct copilots active in the last 90 days",
      ),
      topcoderReport(
        "90 Day User Login",
        "/topcoder/90-day-user-login",
        "Total number of active members who logged in during the last 90 days",
      ),
      topcoderReport(
        "90 Day Challenge Volume",
        "/topcoder/90-day-challenge-volume",
        "Total number of challenges launched in the last 90 days",
      ),
      topcoderReport(
        "90 Day Challenge Duration",
        "/topcoder/90-day-challenge-duration",
        "Total duration and count of completed challenges in the last 90 days",
      ),
      topcoderReport(
        "90 Day Challenge Registrants",
        "/topcoder/90-day-challenge-registrants",
        "Distinct challenge registrants and submitters in the last 90 days",
      ),
      topcoderReport(
        "90 Day Challenge Submitters",
        "/topcoder/90-day-challenge-submitters",
        "Distinct challenge registrants and submitters in the last 90 days",
      ),
      topcoderReport(
        "90 Day Challenge Member Cost",
        "/topcoder/90-day-challenge-member-cost",
        "Member payment totals and averages for challenges completed in the last 90 days",
      ),
      topcoderReport(
        "90 Day Task Member Cost",
        "/topcoder/90-day-task-member-cost",
        "Member payment totals and averages for tasks completed in the last 90 days",
      ),
      topcoderReport(
        "90 Day Fulfillment",
        "/topcoder/90-day-fulfillment",
        "Share of challenges completed versus cancelled in the last 90 days",
      ),
      topcoderReport(
        "90 Day Fulfillment With Tasks",
        "/topcoder/90-day-fulfillment-with-tasks",
        "Share of challenges and tasks completed versus cancelled in the last 90 days",
      ),
      topcoderReport(
        "Weekly Challenge Fulfillment",
        "/topcoder/weekly-challenge-fulfillment",
        "Weekly share of challenges completed versus cancelled for the last four weeks",
      ),
      topcoderReport(
        "Weekly Challenge Volume",
        "/topcoder/weekly-challenge-volume",
        "Weekly challenge counts by task indicator for the last four weeks",
      ),
      topcoderReport(
        "90 Day Membership Participation Funnel",
        "/topcoder/90-day-membership-participation-funnel",
        "New member counts with design and development participation indicators for the last 90 days",
      ),
      topcoderReport(
        "Membership Participation Funnel Data",
        "/topcoder/membership-participation-funnel-data",
        "Weekly new member counts with design and development participation indicators for the last four weeks",
      ),
    ],
  },
  member: {
    label: "Member Reports",
    basePath: "/member",
    reports: [
      report(
        "Engagement Data",
        "/member/engagement-data",
        "Members who have applied to public engagements or have any engagement assignments, including project names for assigned members",
        [
          AppScopes.AllReports,
          AppScopes.TopcoderReports,
          AppScopes.Member.EngagementData,
        ],
      ),
      report(
        "Recent Member Data",
        "/member/recent-member-data",
        "Members who registered and were paid since the start date (defaults to Jan 1, 2024)",
        [
          AppScopes.AllReports,
          AppScopes.TopcoderReports,
          AppScopes.Member.RecentMemberData,
        ],
        [paymentsStartDateParam],
      ),
    ],
  },
  admin: {
    label: "Admin Reports",
    basePath: "/admin",
    reports: [
      topcoderReport(
        "Member Payment Accrual",
        "/admin/member-payment-accrual",
        "Member payment accruals for the provided date range (defaults to last 3 months)",
        [paymentsStartDateParam, paymentsEndDateParam],
      ),
    ],
  },
};

function toAvailableReport(
  reportDefinition: RegisteredReport,
): AvailableReport {
  return {
    description: reportDefinition.description,
    method: reportDefinition.method,
    name: reportDefinition.name,
    parameters: reportDefinition.parameters,
    path: reportDefinition.path,
  };
}

function toReportGroup(group: RegisteredReportGroup): ReportGroup {
  return {
    ...group,
    reports: group.reports.map(toAvailableReport),
  };
}

/**
 * Lists every scope that can unlock at least one catalog entry.
 * The directory endpoints use this to allow callers who can access any report.
 */
export const REPORTS_DIRECTORY_REQUIRED_SCOPES = Array.from(
  new Set(
    Object.values(REGISTERED_REPORTS_DIRECTORY).flatMap((group) =>
      group.reports.flatMap((reportDefinition) =>
        reportDefinition.requiredScopes.filter(
          (scope) => scope !== AppScopes.AllReports,
        ),
      ),
    ),
  ),
);

export const REPORTS_DIRECTORY: ReportsDirectory = Object.fromEntries(
  Object.entries(REGISTERED_REPORTS_DIRECTORY).map(([key, group]) => [
    key,
    toReportGroup(group),
  ]),
) as ReportsDirectory;

/**
 * Returns the subset of the report catalog that the authenticated caller can run.
 * Empty groups are omitted from the response.
 */
export function getAccessibleReportsDirectory(
  authUser?: AuthUserLike,
): ReportsDirectory {
  if (!authUser) {
    return {};
  }

  const accessibleGroups = Object.entries(REGISTERED_REPORTS_DIRECTORY).flatMap(
    ([key, group]) => {
      const accessibleReports = group.reports.filter((reportDefinition) =>
        hasAccessToScopes(authUser, reportDefinition.requiredScopes),
      );

      if (!accessibleReports.length) {
        return [];
      }

      return [
        [
          key,
          {
            ...group,
            reports: accessibleReports.map(toAvailableReport),
          },
        ] as const,
      ];
    },
  );

  return Object.fromEntries(accessibleGroups) as ReportsDirectory;
}
