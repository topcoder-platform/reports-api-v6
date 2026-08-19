import { Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
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
    ownedCount?: number | string | null;
  }> | null;
  top_members: Array<{
    handle?: string | null;
    maxRating?: number | string | null;
    photoURL?: string | null;
    wins?: number | string | null;
  }> | null;
};

@Injectable()
export class GeneralStatisticsService {
  private readonly excludedChallengeTypes: string[];

  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
    private readonly config: ConfigService,
  ) {
    this.excludedChallengeTypes = this.parseExcludedChallengeTypes();
  }

  private parseExcludedChallengeTypes(): string[] {
    const raw = this.config
      .get<string>(
        "REPORTS_EXCLUDED_CHALLENGE_TYPES",
        '["Task","First2Finish"]',
      )
      .trim();

    if (!raw) {
      return [];
    }

    try {
      const parsed = JSON.parse(raw);
      if (Array.isArray(parsed)) {
        return parsed
          .filter((item) => typeof item === "string" && item.trim())
          .map((item) => item.trim());
      }
    } catch {
      // ignore JSON parse failure and fall back to comma-separated values
    }

    return raw
      .split(",")
      .map((item) => item.trim())
      .filter(Boolean);
  }

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
    const rows = await this.db.query<CountryMemberDetailRow>(q, [
      this.excludedChallengeTypes,
    ]);
    const countries = new Map<
      string,
      {
        countryCode: string | null;
        memberCount: number;
        skills: Map<
          string,
          { count: number; name: string; ownedCount: number }
        >;
        topMembers: CountryMember[];
      }
    >();

    rows.forEach((row) => {
      const countryName =
        alpha3ToCountryName(row.country_code) ?? row.country_code ?? "";
      const current = countries.get(countryName) ?? {
        countryCode: row.country_code,
        memberCount: 0,
        skills: new Map<
          string,
          { count: number; name: string; ownedCount: number }
        >(),
        topMembers: [],
      };
      const candidates = (
        Array.isArray(row.top_members) ? row.top_members : []
      ).map((member) => ({
        handle: String(member.handle ?? ""),
        maxRating:
          member.maxRating !== null && member.maxRating !== undefined
            ? Number(member.maxRating)
            : null,
        photoURL: member.photoURL ?? null,
        wins: Number(member.wins ?? 0),
      }));

      current.memberCount += Number(row["user.count"] ?? 0);
      (Array.isArray(row.skills) ? row.skills : []).forEach((skill) => {
        const name = String(skill.name ?? "").trim();
        const count = Number(skill.count ?? 0);
        const ownedCount = Number(skill.ownedCount ?? 0);
        if (
          !name ||
          !Number.isFinite(count) ||
          !Number.isFinite(ownedCount) ||
          ownedCount <= 0
        ) {
          return;
        }

        const key = name.toLowerCase();
        const existing = current.skills.get(key);
        current.skills.set(key, {
          count: (existing?.count ?? 0) + count,
          name: existing?.name ?? name,
          ownedCount: (existing?.ownedCount ?? 0) + ownedCount,
        });
      });
      current.topMembers.push(...candidates);
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
      const totalOwnedSkills = skills.reduce(
        (total, skill) => total + skill.ownedCount,
        0,
      );
      const topMembersByHandle = new Map<string, CountryMember>();
      country.topMembers
        .sort(
          (memberA, memberB) =>
            memberB.wins - memberA.wins ||
            memberA.handle.localeCompare(memberB.handle),
        )
        .forEach((member) => {
          const key = member.handle.toLowerCase();
          if (key && !topMembersByHandle.has(key)) {
            topMembersByHandle.set(key, member);
          }
        });
      const topMembers = Array.from(topMembersByHandle.values()).slice(0, 3);

      return {
        "country.country_name": countryName,
        "country.country_code": country.countryCode,
        "user.count": country.memberCount,
        rank,
        skillsBreakdown: skills.slice(0, 3).map((skill) => ({
          count: skill.count,
          name: skill.name,
          percentage:
            totalOwnedSkills > 0
              ? (skill.ownedCount / totalOwnedSkills) * 100
              : 0,
        })),
        totalSkills: skills.length,
        topMembers,
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
    }>(q, [this.excludedChallengeTypes]);

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
