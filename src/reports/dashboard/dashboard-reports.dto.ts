import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { IsDateString, IsOptional } from "class-validator";

/**
 * Public identifiers used to select a dashboard report.
 */
export enum DashboardSlug {
  NewSignups = "new-signups",
  MembersPaid = "members-paid",
  ChallengeParticipation = "challenge-participation",
  MemberPaymentByMonth = "member-payment-by-month",
  MemberPaymentByCustomer = "member-payment-by-customer",
}

/**
 * Optional half-open UTC date range applied to dashboard month data.
 *
 * When both values are omitted, the API returns the latest six calendar
 * months, including the current month.
 */
export class DashboardQueryDto {
  @ApiPropertyOptional({
    description:
      "Inclusive ISO-8601 reporting range start. Defaults to the first instant of the oldest month in the latest six-calendar-month window.",
    example: "2026-02-01T00:00:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({
    description:
      "Exclusive ISO-8601 reporting range end. Defaults to the first instant of the month following the current month.",
    example: "2026-08-01T00:00:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  endDate?: string;
}

/**
 * One month of member signup counts split by current activation state.
 */
export class NewSignupsMonthDto {
  @ApiProperty({ example: "2026-02-01" })
  month: string;

  @ApiProperty({ example: 13247 })
  activated: number;

  @ApiProperty({ example: 4967 })
  notActivated: number;
}

/**
 * All-time member signup metrics shown beside the signup chart.
 */
export class NewSignupsSummaryDto {
  @ApiProperty({ example: 18214 })
  totalSignups: number;

  @ApiProperty({ example: 13247 })
  activatedMembers: number;

  @ApiProperty({ example: 4967 })
  notActivatedMembers: number;

  @ApiProperty({
    description: "All-time activated-member percentage from 0 through 100.",
    example: 72.7,
  })
  activationRate: number;

  @ApiProperty({
    nullable: true,
    example: "2024-04-01",
  })
  peakMonth: string | null;

  @ApiProperty({ example: 4423 })
  peakMonthSignups: number;
}

/**
 * Monthly signup dashboard response used by landing and detail views.
 */
export class NewSignupsDashboardDto {
  @ApiProperty({
    enum: [DashboardSlug.NewSignups],
    example: DashboardSlug.NewSignups,
  })
  dashboard: DashboardSlug.NewSignups;

  @ApiProperty({ example: "2026-02-01T00:00:00.000Z" })
  startDate: string;

  @ApiProperty({
    description: "Exclusive reporting range end.",
    example: "2026-08-01T00:00:00.000Z",
  })
  endDate: string;

  @ApiProperty({ type: [NewSignupsMonthDto] })
  months: NewSignupsMonthDto[];

  @ApiProperty({ type: NewSignupsSummaryDto })
  summary: NewSignupsSummaryDto;
}

/**
 * One month of unique paid-member counts split by canonical payment type.
 */
export class MembersPaidMonthDto {
  @ApiProperty({ example: "2026-02-01" })
  month: string;

  @ApiProperty({ example: 438 })
  taas: number;

  @ApiProperty({ example: 812 })
  task: number;

  @ApiProperty({ example: 1294 })
  challenge: number;

  @ApiProperty({ example: 376 })
  engagement: number;
}

/**
 * All-time unique paid-member metrics shown beside the payments chart.
 */
export class MembersPaidSummaryDto {
  @ApiProperty({ example: 19234 })
  totalUniqueMembers: number;

  @ApiProperty({ example: 2481 })
  taasUniqueMembers: number;

  @ApiProperty({ example: 6792 })
  taskUniqueMembers: number;

  @ApiProperty({ example: 14226 })
  challengeUniqueMembers: number;

  @ApiProperty({ example: 3154 })
  engagementUniqueMembers: number;

  @ApiProperty({ nullable: true, example: "2025-11-01" })
  peakMonth: string | null;

  @ApiProperty({ example: 3812 })
  peakMonthUniqueMembers: number;
}

/**
 * Monthly unique-paid-members dashboard response.
 */
export class MembersPaidDashboardDto {
  @ApiProperty({
    enum: [DashboardSlug.MembersPaid],
    example: DashboardSlug.MembersPaid,
  })
  dashboard: DashboardSlug.MembersPaid;

  @ApiProperty({ example: "2026-02-01T00:00:00.000Z" })
  startDate: string;

  @ApiProperty({
    description: "Exclusive reporting range end.",
    example: "2026-08-01T00:00:00.000Z",
  })
  endDate: string;

  @ApiProperty({ type: [MembersPaidMonthDto] })
  months: MembersPaidMonthDto[];

  @ApiProperty({ type: MembersPaidSummaryDto })
  summary: MembersPaidSummaryDto;
}

/**
 * One month of unique challenge registration and submission activity.
 */
export class ChallengeParticipationMonthDto {
  @ApiProperty({ example: "2026-02-01" })
  month: string;

  @ApiProperty({ example: 13292 })
  registrants: number;

  @ApiProperty({ example: 10148 })
  submitters: number;
}

/**
 * All-time challenge participation metrics shown beside the chart.
 */
export class ChallengeParticipationSummaryDto {
  @ApiProperty({ example: 214568 })
  totalUniqueRegistrants: number;

  @ApiProperty({ example: 146329 })
  totalUniqueSubmitters: number;

  @ApiProperty({
    description:
      "All-time unique submitters divided by unique registrants, expressed as a percentage from 0 through 100.",
    example: 68.2,
  })
  submissionRate: number;

  @ApiProperty({ nullable: true, example: "2025-10-01" })
  peakMonth: string | null;

  @ApiProperty({ example: 22431 })
  peakMonthRegistrants: number;
}

/**
 * Monthly challenge-participation dashboard response.
 */
export class ChallengeParticipationDashboardDto {
  @ApiProperty({
    enum: [DashboardSlug.ChallengeParticipation],
    example: DashboardSlug.ChallengeParticipation,
  })
  dashboard: DashboardSlug.ChallengeParticipation;

  @ApiProperty({ example: "2026-02-01T00:00:00.000Z" })
  startDate: string;

  @ApiProperty({
    description: "Exclusive reporting range end.",
    example: "2026-08-01T00:00:00.000Z",
  })
  endDate: string;

  @ApiProperty({ type: [ChallengeParticipationMonthDto] })
  months: ChallengeParticipationMonthDto[];

  @ApiProperty({ type: ChallengeParticipationSummaryDto })
  summary: ChallengeParticipationSummaryDto;
}

/**
 * One month of member-payment values split by canonical payment type.
 */
export class MemberPaymentMonthDto {
  @ApiProperty({ example: "2026-02-01" })
  month: string;

  @ApiProperty({ example: 185250.5 })
  taas: number;

  @ApiProperty({ example: 92340 })
  task: number;

  @ApiProperty({ example: 246100.75 })
  challenge: number;

  @ApiProperty({ example: 63400 })
  engagement: number;
}

/**
 * Monthly member-payment values split by canonical payment type.
 */
export class MemberPaymentByMonthDashboardDto {
  @ApiProperty({
    enum: [DashboardSlug.MemberPaymentByMonth],
    example: DashboardSlug.MemberPaymentByMonth,
  })
  dashboard: DashboardSlug.MemberPaymentByMonth;

  @ApiProperty({ example: "2026-02-01T00:00:00.000Z" })
  startDate: string;

  @ApiProperty({
    description: "Exclusive reporting range end.",
    example: "2026-08-01T00:00:00.000Z",
  })
  endDate: string;

  @ApiProperty({ type: [MemberPaymentMonthDto] })
  months: MemberPaymentMonthDto[];
}

/**
 * One customer series used by the monthly member-payment chart.
 */
export class MemberPaymentCustomerSeriesDto {
  @ApiProperty({
    description: "Stable API-generated key used in each month's values map.",
    example: "customer-client-123",
  })
  key: string;

  @ApiProperty({ example: "Example Customer" })
  label: string;

  @ApiProperty({
    nullable: true,
    description:
      "Billing-account client identifier, or null for Other Customers.",
    example: "client-123",
  })
  customerId: string | null;
}

/**
 * One month of member-payment values keyed by customer-series key.
 */
export class MemberPaymentByCustomerMonthDto {
  @ApiProperty({ example: "2026-02-01" })
  month: string;

  @ApiProperty({
    type: "object",
    additionalProperties: { type: "number" },
    example: {
      "customer-client-123": 185250.5,
      "other-customers": 92340,
    },
  })
  values: Record<string, number>;
}

/**
 * Monthly member-payment values split by the range's top customers.
 */
export class MemberPaymentByCustomerDashboardDto {
  @ApiProperty({
    enum: [DashboardSlug.MemberPaymentByCustomer],
    example: DashboardSlug.MemberPaymentByCustomer,
  })
  dashboard: DashboardSlug.MemberPaymentByCustomer;

  @ApiProperty({ example: "2026-02-01T00:00:00.000Z" })
  startDate: string;

  @ApiProperty({
    description: "Exclusive reporting range end.",
    example: "2026-08-01T00:00:00.000Z",
  })
  endDate: string;

  @ApiProperty({ type: [MemberPaymentCustomerSeriesDto] })
  series: MemberPaymentCustomerSeriesDto[];

  @ApiProperty({ type: [MemberPaymentByCustomerMonthDto] })
  months: MemberPaymentByCustomerMonthDto[];
}

/**
 * Aggregate landing-page response containing all five full dashboards.
 */
export class AllDashboardsDto {
  @ApiProperty({ type: NewSignupsDashboardDto })
  newSignups: NewSignupsDashboardDto;

  @ApiProperty({ type: MembersPaidDashboardDto })
  membersPaid: MembersPaidDashboardDto;

  @ApiProperty({ type: ChallengeParticipationDashboardDto })
  challengeParticipation: ChallengeParticipationDashboardDto;

  @ApiProperty({ type: MemberPaymentByMonthDashboardDto })
  memberPaymentByMonth: MemberPaymentByMonthDashboardDto;

  @ApiProperty({ type: MemberPaymentByCustomerDashboardDto })
  memberPaymentByCustomer: MemberPaymentByCustomerDashboardDto;
}

/**
 * Flat monthly row returned by all-dashboard CSV exports.
 *
 * Metric columns that do not apply to the row's dashboard are omitted before
 * CSV serialization.
 */
export class DashboardExportRowDto {
  @ApiProperty({ enum: DashboardSlug })
  dashboard: DashboardSlug;

  @ApiProperty({ example: "2026-02-01" })
  month: string;

  @ApiPropertyOptional()
  activated?: number;

  @ApiPropertyOptional()
  notActivated?: number;

  @ApiPropertyOptional()
  taas?: number;

  @ApiPropertyOptional()
  task?: number;

  @ApiPropertyOptional()
  challenge?: number;

  @ApiPropertyOptional()
  engagement?: number;

  @ApiPropertyOptional()
  registrants?: number;

  @ApiPropertyOptional()
  submitters?: number;

  @ApiPropertyOptional()
  customer?: string;

  @ApiPropertyOptional()
  amount?: number;
}

/**
 * Full response returned by a dashboard detail endpoint.
 */
export type DashboardResponse =
  | NewSignupsDashboardDto
  | MembersPaidDashboardDto
  | ChallengeParticipationDashboardDto
  | MemberPaymentByMonthDashboardDto
  | MemberPaymentByCustomerDashboardDto;
