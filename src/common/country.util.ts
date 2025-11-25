import * as countriesModule from "i18n-iso-countries";
import { createRequire } from "node:module";
import enLocaleJson from "i18n-iso-countries/langs/en.json";

type LocaleData = { locale: string; countries: Record<string, string> };

const cjsRequire = createRequire(__filename);

// Handle JSON default/non-default shapes across module systems, with a CJS fallback.
const enLocale: LocaleData =
  (enLocaleJson as { default?: LocaleData } | undefined)?.default ??
  (enLocaleJson as LocaleData | undefined) ??
  (cjsRequire("i18n-iso-countries/langs/en.json") as LocaleData);

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
