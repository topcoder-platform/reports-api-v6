import { ConfigService } from "@nestjs/config";
import { DbService } from "../../db/db.service";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { TopcoderReportsService } from "./topcoder-reports.service";

describe("TopcoderReportsService", () => {
  let service: TopcoderReportsService;
  let db: { query: jest.Mock };
  let sql: { load: jest.Mock };
  let config: { get: jest.Mock };
  let engagementsPoolQuery: jest.Mock;

  beforeEach(() => {
    db = {
      query: jest.fn((query: string) => {
        if (query === "reports/topcoder/engagement-data-members.sql") {
          return [
            {
              user_id: "101",
              handle: "assigned_user",
              first_name: "Ada",
              last_name: "Lovelace",
              email: "ada@example.com",
              home_country: null,
              competition_country: null,
              home_country_code: "JPN",
              competition_country_code: null,
              street_addr_1: "1 Main St",
              street_addr_2: null,
              city: "New York",
              state_code: "NY",
              zip: "10001",
              phone_number: "+1 555 0101",
            },
            {
              user_id: "202",
              handle: null,
              first_name: null,
              last_name: null,
              email: null,
              home_country: null,
              competition_country: "Sri Lanka",
              home_country_code: null,
              competition_country_code: "LKA",
              street_addr_1: null,
              street_addr_2: null,
              city: null,
              state_code: null,
              zip: null,
              phone_number: null,
            },
          ];
        }

        if (query === "reports/topcoder/engagement-data-projects.sql") {
          return [
            { project_id: "p1", project_name: "Project Alpha" },
            { project_id: "p2", project_name: "Project Beta" },
          ];
        }

        throw new Error(`Unexpected query: ${query}`);
      }),
    };

    sql = {
      load: jest.fn((query: string) => query),
    };

    config = {
      get: jest.fn((key: string, defaultValue?: string) => {
        if (key === "ENGAGEMENTS_DB_URL") {
          return "postgresql://localhost:5432/engagements";
        }

        return defaultValue;
      }),
    };

    service = new TopcoderReportsService(
      db as unknown as DbService,
      sql as unknown as SqlLoaderService,
      config as unknown as ConfigService,
    );

    engagementsPoolQuery = jest.fn().mockResolvedValue({
      rows: [
        {
          member_id: "101",
          fallback_handle: "assigned_user",
          application_email: "assigned-application@example.com",
          application_address: "Assigned Application Address",
          application_phone: "111-111-1111",
          application_name: "Assigned User",
          has_assignment: true,
          assigned_project_ids: ["p2", "p1", "p1"],
        },
        {
          member_id: "202",
          fallback_handle: "applicant_user",
          application_email: "applicant@example.com",
          application_address: "Applicant Address",
          application_phone: "222-222-2222",
          application_name: "Grace Hopper",
          has_assignment: false,
          assigned_project_ids: [],
        },
      ],
    });

    Object.assign(service as object, {
      engagementsPool: {
        end: jest.fn(),
        query: engagementsPoolQuery,
      },
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("builds engagement data rows with profile-style country resolution, fallbacks, and project names", async () => {
    await expect(service.getEngagementData()).resolves.toEqual([
      {
        handle: "assigned_user",
        firstName: "Ada",
        lastName: "Lovelace",
        country: "Japan",
        emailId: "ada@example.com",
        phoneNumber: "+1 555 0101",
        address: "1 Main St, New York, NY, 10001",
        engagementExperience: "Assigned",
        projectNames: "Project Alpha, Project Beta",
      },
      {
        handle: "applicant_user",
        firstName: "Grace",
        lastName: "Hopper",
        country: "Sri Lanka",
        emailId: "applicant@example.com",
        phoneNumber: "222-222-2222",
        address: "Applicant Address",
        engagementExperience: "Applicant",
        projectNames: "",
      },
    ]);

    expect(sql.load).toHaveBeenCalledWith(
      "reports/topcoder/engagement-data.sql",
    );
    expect(sql.load).toHaveBeenCalledWith(
      "reports/topcoder/engagement-data-members.sql",
    );
    expect(sql.load).toHaveBeenCalledWith(
      "reports/topcoder/engagement-data-projects.sql",
    );
    expect(engagementsPoolQuery).toHaveBeenCalledWith(
      "reports/topcoder/engagement-data.sql",
    );
    expect(db.query).toHaveBeenCalledTimes(2);
    expect(db.query).toHaveBeenNthCalledWith(
      1,
      "reports/topcoder/engagement-data-members.sql",
      [["101", "202"]],
    );
    expect(db.query).toHaveBeenNthCalledWith(
      2,
      "reports/topcoder/engagement-data-projects.sql",
      [["p2", "p1"]],
    );
  });

  it("returns an empty list without running enrichment queries when no members qualify", async () => {
    engagementsPoolQuery.mockResolvedValueOnce({ rows: [] });

    await expect(service.getEngagementData()).resolves.toEqual([]);

    expect(db.query).not.toHaveBeenCalled();
  });
});
