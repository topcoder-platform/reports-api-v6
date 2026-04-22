import { Injectable, NotFoundException } from "@nestjs/common";
import { alpha3ToCountryName } from "../../common/country.util";
import { DbService } from "../../db/db.service";
import { MemberSearchBodyDto } from "./dto/member-search.dto";
import {
  MatchedSkillDto,
  MemberResultDto,
  MemberSearchResponseDto,
} from "./dto/member-search-response.dto";

type RawMemberRow = {
  id: string;
  handle: string;
  name: string;
  photoUrl: string | null;
  isRecentlyActive: boolean;
  isVerified: boolean;
  openToWork: boolean;
  location: string;
  matchedSkills: MatchedSkillDto[] | null;
  matchIndex: number;
};

function formatLocation(location: string): string {
  const normalizedLocation = String(location || "").trim();
  if (!normalizedLocation) {
    return "";
  }

  const parts = normalizedLocation.split(/\s+/);
  const lastPart = parts[parts.length - 1];
  const mappedCountryName = alpha3ToCountryName(lastPart);
  if (!mappedCountryName) {
    return normalizedLocation;
  }

  if (parts.length === 1) {
    return mappedCountryName;
  }

  return `${parts.slice(0, -1).join(" ")} ${mappedCountryName}`;
}

@Injectable()
export class MemberSearchService {
  constructor(private readonly db: DbService) {}

