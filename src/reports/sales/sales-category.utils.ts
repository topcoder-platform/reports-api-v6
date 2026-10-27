/** Customer types shared by Pipeline and Revenue; legacy "to" inputs remain accepted. */
export const SALES_CUSTOMER_TYPES = [
  "New Customer",
  "New Project at Existing Customer",
  "Extension to Existing Project",
  "Others",
];

/**
 * Normalizes Salesforce categories and the legacy customer-type spelling for exact filtering.
 * @param value Source display label or requested category.
 * @returns Lowercase words with equivalent hyphen/space and to/at spellings. Does not throw.
 */
export function categoryValue(value: string): string {
  return value
    .trim()
    .toLowerCase()
    .replace(/[-\s]+/g, " ")
    .replace(
      /^new project to existing customer$/,
      "new project at existing customer",
    );
}
