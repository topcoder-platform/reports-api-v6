export const Scopes = {
  TopgearHourly: "reports:topgear-hourly",
  TopgearHandles: "reports:topgear-handles",
  TopgearPayments: "reports:topgear-payments",
  TopgearChallenge: "reports:topgear-challenge",
  TopgearCancelledChallenge: "reports:topgear-cancelled-challenge",
  AllReports: "reports:all",
  TopcoderReports: "reports:topcoder",
  TopgearChallengeTechnology: "reports:topgear-challenge-technology",
  TopgearChallengeStatsByUser: "reports:topgear-challenge-stats-by-user",
  TopgearChallengeRegistrantDetails:
    "reports:topgear-challenge-registrant-details",
  SFDC: {
    PaymentsReport: "reports:sfdc-payments",
    ChallengesReport: "reports:sfdc-challenges-report",
    BA: "reports:sfdc-ba",
    TaasJobs: "reports:sfdc-taas-jobs",
    TaasResourceBookings: "reports:sfdc-taas-resource-bookings",
    TaasMemberVerification: "reports:sfdc-taas-member-verification",
    WesternUnionPayments: "reports:sfdc-western-union-payments",
  },
  Challenge: {
    History: "reports:challenge-history",
    Registrants: "reports:challenge-registrants",
    SubmissionLinks: "reports:challenge-submission-links",
    RegisteredUsers: "reports:challenge-registered-users",
    Submitters: "reports:challenge-submitters",
    ValidSubmitters: "reports:challenge-valid-submitters",
    Winners: "reports:challenge-winners",
  },
  Identity: {
    UsersByRole: "reports:identity-users-by-role",
    UsersByGroup: "reports:identity-users-by-group",
    UsersByHandles: "reports:identity-users-by-handles",
  },
};

export const AdminRoles = {
  Admin: "Administrator",
};

export const UserRoles = {
  TalentManager: "Talent Manager",
};

export const ScopeRoleAccess: Record<string, readonly string[]> = {
  [Scopes.Identity.UsersByHandles]: ["Talent Manager", "Project Manager"],
};
