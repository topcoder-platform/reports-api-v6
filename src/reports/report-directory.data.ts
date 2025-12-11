import { ChallengeStatus } from "./challenges/dtos/challenge-status.enum";

export type ReportGroupKey = "challenges" | "sfdc" | "statistics" | "topcoder";

type HttpMethod = "GET";

type ParameterLocation = "query" | "path";

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

export type ReportsDirectory = Record<ReportGroupKey, ReportGroup>;

const report = (
  name: string,
  path: string,
  description: string,
  parameters: ReportParameter[] = [],
): AvailableReport => ({
  name,
  path,
  description,
  method: "GET",
  parameters,
});

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

const marathonMatchHandleParam: ReportParameter = {
  name: "handle",
  type: "string",
  description: "Marathon Match competitor handle",
  location: "path",
  required: true,
};

export const REPORTS_DIRECTORY: ReportsDirectory = {
  challenges: {
    label: "Challenges Reports",
    basePath: "/challenges",
    reports: [
      report(
        "Challenge History",
        "/challenges",
        "Return the challenge history report",
        challengeHistoryFilters,
      ),
      report(
        "Challenge Registrants",
        "/challenges/registrants",
        "Return the challenge registrants history report",
        challengeHistoryFilters,
      ),
      report(
        "Submission Links",
        "/challenges/submission-links",
        "Return the submission links report",
        submissionLinksFilters,
      ),
    ],
  },
  sfdc: {
    label: "SFDC Reports",
    basePath: "/sfdc",
    reports: [
      report(
        "Payments",
        "/sfdc/payments",
        "SFDC Payments report",
        paymentsFilters,
      ),
      report(
        "BA Fees",
        "/sfdc/ba-fees",
        "Report of BA to fee / member payment",
        baFeesDateParams,
      ),
    ],
  },
  statistics: {
    label: "Statistics",
    basePath: "/statistics",
    reports: [
      report(
        "SRM Top Rated",
        "/statistics/srm/top-rated",
        "Highest rated SRMs (static)",
      ),
      report(
        "SRM Country Ratings",
        "/statistics/srm/country-ratings",
        "SRM country ratings (static)",
      ),
      report(
        "SRM Competitions Count",
        "/statistics/srm/competitions-count",
        "SRM number of competitions (static)",
      ),
      report(
        "MM Top Rated",
        "/statistics/mm/top-rated",
        "Highest rated Marathon Matches (static)",
      ),
      report(
        "MM Country Ratings",
        "/statistics/mm/country-ratings",
        "Marathon Match country ratings (static)",
      ),
      report(
        "MM Top 10 Finishes",
        "/statistics/mm/top-10-finishes",
        "Marathon Match Top 10 finishes (static)",
      ),
      report(
        "MM Competitions Count",
        "/statistics/mm/competitions-count",
        "Marathon Match number of competitions (static)",
      ),
      report(
        "Member Count",
        "/statistics/general/member-count",
        "Total number of member records",
      ),
      report(
        "Total Prizes",
        "/statistics/general/total-prizes",
        "Total amount of all payments",
      ),
      report(
        "Completed Challenges",
        "/statistics/general/completed-challenges",
        "Total number of completed challenges",
      ),
      report(
        "Countries Represented",
        "/statistics/general/countries-represented",
        "Member count by country (desc)",
      ),
      report(
        "First Place by Country",
        "/statistics/general/first-place-by-country",
        "First place finishes by country (desc)",
      ),
      report(
        "Copiloted Challenges",
        "/statistics/general/copiloted-challenges",
        "Copiloted challenges by member (desc)",
      ),
      report(
        "Reviews by Member",
        "/statistics/general/reviews-by-member",
        "Review participation by member (desc)",
      ),
      report(
        "UI Design Wins",
        "/statistics/design/ui-design-wins",
        "Design 'Challenge' wins by member (desc)",
      ),
      report(
        "Design First2Finish Wins",
        "/statistics/design/f2f-wins",
        "Design First2Finish wins by member (desc)",
      ),
      report(
        "LUX First Place Wins",
        "/statistics/design/lux-first-place-wins",
        "Design LUX first place wins by member (desc)",
      ),
      report(
        "LUX Placements",
        "/statistics/design/lux-placements",
        "Design LUX placements by member (desc)",
      ),
      report(
        "RUX Placements",
        "/statistics/design/rux-placements",
        "Design RUX placements by member (desc)",
      ),
      report(
        "First-time Design Submitters",
        "/statistics/design/first-time-submitters",
        "First-time design submitters in last 3 months",
      ),
      report(
        "Design Countries Represented",
        "/statistics/design/countries-represented",
        "Design submitters by country (desc)",
      ),
      report(
        "Design First Place by Country",
        "/statistics/design/first-place-by-country",
        "Design first place finishes by country (desc)",
      ),
      report(
        "RUX First Place Wins",
        "/statistics/design/rux-first-place-wins",
        "RUX first place design challenge wins by member (desc)",
      ),
      report(
        "Wireframe Wins",
        "/statistics/design/wireframe-wins",
        "Design wireframe challenge wins by member (desc)",
      ),
      report(
        "Development Challenge Wins",
        "/statistics/development/code-wins",
        "Development challenge wins by member (desc)",
      ),
      report(
        "Development First2Finish Wins",
        "/statistics/development/f2f-wins",
        "Development First2Finish wins by member (desc)",
      ),
      report(
        "Prototype Wins",
        "/statistics/development/prototype-wins",
        "Development prototype challenge wins by member (desc)",
      ),
      report(
        "Development First Place Wins",
        "/statistics/development/first-place-wins",
        "Development overall wins by member (desc)",
      ),
      report(
        "First-time Development Submitters",
        "/statistics/development/first-time-submitters",
        "First-time development submitters in last 3 months",
      ),
      report(
        "Development Countries Represented",
        "/statistics/development/countries-represented",
        "Development submitters by country (desc)",
      ),
      report(
        "Development Challenges by Technology",
        "/statistics/development/challenges-technology",
        "Development challenges by standardized skill (desc)",
      ),
      report(
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
      report(
        "Member Count",
        "/topcoder/member-count",
        "Total number of active members",
      ),
      report(
        "Registrant Countries",
        "/topcoder/registrant-countries",
        "Countries of all registrants for the specified challenge",
        [registrantCountriesParam],
      ),
      report(
        "Marathon Match Stats",
        "/topcoder/mm-stats/:handle",
        "Marathon match performance snapshot for a specific handle",
        [marathonMatchHandleParam],
      ),
      report(
        "Total Copilots",
        "/topcoder/total-copilots",
        "Total number of Copilots",
      ),
      report(
        "Weekly Active Copilots",
        "/topcoder/weekly-active-copilots",
        "Weekly challenge and copilot counts by track for the last six months",
      ),
      report(
        "Weekly Member Participation",
        "/topcoder/weekly-member-participation",
        "Weekly distinct registrants and submitters for the last five weeks",
      ),
      report(
        "Member Payment Accrual",
        "/topcoder/member-payment-accrual",
        "Member payment accruals for the provided date range (defaults to last 3 months)",
        [paymentsStartDateParam, paymentsEndDateParam],
      ),
      report(
        "90 Day Member Spend",
        "/topcoder/90-day-member-spend",
        "Total gross amount paid to members in the last 90 days",
      ),
      report(
        "90 Day Members Paid",
        "/topcoder/90-day-members-paid",
        "Total number of distinct members paid in the last 90 days",
      ),
      report(
        "90 Day New Members",
        "/topcoder/90-day-new-members",
        "Total number of new active members created in the last 90 days",
      ),
      report(
        "90 Day Active Copilots",
        "/topcoder/90-day-active-copilots",
        "Total number of distinct copilots active in the last 90 days",
      ),
      report(
        "90 Day User Login",
        "/topcoder/90-day-user-login",
        "Total number of active members who logged in during the last 90 days",
      ),
      report(
        "90 Day Challenge Volume",
        "/topcoder/90-day-challenge-volume",
        "Total number of challenges launched in the last 90 days",
      ),
      report(
        "90 Day Challenge Duration",
        "/topcoder/90-day-challenge-duration",
        "Total duration and count of completed challenges in the last 90 days",
      ),
      report(
        "90 Day Challenge Registrants",
        "/topcoder/90-day-challenge-registrants",
        "Distinct challenge registrants and submitters in the last 90 days",
      ),
      report(
        "90 Day Challenge Submitters",
        "/topcoder/90-day-challenge-submitters",
        "Distinct challenge registrants and submitters in the last 90 days",
      ),
      report(
        "90 Day Challenge Member Cost",
        "/topcoder/90-day-challenge-member-cost",
        "Member payment totals and averages for challenges completed in the last 90 days",
      ),
      report(
        "90 Day Task Member Cost",
        "/topcoder/90-day-task-member-cost",
        "Member payment totals and averages for tasks completed in the last 90 days",
      ),
      report(
        "90 Day Fulfillment",
        "/topcoder/90-day-fulfillment",
        "Share of challenges completed versus cancelled in the last 90 days",
      ),
      report(
        "90 Day Fulfillment With Tasks",
        "/topcoder/90-day-fulfillment-with-tasks",
        "Share of challenges and tasks completed versus cancelled in the last 90 days",
      ),
      report(
        "Weekly Challenge Fulfillment",
        "/topcoder/weekly-challenge-fulfillment",
        "Weekly share of challenges completed versus cancelled for the last four weeks",
      ),
      report(
        "Weekly Challenge Volume",
        "/topcoder/weekly-challenge-volume",
        "Weekly challenge counts by task indicator for the last four weeks",
      ),
      report(
        "90 Day Membership Participation Funnel",
        "/topcoder/90-day-membership-participation-funnel",
        "New member counts with design and development participation indicators for the last 90 days",
      ),
      report(
        "Membership Participation Funnel Data",
        "/topcoder/membership-participation-funnel-data",
        "Weekly new member counts with design and development participation indicators for the last four weeks",
      ),
    ],
  },
};
