export function parseOptionalDate(input?: string | null): Date | undefined {
  if (!input) return undefined;
  const d = new Date(input);
  return isNaN(d.getTime()) ? undefined : d;
}

export function defaultStartDate(): Date {
  return new Date("2005-01-01T00:00:00Z");
}

export function defaultEndDate(): Date {
  return new Date(); // now
}

export function transformArray({ value }: { value: unknown }) {
  if (value === undefined || value === null) return undefined;

  const splitIfString = (v: unknown) => {
    if (typeof v === "string") {
      return v
        .split(",")
        .map((token) => token.trim())
        .filter((token) => token !== "");
    }
    return [v];
  };

  return Array.isArray(value) ? value.flatMap(splitIfString) : splitIfString(value);
}
