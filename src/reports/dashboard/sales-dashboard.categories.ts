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
