import { Injectable, NotFoundException } from "@nestjs/common";
import { alpha3ToCountryName } from "../../common/country.util";
import { DbService } from "../../db/db.service";
import { MemberSearchBodyDto } from "./dto/member-search.dto";
import {
  MatchedSkillDto,
  MemberResultDto,
  MemberSearchResponseDto,
} from "./dto/member-search-response.dto";
import {
  OpenToWorkTalentMemberDto,
  OpenToWorkTalentQueryDto,
  OpenToWorkTalentResponseDto,
  OpenToWorkTalentRoleCountDto,
} from "./dto/open-to-work-talent.dto";

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

type OpenToWorkTalentMemberRow = {
  userId: string | number;
  handle: string;
  firstName: string | null;
  lastName: string | null;
  email: string | null;
  phone: string | null;
  country: string | null;
  availability: string | null;
  preferredRoles: string[] | null;
  memberSince: Date | string | null;
  maxRating: string | number | null;
  challengeWins: string | number | null;
  taskWins: string | number | null;
  totalWins: string | number | null;
};

type OpenToWorkTalentRoleCountRow = {
  role: string;
  count: string | number;
};

type OpenToWorkTalentExportRow = {
  handle: string;
  firstName: string | null;
  lastName: string | null;
  email: string | null;
  phone: string | null;
  country: string | null;
  availability: string | null;
  preferredRoles: string;
  memberSince: string | null;
  maxRating: number | null;
  challengeWins: number;
  taskWins: number;
  totalWins: number;
};

type NormalizedOpenToWorkTalentQuery = {
  availability: string | null;
  role: string | null;
  page: number;
  perPage: number;
};

const openToWorkTalentBaseCtes = `
WITH latest_open_to_work AS MATERIALIZED (
  SELECT DISTINCT ON (mt."userId")
    mt."userId" AS user_id,
    mtp.value::jsonb AS value
  FROM members."memberTraits" mt
  INNER JOIN members."memberTraitPersonalization" mtp
    ON mtp."memberTraitId" = mt.id
  WHERE mtp.key = 'openToWork'
    AND mtp.value IS NOT NULL
    AND mtp.value::jsonb ? 'preferredRoles'
    AND jsonb_typeof(mtp.value::jsonb -> 'preferredRoles') = 'array'
    AND jsonb_array_length(mtp.value::jsonb -> 'preferredRoles') > 0
  ORDER BY mt."userId", mt."updatedAt" DESC NULLS LAST, mt.id DESC
),
open_to_work_members AS MATERIALIZED (
  SELECT
    m."userId" AS "userId",
    m.handle,
    NULLIF(TRIM(m."firstName"), '') AS "firstName",
    NULLIF(TRIM(m."lastName"), '') AS "lastName",
    NULLIF(TRIM(m.email), '') AS email,
    ph.phone,
    COALESCE(
      NULLIF(TRIM(m.country), ''),
      NULLIF(TRIM(m."homeCountryCode"), ''),
      NULLIF(TRIM(m."competitionCountryCode"), '')
    ) AS country,
    NULLIF(TRIM(latest_open_to_work.value ->> 'availability'), '') AS availability,
    ARRAY(
      SELECT jsonb_array_elements_text(latest_open_to_work.value -> 'preferredRoles')
    ) AS "preferredRoles",
    u.create_date AS "memberSince"
  FROM members.member m
  INNER JOIN latest_open_to_work
    ON latest_open_to_work.user_id = m."userId"
  LEFT JOIN identity."user" u
    ON u.user_id = m."userId"::numeric(10, 0)
  LEFT JOIN LATERAL (
    SELECT STRING_AGG(DISTINCT NULLIF(TRIM(mp."number"::text), ''), ', ') AS phone
    FROM members."memberPhone" mp
    WHERE mp."userId" = m."userId"
      AND NULLIF(TRIM(mp."number"::text), '') IS NOT NULL
  ) ph ON TRUE
  WHERE COALESCE(m."availableForGigs", false) = true
    AND COALESCE(m.email, '') NOT ILIKE '%@wipro.com'
),
max_rating AS (
  SELECT DISTINCT ON (mmr."userId")
    mmr."userId" AS user_id,
    mmr.rating
  FROM members."memberMaxRating" mmr
  INNER JOIN open_to_work_members otw
    ON otw."userId" = mmr."userId"
  ORDER BY mmr."userId", mmr.rating DESC NULLS LAST
),
challenge_wins AS (
  SELECT
    cw."userId"::text AS user_id,
    COUNT(DISTINCT cw."challengeId")::integer AS challenge_wins
  FROM challenges."ChallengeWinner" cw
  INNER JOIN open_to_work_members otw
    ON otw."userId"::text = cw."userId"::text
  INNER JOIN challenges."Challenge" c
    ON c.id = cw."challengeId"
  INNER JOIN challenges."ChallengeType" ct
    ON ct.id = c."typeId"
  WHERE cw.placement = 1
    AND COALESCE(ct."isTask", false) = false
  GROUP BY cw."userId"
),
task_wins AS (
  SELECT
    cw."userId"::text AS user_id,
    COUNT(DISTINCT cw."challengeId")::integer AS task_wins
  FROM challenges."ChallengeWinner" cw
  INNER JOIN open_to_work_members otw
    ON otw."userId"::text = cw."userId"::text
  INNER JOIN challenges."Challenge" c
    ON c.id = cw."challengeId"
  INNER JOIN challenges."ChallengeType" ct
    ON ct.id = c."typeId"
  WHERE cw.placement = 1
    AND COALESCE(ct."isTask", false) = true
  GROUP BY cw."userId"
)`;

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

  return `${parts.slice(0, -1).join(" ")}, ${mappedCountryName}`;
}

