import countryUtil from "i18n-iso-countries";

// eslint-disable-next-line @typescript-eslint/no-var-requires
const enLocale = require("i18n-iso-countries/langs/en.json");

countryUtil.registerLocale(enLocale);

export function alpha3ToCountryName(code?: string | null): string | null {
  if (!code) {
    return null;
  }
  const trimmed = String(code).trim();
  if (!trimmed) {
    return null;
  }
  const upper = trimmed.toUpperCase();
  return countryUtil.getName(upper, "en") || null;
}
