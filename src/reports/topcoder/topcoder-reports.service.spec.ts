import { ConfigService } from "@nestjs/config";
import { DbService } from "../../db/db.service";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { TopcoderReportsService } from "./topcoder-reports.service";

jest.mock("tc-core-library-js", () => ({
  auth: {
    m2m: jest.fn(() => ({
      getMachineToken: jest.fn().mockResolvedValue("machine-token"),
    })),
  },
}));

describe("TopcoderReportsService", () => {
  const originalFetch = global.fetch;

  let service: TopcoderReportsService;
  let sql: { load: jest.Mock };
  let config: { get: jest.Mock };
  let engagementsPoolQuery: jest.Mock;
  let fetchMock: jest.Mock;

  beforeEach(() => {
    sql = {
      load: jest.fn().mockReturnValue("SELECT * FROM engagement_data"),
    };

    config = {
      get: jest.fn((key: string, defaultValue?: string) => {
        switch (key) {
          case "TOPCODER_API_URL_BASE":
            return "https://api.topcoder.test";
          case "M2M_CLIENT_ID":
            return "client-id";
          case "M2M_CLIENT_SECRET":
            return "client-secret";
          case "AUTH0_URL":
            return defaultValue ?? "https://auth.example.com/oauth/token";
          case "AUTH0_AUDIENCE":
            return defaultValue ?? "https://api.topcoder.test";
          case "ENGAGEMENTS_DB_URL":
            return "postgresql://localhost:5432/engagements";
          default:
            return defaultValue;
        }
      }),
    };

    service = new TopcoderReportsService(
      {} as DbService,
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

    fetchMock = jest.fn((input: string) => {
      if (input.includes("/v6/members?")) {
        return Promise.resolve({
          json: jest.fn().mockResolvedValue([
            {
              userId: "101",
              handle: "assigned_user",
              firstName: "Ada",
              lastName: "Lovelace",
              email: "ada@example.com",
              country: "United States",
              addresses: [
                {
                  streetAddr1: "1 Main St",
                  city: "New York",
                  stateCode: "NY",
                  zip: "10001",
                },
              ],
              phones: [{ type: "mobile", number: "+1 555 0101" }],
            },
            {
              userId: "202",
              handle: null,
              firstName: null,
              lastName: null,
              email: null,
              country: "Canada",
              addresses: [],
              phones: [],
            },
          ]),
          ok: true,
        });
      }

      if (input.includes("/v6/projects/p1")) {
        return Promise.resolve({
          json: jest
            .fn()
            .mockResolvedValue({ id: "p1", name: "Project Alpha" }),
          ok: true,
        });
      }

      if (input.includes("/v6/projects/p2")) {
        return Promise.resolve({
          json: jest.fn().mockResolvedValue({ id: "p2", name: "Project Beta" }),
          ok: true,
        });
      }

      throw new Error(`Unexpected fetch call for ${input}`);
    });

    global.fetch = fetchMock as typeof global.fetch;
  });

  afterEach(() => {
    global.fetch = originalFetch;
    jest.clearAllMocks();
  });

  it("builds engagement data rows with member enrichment, fallbacks, and project names", async () => {
    await expect(service.getEngagementData()).resolves.toEqual([
      {
        handle: "assigned_user",
        firstName: "Ada",
        lastName: "Lovelace",
        country: "United States",
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
        country: "Canada",
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
    expect(engagementsPoolQuery).toHaveBeenCalledWith(
      "SELECT * FROM engagement_data",
    );
    expect(fetchMock).toHaveBeenCalledTimes(3);
  });
});
