import { Injectable, NotFoundException } from "@nestjs/common";
import {
  alpha3ToCountryName,
  toAlpha2CountryCode,
} from "../../common/country.util";
import { DbService } from "../../db/db.service";
import {
  ExpertSkillBreakdownDto,
  ExpertSkillCategoryDto,
  ExpertSkillCategoryMemberDto,
} from "./dto/expert-skill-category.dto";
import {
  getCategoryAppearance,
  normalizeCategoryName,
  normalizeCategorySizes,
} from "./expert-skill-categories.data";
import {
  StandardizedSkillCategory,
  StandardizedSkillsClient,
} from "./standardized-skills.client";

const MEMBERS_LIMIT = 100;
const COUNTRY_DISPLAY_NAMES: Record<string, string> = {
  US: "USA",
  GB: "UK",
};

type CategoryStatsRow = {
  id: string;
  totalMembers: number;
  totalSkills: number;
  totalWins: number;
  skillsBreakdown: ExpertSkillBreakdownDto[] | null;
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
export class ExpertSkillsService {
  constructor(
    private readonly db: DbService,
    private readonly standardizedSkills: StandardizedSkillsClient,
  ) {}

  async getCategories(): Promise<ExpertSkillCategoryDto[]> {
    const categories = await this.standardizedSkills.fetchCategories();
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
      const appearance = getCategoryAppearance(category.id);

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

  async getCategoryMembers(
    selectedCategory: string,
  ): Promise<ExpertSkillCategoryMemberDto[]> {
    const category = await this.findCategory(selectedCategory);
    const rows = await this.db.query<MemberRow>(this.buildMembersQuery(), [
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
  ): Promise<StandardizedSkillCategory> {
    const requested = String(selectedCategory || "").trim();
    if (!requested) {
      throw new NotFoundException("Skill category not found.");
    }

    const categories = await this.standardizedSkills.fetchCategories();
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

  private async loadCategoryStats(
    categoryIds: string[],
  ): Promise<Map<string, CategoryStatsRow>> {
    const rows = await this.db.query<CategoryStatsRow>(
      this.buildCategoriesQuery(),
      [categoryIds],
    );

    return new Map(rows.map((row) => [row.id, row]));
  }

  private buildCategoriesQuery(): string {
    return `
WITH requested_categories AS (
  SELECT DISTINCT id
  FROM unnest($1::uuid[]) AS t(id)
),
skill_counts AS (
  SELECT
    sk.category_id,
    COUNT(*)::int AS total_skills
  FROM skills.skill sk
  WHERE sk.deleted_at IS NULL
    AND sk.category_id = ANY($1::uuid[])
  GROUP BY sk.category_id
),
member_counts AS (
  SELECT
    sk.category_id,
    COUNT(DISTINCT us.user_id)::int AS total_members
  FROM skills.user_skill us
  JOIN skills.skill sk
    ON sk.id = us.skill_id
   AND sk.deleted_at IS NULL
  WHERE sk.category_id = ANY($1::uuid[])
  GROUP BY sk.category_id
),
win_events AS (
  SELECT
    sk.category_id,
    sk.id AS skill_id,
    sk.name AS skill_name,
    se.user_id
  FROM skills.skill_event se
  JOIN skills.skill sk
    ON sk.id = se.skill_id
   AND sk.deleted_at IS NULL
  JOIN skills.skill_event_type set_t
    ON set_t.id = se.skill_event_type_id
  JOIN skills.source_type sest
    ON sest.id = se.source_type_id
  WHERE sk.category_id = ANY($1::uuid[])
    AND (
      LOWER(set_t.name) IN (
        'challenge_win',
        'challenge_2nd_place',
        'challenge_3rd_place',
        'gig_completion'
      )
      OR sest.name = 'engagement'
    )
),
win_counts AS (
  SELECT
    category_id,
    COUNT(*)::int AS total_wins
  FROM win_events
  GROUP BY category_id
),
top_skills AS (
  SELECT
    category_id,
    skill_name AS name,
    COUNT(*)::int AS skill_wins,
    ROW_NUMBER() OVER (
      PARTITION BY category_id
      ORDER BY COUNT(*) DESC, skill_name ASC
    ) AS rn
  FROM win_events
  GROUP BY category_id, skill_id, skill_name
)
SELECT
  rc.id::text AS id,
  COALESCE(mc.total_members, 0) AS "totalMembers",
  COALESCE(sc.total_skills, 0) AS "totalSkills",
  COALESCE(wc.total_wins, 0) AS "totalWins",
  COALESCE(
    (
      SELECT jsonb_agg(
        jsonb_build_object(
          'name', ts.name,
          'percentage', CASE
            WHEN COALESCE(wc.total_wins, 0) = 0 THEN 0
            ELSE ROUND((ts.skill_wins::numeric / wc.total_wins::numeric) * 100)::int
          END
        )
        ORDER BY ts.rn
      )
      FROM top_skills ts
      WHERE ts.category_id = rc.id
        AND ts.rn <= 3
    ),
    '[]'::jsonb
  ) AS "skillsBreakdown"
FROM requested_categories rc
LEFT JOIN skill_counts sc ON sc.category_id = rc.id
LEFT JOIN member_counts mc ON mc.category_id = rc.id
LEFT JOIN win_counts wc ON wc.category_id = rc.id`;
  }

  private buildMembersQuery(): string {
    return `
WITH category_wins AS (
  SELECT
    se.user_id,
    COUNT(*)::int AS wins
  FROM skills.skill_event se
  JOIN skills.skill sk
    ON sk.id = se.skill_id
   AND sk.deleted_at IS NULL
  JOIN skills.skill_event_type set_t
    ON set_t.id = se.skill_event_type_id
  JOIN skills.source_type sest
    ON sest.id = se.source_type_id
  WHERE sk.category_id = $1::uuid
    AND (
      LOWER(set_t.name) IN (
        'challenge_win',
        'challenge_2nd_place',
        'challenge_3rd_place',
        'gig_completion'
      )
      OR sest.name = 'engagement'
    )
  GROUP BY se.user_id
)
SELECT
  m.handle,
  m."firstName" AS "firstName",
  m."lastName" AS "lastName",
  m."photoURL" AS "photoUrl",
  COALESCE(m."homeCountryCode", m."competitionCountryCode", m.country, '') AS "countryCode",
  COALESCE(mr.rating, 0) AS rating,
  cw.wins
FROM category_wins cw
JOIN members.member m
  ON m."userId" = cw.user_id
 AND m.status = 'ACTIVE'
LEFT JOIN LATERAL (
  SELECT rating
  FROM members."memberMaxRating" mmr
  WHERE mmr."userId" = m."userId"
  ORDER BY mmr.rating DESC NULLS LAST
  LIMIT 1
) mr ON TRUE
ORDER BY cw.wins DESC, m.handle ASC
LIMIT $2`;
  }
}
