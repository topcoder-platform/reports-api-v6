const CHALLENGE_STATUS_LABELS: Record<string, string> = {
  NEW: "New",
  DRAFT: "Draft",
  APPROVED: "Approved",
  ACTIVE: "Active",
  COMPLETED: "Completed",
  DELETED: "Deleted",
  CANCELLED: "Cancelled",
  CANCELLED_FAILED_REVIEW: "Cancelled - Failed Review",
  CANCELLED_FAILED_SCREENING: "Cancelled - Failed Screening",
  CANCELLED_ZERO_SUBMISSIONS: "Cancelled - Zero Submissions",
  CANCELLED_WINNER_UNRESPONSIVE: "Cancelled - Winner Unresponsive",
  CANCELLED_CLIENT_REQUEST: "Cancelled - Client Request",
  CANCELLED_REQUIREMENTS_INFEASIBLE: "Cancelled - Requirements Infeasible",
  CANCELLED_ZERO_REGISTRATIONS: "Cancelled - Zero Registrations",
  CANCELLED_PAYMENT_FAILED: "Cancelled - Payment Failed",
};

export const normalizeChallengeStatus = (
  status: string | null | undefined,
): string | null | undefined => {
  if (status === null || status === undefined) return status;
  const trimmed = String(status).trim();
  if (!trimmed) return status;
  const normalized = CHALLENGE_STATUS_LABELS[trimmed.toUpperCase()];

  return normalized ?? status;
};
