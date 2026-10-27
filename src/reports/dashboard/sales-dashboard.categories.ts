import { BadRequestException } from "@nestjs/common";
import {
  categoryValue,
  SALES_CUSTOMER_TYPES,
} from "../sales/sales-category.utils";
import { SalesReportDto, SalesRowDto } from "../sales/sales-reports.dto";

/** Business category labels shared by the pipeline and recognized-booking reports. */
export const CATEGORY_LABELS = {
  offering: /^(?:engagement )?offering type$/i,
  deal: /^deal category$/i,
  customer: /^(?:new customer,? or follow[- ]on business\??|customer type)$/i,
  project: /^opportunity\/project name$/i,
};

/**
 * Resolves a category from report metadata, ignoring a Salesforce relationship prefix.
 * @param report Normalized snapshot with org-specific field IDs.
 * @param label Business label to match, e.g. Engagement Offering Type.
 * @returns Cell index, or -1 if the report does not expose the field. Does not throw.
 */
export function categoryColumn(report: SalesReportDto, label: RegExp): number {
  return report.columns.findIndex((c) =>
    label.test(c.label?.split(":").pop()?.trim() ?? ""),
  );
}

/**
 * Reads a usable Salesforce category without treating placeholder labels as categories.
 * @param row Source detail row.
 * @param index Category cell index.
 * @returns Trimmed label, or an empty string for a missing value. Does not throw.
 */
export function categoryLabel(row: SalesRowDto, index: number): string {
  const cell = row.cells[index];
  if (cell?.value == null) return "";
  const label = cell.label?.trim() || String(cell.value).trim();
  return /^(?:-|—|\(blank\))$/.test(label) ? "" : label;
}

/**
 * Applies PM-6667's two source-data corrections only when the offering is blank.
 * @param row Recognized-booking detail row.
 * @param offeringIndex Engagement Offering Type index.
 * @param projectIndex Opportunity/Project Name index, if available.
 * @returns Offering category, or Unknown; populated source values always win. Does not throw.
 */
export function offeringLabel(
  row: SalesRowDto,
  offeringIndex: number,
  projectIndex: number,
): string {
  const offering = categoryLabel(row, offeringIndex);
  if (offering) return offering;
  const project = categoryLabel(row, projectIndex);
  if (/^topgear$/i.test(project)) return "TopGear Ops";
  if (/^multiple app enhancements? 5$/i.test(project)) return "Flexible Talent";
  return "Unknown";
}

/**
 * Filters raw rows before monthly aggregation while retaining the complete set of filter choices.
 * @param report Unfiltered source snapshot, bounded to the reporting period by the caller.
 * @param filters Exact values; OR within each category and AND between categories.
 * @param overrides Explicit revenue field IDs; missing configured fields do not fall back.
 * @param revenue Applies revenue offering corrections before offering matching.
 * @returns A shallow snapshot containing matching rows, plus canonical source choices.
 * @throws BadRequestException if a selected category is absent from the source.
 */
export function filterDashboardCategories(
  report: SalesReportDto,
  filters: Partial<
    Record<"offeringType" | "dealCategory" | "customerType", string[]>
  >,
  overrides: Partial<
    Record<"offeringType" | "dealCategory" | "customerType", string>
  > = {},
  revenue = false,
): {
  report: SalesReportDto;
  options: {
    offeringType: string[];
    dealCategory: string[];
    customerType: string[];
  };
} {
  const definitions = [
    { key: "offeringType", pattern: CATEGORY_LABELS.offering },
    { key: "dealCategory", pattern: CATEGORY_LABELS.deal },
    { key: "customerType", pattern: CATEGORY_LABELS.customer },
  ] as const;
  const options = {
    offeringType: [] as string[],
    dealCategory: [] as string[],
    customerType: [] as string[],
  };
  const projectIndex = categoryColumn(report, CATEGORY_LABELS.project);
  const fields = definitions.map(({ key, pattern }) => {
    const index = overrides[key]
      ? report.columns.findIndex((column) => column.id === overrides[key])
      : categoryColumn(report, pattern);
    const selected = (filters[key] ?? []).map(categoryValue);
    if (index < 0 && selected.length)
      throw new BadRequestException(
        `The report does not provide the ${key} column.`,
      );
    const label = (row: SalesRowDto): string => {
      const value =
        revenue && key === "offeringType"
          ? offeringLabel(row, index, projectIndex)
          : categoryLabel(row, index);
      return categoryValue(value) === "new project at existing customer"
        ? "New Project at Existing Customer"
        : value || "Unknown";
    };
    options[key] =
      index < 0
        ? []
        : key === "customerType"
          ? [...SALES_CUSTOMER_TYPES]
          : [...new Set(report.rows.map(label))].sort();
    return { selected, label };
  });
  return {
    report: {
      ...report,
      rows: report.rows.filter((row) =>
        fields.every(
          ({ selected, label }) =>
            !selected.length || selected.includes(categoryValue(label(row))),
        ),
      ),
    },
    options,
  };
}
