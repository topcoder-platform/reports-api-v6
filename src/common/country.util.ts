import * as countriesModule from "i18n-iso-countries";

const enLocale = require("i18n-iso-countries/langs/en.json");

// Handle environments where the module might be exposed on either the module
// object itself or under a `default` export.
const countryUtil =
  (countriesModule as unknown as { default?: typeof countriesModule })
    .default ?? countriesModule;

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
