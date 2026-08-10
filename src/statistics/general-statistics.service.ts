import { Injectable } from "@nestjs/common";
import { DbService } from "../db/db.service";
import { SqlLoaderService } from "../common/sql-loader.service";
import { alpha3ToCountryName } from "../common/country.util";

type CountryMember = {
  handle: string;
  maxRating: number | null;
  photoURL: string | null;
  wins: number;
};

type CountryMemberDetailRow = {
  country_code: string | null;
  "user.count": number | string | null;
  skills: Array<{
    count?: number | string | null;
    name?: string | null;
  }> | null;
  top_member: {
    handle?: string | null;
    maxRating?: number | string | null;
    photoURL?: string | null;
    wins?: number | string | null;
  } | null;
};

@Injectable()
export class GeneralStatisticsService {
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getMemberCount() {
    const q = this.sql.load("reports/statistics/general/member-count.sql");
    const rows = await this.db.query<{ count: string }>(q);
    const count = rows?.[0]?.count ? Number(rows[0].count) : 0;
    return { "user.count": count };
  }

  async getTotalPrizes() {
    const q = this.sql.load("reports/statistics/general/total-prizes.sql");
    const rows = await this.db.query<{ total: string }>(q);
    const total = rows?.[0]?.total ? rows[0].total : "0";
    return { total };
  }

  async getCompletedChallengesCount() {
    const q = this.sql.load(
      "reports/statistics/general/completed-challenges.sql",
    );
    const rows = await this.db.query<{ count: string }>(q);
    const count = rows?.[0]?.count ? Number(rows[0].count) : 0;
    return { "challenge.count": count };
  }

  async getCountriesRepresented() {
    const q = this.sql.load(
      "reports/statistics/general/countries-represented.sql",
    );
    const rows = await this.db.query<{
      country_code: string | null;
      "user.count": number | string | null;
      rank: number | string | null;
    }>(q);
    return rows.map((row) => {
      const countryName =
        alpha3ToCountryName(row.country_code) ?? row.country_code ?? "";
      return {
        "country.country_name": countryName,
        "user.count": Number(row["user.count"] ?? 0),
        rank:
          row.rank !== null && row.rank !== undefined ? Number(row.rank) : null,
      };
    });
  }

  async getCountryMemberDetails() {
    const q = this.sql.load(
      "reports/statistics/general/country-member-details.sql",
    );
    const rows = await this.db.query<CountryMemberDetailRow>(q);
    const countries = new Map<
      string,
      {
        countryCode: string | null;
        memberCount: number;
        skills: Map<string, { count: number; name: string }>;
        topMember: CountryMember | null;
      }
    >();

    rows.forEach((row) => {
      const countryName =
        alpha3ToCountryName(row.country_code) ?? row.country_code ?? "";
      const current = countries.get(countryName) ?? {
        countryCode: row.country_code,
        memberCount: 0,
        skills: new Map<string, { count: number; name: string }>(),
        topMember: null,
      };
      const candidate = row.top_member
        ? {
            handle: String(row.top_member.handle ?? ""),
            maxRating:
              row.top_member.maxRating !== null &&
              row.top_member.maxRating !== undefined
                ? Number(row.top_member.maxRating)
                : null,
            photoURL: row.top_member.photoURL ?? null,
            wins: Number(row.top_member.wins ?? 0),
          }
        : null;

      current.memberCount += Number(row["user.count"] ?? 0);
      (Array.isArray(row.skills) ? row.skills : []).forEach((skill) => {
        const name = String(skill.name ?? "").trim();
        const count = Number(skill.count ?? 0);
        if (!name || !Number.isFinite(count) || count <= 0) {
          return;
        }

        const key = name.toLowerCase();
        const existing = current.skills.get(key);
        current.skills.set(key, {
          count: (existing?.count ?? 0) + count,
          name: existing?.name ?? name,
        });
      });
      if (
        candidate &&
        (!current.topMember ||
          candidate.wins > current.topMember.wins ||
          (candidate.wins === current.topMember.wins &&
            candidate.handle.localeCompare(current.topMember.handle) < 0))
      ) {
        current.topMember = candidate;
      }
      countries.set(countryName, current);
    });

    const mergedCountries = Array.from(countries.entries()).sort(
      ([nameA, countryA], [nameB, countryB]) =>
        countryB.memberCount - countryA.memberCount ||
        nameA.localeCompare(nameB),
    );
    let rank = 0;
    let previousCount: number | undefined;

    return mergedCountries.map(([countryName, country]) => {
      if (country.memberCount !== previousCount) {
        rank += 1;
        previousCount = country.memberCount;
      }
      const skills = Array.from(country.skills.values()).sort(
        (skillA, skillB) =>
          skillB.count - skillA.count || skillA.name.localeCompare(skillB.name),
      );

      return {
        "country.country_name": countryName,
        "country.country_code": country.countryCode,
        "user.count": country.memberCount,
        rank,
        skillAssignments: skills.reduce(
          (total, skill) => total + skill.count,
          0,
        ),
        topMember: country.topMember,
        topSkills: skills.slice(0, 3),
        totalSkills: skills.length,
      };
    });
  }

  async getFirstPlaceByCountry() {
    const q = this.sql.load(
      "reports/statistics/general/first-place-by-country.sql",
    );
    const rows = await this.db.query<{
      country_code: string | null;
      "challenge_stats.count": number | string | null;
      rank: number | string | null;
    }>(q);
    return rows.map((row) => {
      const countryName =
        alpha3ToCountryName(row.country_code) ?? row.country_code ?? "";
      return {
        "country.country_name": countryName,
        "challenge_stats.count": Number(row["challenge_stats.count"] ?? 0),
        rank:
          row.rank !== null && row.rank !== undefined ? Number(row.rank) : null,
      };
    });
  }

  async getTopWinnersByCountry() {
    const q = this.sql.load(
      "reports/statistics/general/top-winners-by-country.sql",
    );
    const rows = await this.db.query<{
      country_code: string | null;
      "challenge_stats.count": number | string | null;
      rank: number | string | null;
      top_winners: Array<{
        handle?: string | null;
        maxRating?: number | string | null;
        photoURL?: string | null;
        wins?: number | string | null;
      }> | null;
    }>(q);

    return rows.map((row) => {
      const countryName =
        alpha3ToCountryName(row.country_code) ?? row.country_code ?? "";
      const topWinners = Array.isArray(row.top_winners)
        ? row.top_winners.map((winner) => ({
            handle: String(winner.handle ?? ""),
            maxRating:
              winner.maxRating !== null && winner.maxRating !== undefined
                ? Number(winner.maxRating)
                : null,
            photoURL: winner.photoURL ?? null,
            wins: Number(winner.wins ?? 0),
          }))
        : [];

      return {
        "country.country_name": countryName,
        "challenge_stats.count": Number(row["challenge_stats.count"] ?? 0),
        rank:
          row.rank !== null && row.rank !== undefined ? Number(row.rank) : null,
        topWinners,
      };
    });
  }

  async getCopilotedChallenges() {
    const q = this.sql.load(
      "reports/statistics/general/copiloted-challenges.sql",
    );
    return this.db.query(q);
  }

  async getReviewCountsByMember() {
    const q = this.sql.load("reports/statistics/general/reviews-by-member.sql");
    return this.db.query(q);
  }
}
