export class CsvSerializer {
  serialize(data: unknown): string {
    if (data === null || data === undefined) {
      return "";
    }

    if (Array.isArray(data)) {
      return this.serializeArray(data);
    }

    if (this.isRecord(data)) {
      return this.serializeObject(data);
    }

    return this.normalizeValue(data);
  }

  private serializeArray(values: unknown[]): string {
    if (values.length === 0) {
      return "";
    }

    if (values.every((value) => this.isRecord(value))) {
      return this.serializeRecords(values);
    }

    const header = ["value"];
    const rows = values.map((value) => [this.normalizeValue(value)]);
    return this.buildCsv(header, rows);
  }

  private serializeObject(value: Record<string, unknown>): string {
    const columns = Object.keys(value);
    if (columns.length === 0) {
      return "";
    }

    const rows = [columns.map((column) => this.normalizeValue(value[column]))];
    return this.buildCsv(columns, rows);
  }

  private serializeRecords(records: Record<string, unknown>[]): string {
    const columns = this.collectColumns(records);
    if (columns.length === 0) {
      return "";
    }

    const rows = records.map((record) =>
      columns.map((column) => this.normalizeValue(record[column])),
    );

    return this.buildCsv(columns, rows);
  }

  private buildCsv(header: string[], rows: string[][]): string {
    const lines = [
      this.serializeRow(header),
      ...rows.map((row) => this.serializeRow(row)),
    ];

    return lines.join("\n");
  }

  private serializeRow(values: string[]): string {
    return values.map((value) => this.escapeCsvCell(value)).join(",");
  }

  private collectColumns(records: Record<string, unknown>[]) {
    const seen = new Set<string>();
    const columns: string[] = [];

    for (const record of records) {
      for (const key of Object.keys(record)) {
        if (!seen.has(key)) {
          seen.add(key);
          columns.push(key);
        }
      }
    }

    return columns;
  }

  private normalizeValue(value: unknown): string {
    if (value === null || value === undefined) {
      return "";
    }

    if (value instanceof Date) {
      return value.toISOString();
    }

    if (Array.isArray(value)) {
      return JSON.stringify(value);
    }

    if (this.isRecord(value)) {
      return JSON.stringify(value);
    }

    if (typeof value === "string") {
      return value;
    }

    if (
      typeof value === "number" ||
      typeof value === "boolean" ||
      typeof value === "bigint"
    ) {
      return value.toString();
    }

    if (typeof value === "symbol") {
      return value.toString();
    }

    return "";
  }

  private escapeCsvCell(value: string): string {
    if (value === "") {
      return "";
    }

    if (!/[",\r\n]/.test(value)) {
      return value;
    }

    const escaped = value.replace(/"/g, '""');
    return `"${escaped}"`;
  }

  private isRecord(value: unknown): value is Record<string, unknown> {
    return typeof value === "object" && value !== null && !Array.isArray(value);
  }
}