/**
 * Converts nullable database numeric values into a finite number.
 * @param value Raw database value that may be a string, number, or null.
 * @returns Numeric value, or zero when the input is missing/non-numeric.
 */
function toNumber(value: string | number | null | undefined): number {
  const parsed = Number(value ?? 0);
  return Number.isFinite(parsed) ? parsed : 0;
}

/**
 * Converts nullable database numeric values into a nullable finite number.
 * @param value Raw database value that may be a string, number, or null.
 * @returns Numeric value, or null when the input is missing/non-numeric.
 */
function toNullableNumber(
  value: string | number | null | undefined,
): number | null {
  if (value === null || value === undefined || value === "") {
    return null;
  }

  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : null;
}

/**
 * Normalizes Postgres text arrays into a safe string array.
 * @param value Raw database array value.
 * @returns Non-empty role values.
 */
function toStringArray(value: string[] | null | undefined): string[] {
  return Array.isArray(value)
    ? value.map((entry) => String(entry).trim()).filter(Boolean)
    : [];
}

/**
 * Converts database dates into ISO strings for API responses and exports.
 * @param value Raw date value from the database.
 * @returns ISO string, or null when the value cannot be parsed.
 */
function toIsoString(value: Date | string | null | undefined): string | null {
  if (!value) {
    return null;
  }

  const date = value instanceof Date ? value : new Date(value);
  return Number.isNaN(date.getTime()) ? null : date.toISOString();
}

/**
 * Normalizes and bounds Talent report query parameters.
 * @param dto Raw query DTO.
 * @returns Query values ready for SQL parameters and pagination.
 */
function normalizeOpenToWorkTalentQuery(
  dto: OpenToWorkTalentQueryDto,
): NormalizedOpenToWorkTalentQuery {
  return {
    availability: dto.availability?.trim() || null,
    role: dto.role?.trim() || null,
    page: Math.max(Number(dto.page || 1), 1),
    perPage: Math.min(Math.max(Number(dto.perPage || 10), 1), 100),
  };
}

@Injectable()
export class MemberSearchService {
  constructor(private readonly db: DbService) {}

