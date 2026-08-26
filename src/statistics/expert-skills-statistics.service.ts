import { Injectable, NotFoundException } from "@nestjs/common";
import {
  alpha3ToCountryName,
  toAlpha2CountryCode,
} from "../common/country.util";
import { SqlLoaderService } from "../common/sql-loader.service";
import { DbService } from "../db/db.service";
import {
  getCategoryAppearance,
  normalizeCategoryName,
  normalizeCategorySizes,
} from "./expert-skills-statistics.data";

const MEMBERS_LIMIT = 100;
const COUNTRY_DISPLAY_NAMES: Record<string, string> = {
  US: "USA",
  GB: "UK",
};

type SkillBreakdown = {
  name: string;
  percentage: number;
};

type CategoryStatsRow = {
  id: string;
  totalMembers: number;
  totalSkills: number;
  totalWins: number;
  skillsBreakdown: SkillBreakdown[] | null;
};

type MemberRow = {
  handle: string;
  firstName: string | null;
  lastName: string | null;
  photoUrl: string | null;
  countryCode: string | null;
  rating: number | null;
  wins: number | null;
};

type SkillCategoryRow = {
  id: string;
  name: string;
};

function toCountryName(countryCode: string, rawValue?: string | null): string {
  if (COUNTRY_DISPLAY_NAMES[countryCode]) {
    return COUNTRY_DISPLAY_NAMES[countryCode];
  }

  const named =
    alpha3ToCountryName(countryCode) || alpha3ToCountryName(rawValue);
  if (named) {
    return named;
  }

  return String(rawValue || "").trim();
}

function formatMemberName(
  firstName: string | null,
  lastName: string | null,
  handle: string,
): string {
  const first = String(firstName || "").trim();
  const last = String(lastName || "").trim();

  if (first && last) {
    return `${first} ${last.charAt(0).toUpperCase()}`;
  }

  return first || handle;
}

@Injectable()
export class ExpertSkillsStatisticsService {
  constructor(
    private readonly db: DbService,
    private readonly sql: SqlLoaderService,
  ) {}

  async getCategories() {
    const categories = await this.loadCategories();
    if (!categories.length) {
      return [];
    }

    const statsById = await this.loadCategoryStats(
      categories.map((category) => category.id),
    );
    const sizes = normalizeCategorySizes(
      categories.map(
        (category) => Number(statsById.get(category.id)?.totalWins) || 0,
      ),
    );

    return categories.map((category, index) => {
      const stats = statsById.get(category.id);
      const appearance = getCategoryAppearance(category.id, category.name);

      return {
        id: category.id,
        name: category.name,
        officialName: category.name,
        color: appearance.color,
        icon: appearance.icon,
        size: sizes[index],
        totalMembers: Number(stats?.totalMembers) || 0,
        totalSkills: Number(stats?.totalSkills) || 0,
        skillsBreakdown: stats?.skillsBreakdown ?? [],
      };
    });
  }

  async getCategoryMembers(selectedCategory: string) {
    const category = await this.findCategory(selectedCategory);
    const q = this.sql.load(
      "reports/statistics/expert-skills/category-members.sql",
    );
    const rows = await this.db.query<MemberRow>(q, [
      category.id,
      MEMBERS_LIMIT,
    ]);

    return rows.map((row) => {
      const countryCode = toAlpha2CountryCode(row.countryCode);

      return {
        countryCode,
        countryName: toCountryName(countryCode, row.countryCode),
        handle: row.handle,
        name: formatMemberName(row.firstName, row.lastName, row.handle),
        photoURL: row.photoUrl ?? null,
        rating: Number(row.rating) || 0,
        wins: Number(row.wins) || 0,
      };
    });
  }

  private async findCategory(
    selectedCategory: string,
  ): Promise<SkillCategoryRow> {
    const requested = String(selectedCategory || "").trim();
    if (!requested) {
      throw new NotFoundException("Skill category not found.");
    }

    const categories = await this.loadCategories();
    const normalizedRequested = normalizeCategoryName(requested);
    const match = categories.find(
      (category) =>
        category.id === requested ||
        normalizeCategoryName(category.name) === normalizedRequested,
    );

    if (!match) {
      throw new NotFoundException(`Skill category not found: ${requested}`);
    }

    return match;
  }

  private async loadCategories(): Promise<SkillCategoryRow[]> {
    const q = this.sql.load("reports/statistics/expert-skills/categories.sql");
    const rows = await this.db.query<SkillCategoryRow>(q);

    return rows
      .map((row) => ({
        id: String(row.id || "").trim(),
        name: String(row.name || "").trim(),
      }))
      .filter((row) => row.id && row.name);
  }

  private async loadCategoryStats(
    categoryIds: string[],
  ): Promise<Map<string, CategoryStatsRow>> {
    const q = this.sql.load(
      "reports/statistics/expert-skills/category-stats.sql",
    );
    const rows = await this.db.query<CategoryStatsRow>(q, [categoryIds]);

    return new Map(rows.map((row) => [row.id, row]));
  }
}
