import { ApiProperty } from "@nestjs/swagger";
import { Transform } from "class-transformer";
import {
  IsArray,
  IsIn,
  IsOptional,
  IsString,
  IsNotEmpty,
  IsNumber,
  IsDateString,
  IsBoolean,
  IsEnum,
} from "class-validator";
import { transformArray } from "src/common/validation.util";

export enum ChallengesFilterMode {
  BILLING_ACCOUNT = "billingAccount",
  CHALLENGE = "challenge",
}

const transformToNumber = ({ value }: { value: unknown }) => {
  if (value === undefined || value === null || value === "") {
    return undefined;
  }

  const parsed =
    typeof value === "number" ? value : parseFloat(String(value));

  return Number.isNaN(parsed) ? value : parsed;
};

export class ChallengesReportQueryDto {
  @ApiProperty({
    required: false,
    description:
      "List of billing account IDs to use when filterMode is 'billingAccount' (default). Omit this field when filterMode is 'challenge'.",
    example: ["80001012"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  billingAccountIds?: string[];

  @ApiProperty({
    required: false,
    description:
      "List of challenge IDs to use when filterMode is 'challenge'. This field is required in challenge mode and must not be combined with billingAccountIds.",
    example: ["e74c3e37-73c9-474e-a838-a38dd4738906"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  challengeIds?: string[];

  @ApiProperty({
    required: false,
    description:
      "Selects whether to filter primarily by billing account IDs or challenge IDs. Use 'challenge' when providing challengeIds (billingAccountIds are rejected in that mode); defaults to 'billingAccount'.",
    enum: ChallengesFilterMode,
    example: ChallengesFilterMode.BILLING_ACCOUNT,
    default: ChallengesFilterMode.BILLING_ACCOUNT,
  })
  @IsOptional()
  @IsEnum(ChallengesFilterMode)
  filterMode?: ChallengesFilterMode;

  @ApiProperty({
    required: false,
    description: "Challenge name to search for",
    example: "Task Payment for member",
  })
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  challengeName?: string;

  @ApiProperty({
    required: false,
    description:
      "List of challenge statuses using ChallengeStatusEnum values (for example COMPLETED, ACTIVE).",
    example: ["COMPLETED", "ACTIVE"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  challengeStatus?: string[];

  @ApiProperty({
    required: false,
    description:
      "Start date (inclusive) for filtering challenge completion/end date in ISO 8601 format",
    example: "2023-01-01T00:00:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiProperty({
    required: false,
    description:
      "End date (inclusive) for filtering challenge completion/end date in ISO 8601 format",
    example: "2023-01-31T23:59:59.000Z",
  })
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiProperty({
    required: false,
    description:
      'Filter for task challenges using challenges."Challenge"."taskIsTask"',
    example: true,
  })
  @IsOptional()
  @Transform(({ value }) =>
    value === undefined ? undefined : value === true || value === "true",
  )
  @IsBoolean()
  isTask?: boolean;

  @ApiProperty({
    required: false,
    description: "List of member handles",
    example: ["user_01", "user_02"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  handles?: string[];

  @ApiProperty({
    required: false,
    description: "Minimum line item amount for filtering the report",
    example: 100,
  })
  @IsOptional()
  @IsNumber({ allowNaN: false, allowInfinity: false })
  @Transform(transformToNumber)
  minAmount?: number;

  @ApiProperty({
    required: false,
    description: "Maximum line item amount for filtering the report",
    example: 1000,
  })
  @IsOptional()
  @IsNumber({ allowNaN: false, allowInfinity: false })
  @Transform(transformToNumber)
  maxAmount?: number;
}

export class ChallengesReportResponse {
  @ApiProperty({ description: "Challenge identifier" })
  challengeId: string;
  @ApiProperty({ description: "Challenge name" })
  challengeName: string;
  @ApiProperty({ description: "Billing account linked to the challenge" })
  billingAccountId: string;
  @ApiProperty({
    description:
      "Challenge status pulled from challenges.\"Challenge\".status (ChallengeStatusEnum code, not Looker status_desc)",
  })
  challengeStatus: string;
  @ApiProperty({
    description:
      'Challenge completion date returned from challenges."Challenge"."endDate"',
  })
  completeDate: string;
  paymentDate: string;
  @ApiProperty({
    description:
      'Indicates whether the challenge is a task from challenges."Challenge"."taskIsTask"',
  })
  isTask: boolean;
  challengeFee: number;
  memberPayments: number;
  lineItemAmount: number;
  memberHandle: string;
  memberFirstName: string;
  memberLastName: string;
}

export class PaymentsReportQueryDto {
  @ApiProperty({
    required: false,
    description:
      "List of billing account IDs associated with the payments to retrieve",
    example: ["80001012"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  billingAccountIds?: string[];

  @ApiProperty({
    required: false,
    description: "Challenge name to search for",
    example: "Task Payment for member",
  })
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  challengeName?: string;

  @ApiProperty({
    required: false,
    description: "List of challenge IDs",
    example: ["e74c3e37-73c9-474e-a838-a38dd4738906"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  challengeIds?: string[];

  @ApiProperty({
    required: false,
    description: "Start date for the report query in ISO 8601 format",
    example: "2023-01-01T00:00:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiProperty({
    required: false,
    description: "End date for the report query in ISO 8601 format",
    example: "2023-01-31T23:59:59.000Z",
  })
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiProperty({
    required: false,
    description: "List of user handles",
    example: ["user_01", "user_02"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  handles?: string[];

  @ApiProperty({
    required: false,
    description: "Minimum payment amount for filtering the report",
    example: 100,
  })
  @IsOptional()
  @IsNumber({ allowNaN: false, allowInfinity: false })
  @Transform(transformToNumber)
  minPaymentAmount?: number;

  @ApiProperty({
    required: false,
    description: "Maximum payment amount for filtering the report",
    example: 1000,
  })
  @IsOptional()
  @IsNumber({ allowNaN: false, allowInfinity: false })
  @Transform(transformToNumber)
  maxPaymentAmount?: number;

  @ApiProperty({
    required: false,
    description: "List of challenge statuses to filter payments",
    example: ["COMPLETED", "ACTIVE"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  challengeStatus?: string[];
}

export class PaymentsReportResponse {
  billingAccountId: string;
  challengeName: string;
  challengeId: string;
  @ApiProperty({ description: "Winnings category from finance.winnings.category" })
  category: string;
  paymentDate: string;
  paymentId: string;
  paymentStatus: string;
  winnerId: string;
  winnerHandle: string;
  winnerFirstName: string;
  winnerLastName: string;
  isTask: boolean;
  challengeFee: number;
  paymentAmount: number;
  @ApiProperty({ description: "Challenge status from challenges.Challenge.status" })
  challengeStatus: string;
}


export class TaasJobsReportQueryDto {
  @ApiProperty({
    required: false,
    description: "Array of TaaS job UUIDs from taas.jobs.id",
    example: ["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  jobIds?: string[];

  @ApiProperty({
    required: false,
    description: "Array of project IDs from taas.jobs.project_id",
    example: [12345, 67890],
  })
  @IsOptional()
  @IsNumber({ allowNaN: false, allowInfinity: false }, { each: true })
  @Transform(({ value }) =>
    transformArray({ value })?.map((v) => transformToNumber({ value: v })),
  )
  projectIds?: number[];

  @ApiProperty({
    required: false,
    description: "Array of job statuses from taas.jobs.status",
    example: ["open", "assigned"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  status?: string[];

  @ApiProperty({
    required: false,
    description: "Array of resource types from taas.jobs.resource_type",
    example: ["designer", "developer"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  resourceType?: string[];

  @ApiProperty({
    required: false,
    description:
      "Array of skill names to match against the taas.jobs.skills JSONB field",
    example: ["React", "Node.js"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  skills?: string[];

  @ApiProperty({
    required: false,
    description: "Start date (inclusive) for filtering taas.jobs.start_date",
    example: "2023-01-01",
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiProperty({
    required: false,
    description: "End date (inclusive) for filtering taas.jobs.start_date",
    example: "2023-02-01",
  })
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiProperty({
    required: false,
    description: "Minimum number of positions from taas.jobs.num_positions",
    example: 1,
  })
  @IsOptional()
  @IsNumber({ allowNaN: false, allowInfinity: false })
  @Transform(transformToNumber)
  minPositions?: number;

  @ApiProperty({
    required: false,
    description: "Maximum number of positions from taas.jobs.num_positions",
    example: 5,
  })
  @IsOptional()
  @IsNumber({ allowNaN: false, allowInfinity: false })
  @Transform(transformToNumber)
  maxPositions?: number;
}

export class TaasJobsReportResponse {
  @ApiProperty({ description: "TaaS job UUID from taas.jobs.id" })
  jobId: string;
  @ApiProperty({ description: "Project ID from taas.jobs.project_id" })
  projectId: number;
  @ApiProperty({ description: "External identifier from taas.jobs.external_id" })
  externalId: string;
  @ApiProperty({ description: "Job title from taas.jobs.title" })
  title: string;
  @ApiProperty({ description: "Job description from taas.jobs.description" })
  description: string;
  @ApiProperty({ description: "Job status from taas.jobs.status" })
  status: string;
  @ApiProperty({ description: "Resource type from taas.jobs.resource_type" })
  resourceType: string;
  @ApiProperty({ description: "Rate type from taas.jobs.rate_type" })
  rateType: string;
  @ApiProperty({ description: "Skills JSONB payload from taas.jobs.skills" })
  skills: any;
  @ApiProperty({ description: "Number of positions from taas.jobs.num_positions" })
  numPositions: number;
  @ApiProperty({ description: "Start date from taas.jobs.start_date" })
  startDate: string;
  @ApiProperty({ description: "Duration from taas.jobs.duration" })
  duration: number;
  @ApiProperty({ description: "Workload from taas.jobs.workload" })
  workload: string;
  @ApiProperty({ description: "Minimum salary from taas.jobs.min_salary" })
  minSalary: number;
  @ApiProperty({ description: "Maximum salary from taas.jobs.max_salary" })
  maxSalary: number;
  @ApiProperty({ description: "Hours per week from taas.jobs.hours_per_week" })
  hoursPerWeek: number;
  @ApiProperty({ description: "Currency code from taas.jobs.currency" })
  currency: string;
  @ApiProperty({ description: "Record creation timestamp from taas.jobs.created_at" })
  createdAt: string;
  @ApiProperty({ description: "Record update timestamp from taas.jobs.updated_at" })
  updatedAt: string;
}

export class TaasResourceBookingsReportQueryDto {
  @ApiProperty({
    required: false,
    description: "Array of resource booking UUIDs from taas.resource_bookings.id",
    example: ["c2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  resourceBookingIds?: string[];

  @ApiProperty({
    required: false,
    description: "Array of job UUIDs from taas.resource_bookings.job_id",
    example: ["a2bbf3e6-5d5c-4cf8-8c69-89fcd1d98d52"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  jobIds?: string[];

  @ApiProperty({
    required: false,
    description: "Array of project IDs from taas.resource_bookings.project_id",
    example: [12345],
  })
  @IsOptional()
  @IsNumber({ allowNaN: false, allowInfinity: false }, { each: true })
  @Transform(({ value }) =>
    transformArray({ value })?.map((v) => transformToNumber({ value: v })),
  )
  projectIds?: number[];

  @ApiProperty({
    required: false,
    description: "Array of user IDs from taas.resource_bookings.user_id",
    example: ["123456"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  userIds?: string[];

  @ApiProperty({
    required: false,
    description:
      "Array of member handles (case-insensitive) joined via identity.user.handle",
    example: ["user_01", "user_02"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  handles?: string[];

  @ApiProperty({
    required: false,
    description: "Array of booking statuses from taas.resource_bookings.status",
    example: ["placed", "active"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  status?: string[];

  @ApiProperty({
    required: false,
    description: "Array of billing account IDs from taas.resource_bookings.billing_account_id",
    example: ["80001012"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  billingAccountIds?: string[];

  @ApiProperty({
    required: false,
    description: "Start date (inclusive) for filtering taas.resource_bookings.start_date",
    example: "2023-01-01",
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiProperty({
    required: false,
    description: "End date (inclusive) for filtering taas.resource_bookings.end_date",
    example: "2023-02-01",
  })
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiProperty({
    required: false,
    description: "Minimum customer rate from taas.resource_bookings.customer_rate",
    example: 50,
  })
  @IsOptional()
  @IsNumber({ allowNaN: false, allowInfinity: false })
  @Transform(transformToNumber)
  minCustomerRate?: number;

  @ApiProperty({
    required: false,
    description: "Maximum customer rate from taas.resource_bookings.customer_rate",
    example: 150,
  })
  @IsOptional()
  @IsNumber({ allowNaN: false, allowInfinity: false })
  @Transform(transformToNumber)
  maxCustomerRate?: number;
}

export class TaasResourceBookingsReportResponse {
  @ApiProperty({ description: "Resource booking UUID from taas.resource_bookings.id" })
  resourceBookingId: string;
  @ApiProperty({ description: "Job UUID from taas.resource_bookings.job_id" })
  jobId: string;
  @ApiProperty({ description: "Project ID from taas.resource_bookings.project_id" })
  projectId: number;
  @ApiProperty({ description: "User ID from taas.resource_bookings.user_id" })
  userId: string;
  @ApiProperty({ description: "Member handle from identity.user.handle" })
  userHandle: string;
  @ApiProperty({ description: "First name from identity.user.first_name" })
  firstName: string;
  @ApiProperty({ description: "Last name from identity.user.last_name" })
  lastName: string;
  @ApiProperty({ description: "Booking status from taas.resource_bookings.status" })
  status: string;
  @ApiProperty({ description: "Start date from taas.resource_bookings.start_date" })
  startDate: string;
  @ApiProperty({ description: "End date from taas.resource_bookings.end_date" })
  endDate: string;
  @ApiProperty({ description: "Member rate from taas.resource_bookings.member_rate" })
  memberRate: number;
  @ApiProperty({ description: "Customer rate from taas.resource_bookings.customer_rate" })
  customerRate: number;
  @ApiProperty({ description: "Rate type from taas.resource_bookings.rate_type" })
  rateType: string;
  @ApiProperty({
    description: "Billing account ID from taas.resource_bookings.billing_account_id",
  })
  billingAccountId: string;
  @ApiProperty({ description: "Record creation timestamp from taas.resource_bookings.created_at" })
  createdAt: string;
  @ApiProperty({ description: "Record update timestamp from taas.resource_bookings.updated_at" })
  updatedAt: string;
}

export class TaasMemberVerificationReportQueryDto {
  @ApiProperty({
    required: true,
    description:
      "List of member handles to check verification status (case-insensitive)",
    example: ["user1", "user2"],
  })
  @IsNotEmpty()
  @IsString({ each: true })
  @Transform(transformArray)
  handles: string[];
}

export class TaasMemberVerificationReportResponse {
  @ApiProperty({ description: "Member handle from identity.user.handle" })
  handle: string;
  @ApiProperty({ description: "User ID from identity.user.user_id" })
  userId: string;
  @ApiProperty({
    description:
      "Verification flag derived from finance.user_identity_verification_associations.verification_status",
  })
  verified: boolean;
  @ApiProperty({ description: "Derived verification status label" })
  verificationStatus: string;
}

export class WesternUnionPaymentsReportQueryDto {
  @ApiProperty({
    required: false,
    description:
      "Payment status description filter (Looker-style, default: 'Entered into payment system')",
    example: "Entered into payment system",
    default: "Entered into payment system",
  })
  @IsOptional()
  @IsString()
  paymentStatus?: string;

  @ApiProperty({
    required: false,
    description:
      "Payment method filter matched against finance.payment_method name/type (default: 'Western Union')",
    example: "Western Union",
    default: "Western Union",
  })
  @IsOptional()
  @IsString()
  paymentMethod?: string;

  @ApiProperty({
    required: false,
    description: "Start date for filtering payment created_at in ISO 8601 format",
    example: "2023-01-01",
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiProperty({
    required: false,
    description: "End date for filtering payment created_at in ISO 8601 format",
    example: "2023-01-31",
  })
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiProperty({
    required: false,
    description: "Array of member handles to filter payments",
    example: ["user1", "user2"],
  })
  @IsOptional()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  handles?: string[];
}

export class WesternUnionPaymentsReportResponse {
  @ApiProperty({ description: "Payment ID from finance.payment.payment_id" })
  paymentId: string;
  @ApiProperty({ description: "Member handle from identity.user.handle" })
  handle: string;
  @ApiProperty({ description: "Gross amount from finance.payment.gross_amount" })
  grossAmount: number;
  @ApiProperty({
    description: "Reference ID from finance.winnings.external_id (challenge reference)",
  })
  referenceId: string;
  @ApiProperty({
    description: "Payment description from finance.winnings.title/description",
  })
  description: string;
  @ApiProperty({
    description:
      "Payment status description mapped from finance.payment.payment_status",
  })
  paymentStatus: string;
  @ApiProperty({ description: "Payment date from finance.payment.created_at" })
  paymentDate: string;
}

export class BaFeesReportQueryDto {
  @ApiProperty({
    required: false,
    description:
      "Array of billing account IDs to include or exclude (prefix with ! to exclude). Use exclusion to drop Topgear data when you want to mirror the Salesforce importTopgearData() behavior (for example !<TopgearBAId>).",
    example: ["12345", "!67890"],
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @Transform(transformArray)
  billingAccountIds?: string[];

  @ApiProperty({
    required: false,
    description:
      "Start date for the report query in ISO 8601 format (inclusive). If omitted the report uses an open-ended lower bound.",
    example: "2023-01-01T00:00:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiProperty({
    required: false,
    description: "End date for the report query in ISO 8601 format",
    example: "2023-01-31T23:59:59.000Z",
  })
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiProperty({
    required: false,
    description: "Aggregation level for the report",
    enum: ["total", "month"],
    example: "month",
    default: "total",
  })
  @IsOptional()
  @IsIn(["total", "month"])
  groupBy?: "total" | "month";
}

export class BaFeesReportResponse {
  @ApiProperty({
    description: "Billing account identifier returned from finance.payment.billing_account",
    example: "80001012",
  })
  billingAccountId: string;

  @ApiProperty({
    description:
      "Total challenge fees summed from finance.payment.challenge_fee for the filtered billing account",
    example: 1200.5,
  })
  totalFees: number;

  @ApiProperty({
    description:
      "Total member payments summed from finance.payment.total_amount for the filtered billing account",
    example: 980.75,
  })
  totalMemberPayments: number;

  @ApiProperty({
    description:
      "Most recent payment status for the billing account derived from finance.payment.payment_status (values include Entered into payment system, On hold, On hold - admin, Owed, Paid, Cancelled, Failed, Returned, or the raw payment_status code)",
    example: "Paid",
  })
  currentPaymentStatus: string;

  @ApiProperty({
    required: false,
    description: "Month bucket (YYYY-MM) when groupBy is set to month",
    example: "2024-01",
  })
  month?: string;

  @ApiProperty({
    required: false,
    description: "Number of payments contributing to the bucket when groupBy=month",
    example: 42,
  })
  paymentCount?: number;

  @ApiProperty({
    required: false,
    description: "Earliest payment date in the bucket when groupBy=month",
    example: "2024-01-02",
  })
  earliestPaymentDate?: string;

  @ApiProperty({
    required: false,
    description: "Latest payment date in the bucket when groupBy=month",
    example: "2024-01-31",
  })
  latestPaymentDate?: string;
}