  /**
   * Returns the open-to-work Talent report dashboard data.
   *
   * The report includes distinct member totals, preferred-role aggregates, and
   * a paginated member list sorted by platform-backed wins and rating.
   *
   * @param dto Query filters and pagination values from the reports UI.
   * @returns Dashboard response for the Talent tab.
   * @throws Does not throw intentionally; database errors propagate to Nest.
   */
  async getOpenToWorkTalent(
    dto: OpenToWorkTalentQueryDto,
  ): Promise<OpenToWorkTalentResponseDto> {
    const query = normalizeOpenToWorkTalentQuery(dto);
    const offset = (query.page - 1) * query.perPage;

    const [totalMemberRows, roleRows, countRows, memberRows] =
      await Promise.all([
        this.db.query<{ total: number }>(
          `${openToWorkTalentBaseCtes}
SELECT COUNT(*)::integer AS total
FROM open_to_work_members otw
WHERE ($1::text IS NULL OR otw.availability = $1::text)`,
          [query.availability],
        ),
        this.db.query<OpenToWorkTalentRoleCountRow>(
          `${openToWorkTalentBaseCtes}
SELECT
  role,
  COUNT(DISTINCT otw."userId")::integer AS count
FROM open_to_work_members otw
CROSS JOIN LATERAL unnest(otw."preferredRoles") AS role
WHERE ($1::text IS NULL OR otw.availability = $1::text)
GROUP BY role
ORDER BY count DESC, role ASC`,
          [query.availability],
        ),
        this.db.query<{ total: number }>(
          `${openToWorkTalentBaseCtes}
SELECT COUNT(*)::integer AS total
FROM open_to_work_members otw
WHERE ($1::text IS NULL OR otw.availability = $1::text)
  AND ($2::text IS NULL OR $2::text = ANY(otw."preferredRoles"))`,
          [query.availability, query.role],
        ),
        this.db.query<OpenToWorkTalentMemberRow>(
          `${openToWorkTalentBaseCtes}
SELECT
  otw."userId",
  otw.handle,
  otw."firstName",
  otw."lastName",
  otw.email,
  otw.phone,
  otw.country,
  otw.availability,
  otw."preferredRoles",
  otw."memberSince",
  mr.rating AS "maxRating",
  COALESCE(cw.challenge_wins, 0)::integer AS "challengeWins",
  COALESCE(tw.task_wins, 0)::integer AS "taskWins",
  (COALESCE(cw.challenge_wins, 0) + COALESCE(tw.task_wins, 0))::integer AS "totalWins"
FROM open_to_work_members otw
LEFT JOIN max_rating mr
  ON mr.user_id = otw."userId"
LEFT JOIN challenge_wins cw
  ON cw.user_id = otw."userId"::text
LEFT JOIN task_wins tw
  ON tw.user_id = otw."userId"::text
WHERE ($1::text IS NULL OR otw.availability = $1::text)
  AND ($2::text IS NULL OR $2::text = ANY(otw."preferredRoles"))
ORDER BY
  (COALESCE(cw.challenge_wins, 0) + COALESCE(tw.task_wins, 0)) DESC,
  COALESCE(mr.rating, 0) DESC,
  otw."memberSince" ASC NULLS LAST,
  LOWER(otw.handle) ASC
LIMIT $3::integer OFFSET $4::integer`,
          [query.availability, query.role, query.perPage, offset],
        ),
      ]);

    return {
      totalMembers: totalMemberRows[0]?.total ?? 0,
      total: countRows[0]?.total ?? 0,
      page: query.page,
      perPage: query.perPage,
      roleCounts: roleRows.map(
        (row): OpenToWorkTalentRoleCountDto => ({
          role: row.role,
          count: toNumber(row.count),
        }),
      ),
      data: memberRows.map((row) => this.toOpenToWorkTalentMember(row)),
    };
  }