  async search(dto: MemberSearchBodyDto): Promise<MemberSearchResponseDto> {
    const {
      skills,
      skillSearchType = "OR",
      openToWork,
      recentlyActive,
      verifiedProfile,
      countries,
      sortBy = "matchIndex",
      sortOrder = "desc",
      page = 1,
      limit = 8,
    } = dto;

    // Deduplicate skill entries by id, keeping the last occurrence
    const deduped = skills
      ? Array.from(new Map(skills.map((s) => [s.id, s])).values())
      : [];

    if (deduped.length > 0) {
      await this.validateSkills(deduped.map((s) => s.id));
    }

    // Parameter builder — keeps a shared ordered list
    const params: unknown[] = [];
    const p = (v: unknown): string => {
      params.push(v);
      return `$${params.length}`;
    };

    // Collect CTE bodies (joined later with commas)
    const ctes: string[] = [];

    // Expressions swapped in to the SELECT based on whether skills are requested
    let skillJoin = "";
    let matchedSkillsExpr = `'[]'::jsonb`;
    let matchIndexExpr = "0";

    // ------------------------------------------------------------------ skills
    if (deduped.length > 0) {
      const skillIds = deduped.map((s) => s.id);
      const minWins = deduped.map((s) => s.wins ?? 0);

      const pSkillIds = p(skillIds);
      const pMinWins = p(minWins);
      const pSearchType = p(skillSearchType);
      const pNumSkills = p(deduped.length);

      ctes.push(`requested_skills AS (
  SELECT rs.skill_id, rs.min_wins
  FROM unnest(${pSkillIds}::uuid[], ${pMinWins}::integer[])
       AS rs(skill_id, min_wins)
),
skill_event_stats AS (
  SELECT
    se.user_id,
    se.skill_id,
    COUNT(*) FILTER (
      WHERE LOWER(set_t.name) IN ('challenge_win', 'challenge_2nd_place', 'challenge_3rd_place', 'gig_completion') OR sest.name='engagement'
    ) AS wins,
    COUNT(*)                                                     AS submitted
  FROM skills.skill_event se
  JOIN skills.skill_event_type set_t ON set_t.id = se.skill_event_type_id
  JOIN skills.source_type sest ON sest.id = se.source_type_id
  WHERE se.skill_id = ANY(${pSkillIds}::uuid[])
  GROUP BY se.user_id, se.skill_id
),
deduped_user_skills AS (
  SELECT DISTINCT
    us.user_id,
    us.skill_id
  FROM skills.user_skill us
  WHERE us.skill_id = ANY(${pSkillIds}::uuid[])
),
user_skill_data AS (
  SELECT
    us.user_id,
    us.skill_id,
    sk.name                          AS skill_name,
    COALESCE(ses.wins, 0)            AS wins,
    COALESCE(ses.submitted, 0)       AS submitted
  FROM deduped_user_skills us
  JOIN requested_skills  rs  ON rs.skill_id  = us.skill_id
  JOIN skills.skill      sk  ON sk.id = us.skill_id AND sk.deleted_at IS NULL
  LEFT JOIN skill_event_stats ses
         ON ses.user_id  = us.user_id
        AND ses.skill_id = us.skill_id
),
qualifying_users AS (
  SELECT usd.user_id
  FROM user_skill_data  usd
  JOIN requested_skills rs ON rs.skill_id = usd.skill_id
  GROUP BY usd.user_id
  HAVING
    CASE WHEN ${pSearchType} = 'AND'
      THEN COUNT(DISTINCT CASE WHEN usd.wins >= rs.min_wins THEN usd.skill_id END)
             = ${pNumSkills}::integer
      ELSE COUNT(DISTINCT CASE WHEN usd.wins >= rs.min_wins THEN usd.skill_id END) >= 1
    END
),
user_match_data AS (
  SELECT
    usd.user_id,
    SUM(
      1.0
      + LEAST(usd.wins::float / 100.0, 0.5)
      + CASE WHEN usd.submitted > 0
          THEN (usd.wins::float / usd.submitted::float) * 0.5
          ELSE 0.0
        END
    ) AS total_skill_points,
    jsonb_agg(
      jsonb_build_object(
        'id',         usd.skill_id::text,
        'name',       usd.skill_name,
        'isVerified', usd.wins > 0,
        'wins',       usd.wins,
        'submitted',  usd.submitted
      )
      ORDER BY usd.skill_name
    ) AS matched_skills
  FROM user_skill_data usd
  WHERE usd.user_id IN (SELECT user_id FROM qualifying_users)
  GROUP BY usd.user_id
)`);

      skillJoin = `INNER JOIN user_match_data umd ON umd.user_id = m."userId"`;
      matchedSkillsExpr = `umd.matched_skills`;
      matchIndexExpr = `CEIL(
        LEAST(
          (umd.total_skill_points / (${pNumSkills}::float * 2.0)) * 100.0,
          100.0
        )
      )::integer`;
    }

    // ------------------------------------------------- shared lookup CTEs
    ctes.push(`recently_active AS (
  SELECT DISTINCT r."memberId"::bigint AS user_id
  FROM resources."Resource" r
  WHERE r."createdAt" >= NOW() - INTERVAL '3 months'
    AND r."memberId" ~ '^[0-9]+$'
),
verified_via_trolley AS (
  SELECT DISTINCT tr.user_id::bigint AS user_id
  FROM finance.trolley_recipient tr
  WHERE tr.user_id ~ '^[0-9]+$'
),
member_address AS (
  SELECT DISTINCT ON ("userId")
    "userId", city
  FROM members."memberAddress"
  ORDER BY
    "userId",
    CASE WHEN type = 'HOME' THEN 0 ELSE 1 END,
    id DESC
)`);

    // ------------------------------------------------- dynamic WHERE
    const where: string[] = [`m.status = 'ACTIVE'`];

    if (openToWork === true) {
      where.push(`m."availableForGigs" = true`);
    }

    if (recentlyActive === true) {
      where.push(
        `EXISTS (SELECT 1 FROM recently_active ra WHERE ra.user_id = m."userId")`,
      );
    }

    if (verifiedProfile === true) {
      where.push(
        `(COALESCE(m.verified, false) = true OR EXISTS (SELECT 1 FROM verified_via_trolley vt WHERE vt.user_id = m."userId"))`,
      );
    }

    const normalizedCountries = Array.isArray(countries)
      ? [
          ...new Set(
            countries
              .map((value) => String(value).trim().toLowerCase())
              .filter(Boolean),
          ),
        ]
      : [];

    if (normalizedCountries.length > 0) {
      const pCountries = p(normalizedCountries);
      where.push(
        `(
          LOWER(m."homeCountryCode") = ANY(${pCountries}::text[])
          OR LOWER(m."competitionCountryCode") = ANY(${pCountries}::text[])
          OR LOWER(m.country) = ANY(${pCountries}::text[])
        )`,
      );
    }

    // Snapshot param count BEFORE adding pagination — count query stops here
    const filterParamCount = params.length;

    const pLimit = p(limit);
    const pOffset = p((page - 1) * limit);

    // ---------------------------------------------------------------- queries
    const ctesBlock = ctes.join(",\n");
    const whereClause = where.join(" AND ");
    const direction = sortOrder === "asc" ? "ASC" : "DESC";
    const orderByClause =
      sortBy === "handle"
        ? `m.handle ${direction}, "matchIndex" DESC NULLS LAST`
        : `"matchIndex" ${direction} NULLS LAST, m.handle ASC`;

    const dataQuery = `
WITH ${ctesBlock}
SELECT
  m."userId"::text                                                           AS id,
  m.handle,
  TRIM(COALESCE(m."firstName", '') || ' ' || COALESCE(m."lastName", ''))   AS name,
  m."photoURL"                                                               AS "photoUrl",
  EXISTS (SELECT 1 FROM recently_active   ra WHERE ra.user_id = m."userId") AS "isRecentlyActive",
  (
    COALESCE(m.verified, false) = true
    OR EXISTS (SELECT 1 FROM verified_via_trolley vt WHERE vt.user_id = m."userId")
  )                                                                          AS "isVerified",
  COALESCE(m."availableForGigs", false)                                     AS "openToWork",
  TRIM(
    COALESCE(maddr.city || ' ', '') ||
    COALESCE(m."homeCountryCode", COALESCE(m.country, COALESCE(m."competitionCountryCode", '')))
  )                                                                          AS location,
  ${matchedSkillsExpr}                                                       AS "matchedSkills",
  ${matchIndexExpr}                                                          AS "matchIndex"
FROM members.member m
${skillJoin}
LEFT JOIN member_address    maddr ON maddr."userId" = m."userId"
WHERE ${whereClause}
ORDER BY ${orderByClause}
LIMIT ${pLimit} OFFSET ${pOffset}`;

    const countQuery = `
WITH ${ctesBlock}
SELECT COUNT(*)::integer AS total
FROM members.member m
${skillJoin}
WHERE ${whereClause}`;

    const [rows, countRows] = await Promise.all([
      this.db.query<RawMemberRow>(dataQuery, params),
      this.db.query<{ total: number }>(
        countQuery,
        params.slice(0, filterParamCount),
      ),
    ]);

    const total = countRows[0]?.total ?? 0;

    const data: MemberResultDto[] = rows.map((row) => ({
      id: row.id,
      handle: row.handle,
      name: row.name || row.handle,
      photoUrl: row.photoUrl ?? null,
      isRecentlyActive: row.isRecentlyActive ?? false,
      isVerified: row.isVerified ?? false,
      openToWork: row.openToWork ?? false,
      location: formatLocation(row.location),
      matchedSkills: row.matchedSkills ?? [],
      matchIndex: row.matchIndex ?? 0,
    }));

    return { total, page, limit, data };
  }

  private async validateSkills(skillIds: string[]): Promise<void> {
    const rows = await this.db.query<{ id: string }>(
      `SELECT id::text FROM skills.skill WHERE id = ANY($1::uuid[]) AND deleted_at IS NULL`,
      [skillIds],
    );

    if (rows.length !== skillIds.length) {
      const foundIds = new Set(rows.map((r) => r.id));
      const missing = skillIds.find((id) => !foundIds.has(id));
      throw new NotFoundException(`Skill not found or is disabled: ${missing}`);
    }
  }
}