  /**
   * Returns open-to-work Talent report rows formatted for CSV serialization.
   *
   * The export intentionally includes email and phone fields required by the
   * leadership handoff while using the same role/availability filters as the UI.
   *
   * @param dto Query filters from the reports UI.
   * @returns Flat export rows that the CSV interceptor can serialize.
   * @throws Does not throw intentionally; database errors propagate to Nest.
   */
  async exportOpenToWorkTalent(
    dto: OpenToWorkTalentQueryDto,
  ): Promise<OpenToWorkTalentExportRow[]> {
    const query = normalizeOpenToWorkTalentQuery(dto);
    const rows = await this.db.query<OpenToWorkTalentMemberRow>(
      `${openToWorkTalentBaseCtes}
SELECT
  otw."userId",
  otw.handle,
  otw."firstName",
  otw."lastName",
  otw.email,
  otw.phone,
  otw.country,
  otw.availability,
  otw."preferredRoles",
  otw."memberSince",
  mr.rating AS "maxRating",
  COALESCE(cw.challenge_wins, 0)::integer AS "challengeWins",
  COALESCE(tw.task_wins, 0)::integer AS "taskWins",
  (COALESCE(cw.challenge_wins, 0) + COALESCE(tw.task_wins, 0))::integer AS "totalWins"
FROM open_to_work_members otw
LEFT JOIN max_rating mr
  ON mr.user_id = otw."userId"
LEFT JOIN challenge_wins cw
  ON cw.user_id = otw."userId"::text
LEFT JOIN task_wins tw
  ON tw.user_id = otw."userId"::text
WHERE ($1::text IS NULL OR otw.availability = $1::text)
  AND ($2::text IS NULL OR $2::text = ANY(otw."preferredRoles"))
ORDER BY
  (COALESCE(cw.challenge_wins, 0) + COALESCE(tw.task_wins, 0)) DESC,
  COALESCE(mr.rating, 0) DESC,
  otw."memberSince" ASC NULLS LAST,
  LOWER(otw.handle) ASC`,
      [query.availability, query.role],
    );

    return rows.map(
      (row): OpenToWorkTalentExportRow => ({
        handle: row.handle,
        firstName: row.firstName,
        lastName: row.lastName,
        email: row.email,
        phone: row.phone,
        country: row.country,
        availability: row.availability,
        preferredRoles: toStringArray(row.preferredRoles).join(", "),
        memberSince: toIsoString(row.memberSince),
        maxRating: toNullableNumber(row.maxRating),
        challengeWins: toNumber(row.challengeWins),
        taskWins: toNumber(row.taskWins),
        totalWins: toNumber(row.totalWins),
      }),
    );
  }

  async search(dto: MemberSearchBodyDto): Promise<MemberSearchResponseDto> {
    const {
      skills,
      skillSearchType = "OR",
      openToWork,
      recentlyActive,
      verifiedProfile,
      profileComplete,
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

    // active_members is always first so later CTEs can reference it
    ctes.push(`active_members AS MATERIALIZED (
  SELECT m."userId" AS user_id
  FROM members.member m
  WHERE m.status = 'ACTIVE'
)`);

    // Expressions swapped in to the SELECT based on whether skills are requested
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
user_skill_data AS (
  SELECT
    usws.user_id,
    usws.skill_id,
    sk.name    AS skill_name,
    usws.wins,
    usws.submitted
  FROM skills.user_skill_win_summary usws
  JOIN requested_skills rs ON rs.skill_id = usws.skill_id
  JOIN skills.skill     sk ON sk.id = usws.skill_id AND sk.deleted_at IS NULL
  WHERE usws.user_id IN (SELECT user_id FROM active_members)
),
qualifying_users AS (
  SELECT usd.user_id
  FROM user_skill_data  usd
  JOIN requested_skills rs ON rs.skill_id = usd.skill_id
  GROUP BY usd.user_id
  HAVING
    CASE WHEN ${pSearchType} = 'AND'
      THEN COUNT(DISTINCT CASE
        WHEN (usd.wins >= rs.min_wins OR usd.submitted > 0)
        THEN usd.skill_id END)
             = ${pNumSkills}::integer
      ELSE COUNT(DISTINCT CASE
        WHEN (usd.wins >= rs.min_wins OR usd.submitted > 0)
        THEN usd.skill_id END) >= 1
    END
),
user_match_data AS (
  SELECT
    usd.user_id,
    COALESCE(
      SUM(
        1.0
        + LEAST(usd.wins::float / 100.0, 0.5)
        + CASE WHEN usd.submitted > 0
            THEN (usd.wins::float / usd.submitted::float) * 0.5
            ELSE 0.0
          END
      ) FILTER (WHERE usd.wins > 0 OR usd.submitted > 0),
      0.0
    ) AS total_skill_points,
    COALESCE(
      jsonb_agg(
        jsonb_build_object(
          'id',         usd.skill_id::text,
          'name',       usd.skill_name,
          'isVerified', (usd.wins > 0 OR usd.submitted > 0),
          'wins',       usd.wins,
          'submitted',  usd.submitted
        )
        ORDER BY usd.skill_name
      ) FILTER (WHERE usd.wins > 0 OR usd.submitted > 0),
      '[]'::jsonb
    ) AS matched_skills
  FROM user_skill_data usd
  WHERE usd.user_id IN (SELECT user_id FROM qualifying_users)
  GROUP BY usd.user_id
)`);

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
  INNER JOIN active_members am ON am.user_id = r."memberId"::bigint
  WHERE r."createdAt" >= NOW() - INTERVAL '3 months'
),
verified_via_trolley AS (
  SELECT DISTINCT tr.user_id::bigint AS user_id
  FROM finance.trolley_recipient tr
  INNER JOIN active_members am ON am.user_id = tr.user_id::bigint
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

    // ------------------------------------------------- dynamic WHERE (easy filters first)
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
              .map((value) => String(value).trim().toUpperCase())
              .filter(Boolean),
          ),
        ]
      : [];

    if (normalizedCountries.length > 0) {
      const pCountries = p(normalizedCountries);
      where.push(
        `(
          m."homeCountryCode" = ANY(${pCountries}::text[])
          OR m."competitionCountryCode" = ANY(${pCountries}::text[])
          OR UPPER(m.country) = ANY(${pCountries}::text[])
        )`,
      );
    }

    const whereClause = where.join(" AND ");
    const skillJoin =
      deduped.length > 0
        ? `INNER JOIN user_match_data umd ON umd.user_id = m."userId"`
        : ``;
    ctes.push(`filtered_members AS (
  SELECT m."userId" AS user_id
  FROM members.member m
  ${skillJoin}
  WHERE ${whereClause}
)`);

    if (profileComplete === true) {
      ctes.push(`profile_complete_filtered AS (
  SELECT fm.user_id
  FROM filtered_members fm
  INNER JOIN members.member m2 ON m2."userId" = fm.user_id
  WHERE m2.description IS NOT NULL
    AND btrim(m2.description) <> ''
    AND m2."homeCountryCode" IS NOT NULL
    AND EXISTS (
      SELECT 1
      FROM members."memberAddress" ma2
      WHERE ma2."userId" = m2."userId"
        AND ma2.city IS NOT NULL
        AND btrim(ma2.city) <> ''
    )
    AND EXISTS (
      SELECT 1
      FROM members."memberTraits" mt2
      INNER JOIN members."memberTraitWork" mw2 ON mw2."memberTraitId" = mt2.id
      WHERE mt2."userId" = m2."userId"
    )
    AND EXISTS (
      SELECT 1
      FROM members."memberTraits" mt2
      INNER JOIN members."memberTraitEducation" me2 ON me2."memberTraitId" = mt2.id
      WHERE mt2."userId" = m2."userId"
    )
    AND EXISTS (
      SELECT 1
      FROM members."memberTraits" mt2
      INNER JOIN members."memberTraitPersonalization" mtp2 ON mtp2."memberTraitId" = mt2.id
      WHERE mt2."userId" = m2."userId"
        AND mtp2.key = 'openToWork'
        AND mtp2.value IS NOT NULL
        AND (
          NOT (mtp2.value::jsonb ? 'availability')
          OR (
            mtp2.value::jsonb ? 'availability'
            AND mtp2.value::jsonb ? 'preferredRoles'
            AND jsonb_typeof(mtp2.value::jsonb -> 'preferredRoles') = 'array'
            AND jsonb_array_length(mtp2.value::jsonb -> 'preferredRoles') > 0
          )
        )
    )
    AND EXISTS (
      SELECT 1
      FROM skills.user_skill us2
      INNER JOIN skills.user_skill_display_mode usdm2 ON usdm2.id = us2.user_skill_display_mode_id
      WHERE us2.user_id = m2."userId"
        AND usdm2.name = 'principal'
    )
    AND EXISTS (
      SELECT 1
      FROM skills.user_skill us2
      INNER JOIN skills.user_skill_display_mode usdm2 ON usdm2.id = us2.user_skill_display_mode_id
      WHERE us2.user_id = m2."userId"
        AND usdm2.name = 'additional'
    )
)`);
    }

    const filterParamCount = params.length;
    const pLimit = p(limit);
    const pOffset = p((page - 1) * limit);

    // ---------------------------------------------------------------- queries
    const ctesBlock = ctes.join(",\n");
    const direction = sortOrder === "asc" ? "ASC" : "DESC";
    const orderByClause =
      sortBy === "handle"
        ? `m.handle ${direction}, "matchIndex" DESC NULLS LAST`
        : `"matchIndex" ${direction} NULLS LAST, m.handle ASC`;
    const profileCompleteJoin =
      profileComplete === true
        ? `INNER JOIN profile_complete_filtered pcf ON pcf.user_id = m."userId"`
        : "";

    const dataQuery = `
WITH ${ctesBlock}
SELECT
  m."userId"::text                                                           AS id,
  m.handle,
  TRIM(COALESCE(m."firstName", '') || ' ' || COALESCE(m."lastName", ''))   AS name,
  m."photoURL"                                                               AS "photoUrl",
  EXISTS (SELECT 1 FROM recently_active   ra WHERE ra.user_id = m."userId") AS "isRecentlyActive",
  (COALESCE(m.verified, false) = true OR vt.user_id IS NOT NULL)             AS "isVerified",
  COALESCE(m."availableForGigs", false)                                     AS "openToWork",
  TRIM(
    COALESCE(maddr.city || ' ', '') ||
    COALESCE(m."homeCountryCode", COALESCE(m.country, COALESCE(m."competitionCountryCode", '')))
  )                                                                          AS location,
  ${matchedSkillsExpr}                                                       AS "matchedSkills",
  ${matchIndexExpr}                                                          AS "matchIndex"
FROM members.member m
INNER JOIN filtered_members fm ON fm.user_id = m."userId"
${profileCompleteJoin}
LEFT JOIN user_match_data umd ON umd.user_id = m."userId"
LEFT JOIN verified_via_trolley vt ON vt.user_id = m."userId"
LEFT JOIN member_address    maddr ON maddr."userId" = m."userId"
ORDER BY ${orderByClause}
LIMIT ${pLimit} OFFSET ${pOffset}`;

    const countQuery = `
      WITH ${ctesBlock}
      SELECT COUNT(*)::integer AS total
      FROM ${profileComplete === true ? "profile_complete_filtered pcf" : "filtered_members fm"}`;

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

  /**
   * Maps database rows into the public Talent report member shape.
   * @param row Raw member row selected by the open-to-work Talent query.
   * @returns API-safe member row for the reports UI.
   */
  private toOpenToWorkTalentMember(
    row: OpenToWorkTalentMemberRow,
  ): OpenToWorkTalentMemberDto {
    return {
      userId: String(row.userId),
      handle: row.handle,
      firstName: row.firstName,
      lastName: row.lastName,
      country: row.country,
      availability: row.availability,
      preferredRoles: toStringArray(row.preferredRoles),
      memberSince: toIsoString(row.memberSince),
      maxRating: toNullableNumber(row.maxRating),
      challengeWins: toNumber(row.challengeWins),
      taskWins: toNumber(row.taskWins),
      totalWins: toNumber(row.totalWins),
    };
  }
}
