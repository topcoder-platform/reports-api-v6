import { ChallengesReportsService } from "./challenges-reports.service";

describe("ChallengesReportsService", () => {
  const db = {
    query: jest.fn(),
  };
  const sql = {
    load: jest.fn(),
  };

  let service: ChallengesReportsService;

  beforeEach(() => {
    db.query.mockReset();
    sql.load.mockReset();
    sql.load.mockReturnValue("SELECT 1");
    service = new ChallengesReportsService(db as any, sql as any);
  });

  it("returns Marathon Match submitters with provisional and final score columns", async () => {
    db.query.mockResolvedValue([
      {
        userId: 88770025,
        handle: "devtest1400",
        email: "jmgasper+devtest140@gmail.com",
        firstName: "Dev",
        lastName: "Test",
        country: "Australia",
        isMarathonMatch: true,
        provisionalScore: null,
        finalScore: 96.42,
        finalRank: 1,
      },
      {
        userId: 22655076,
        handle: "liuliquan",
        email: "sathya+1@crowdfirst.org",
        firstName: "Liu",
        lastName: "Liquan",
        country: "China",
        isMarathonMatch: true,
        provisionalScore: 89.18,
        finalScore: null,
        finalRank: 2,
      },
    ]);

    const result = await service.getSubmitters({
      challengeId: "be34aea8-325f-4685-902d-0f356d5e76d0",
    });

    expect(sql.load).toHaveBeenCalledWith("reports/challenges/submitters.sql");
    expect(Object.keys(result[0])).toEqual([
      "userId",
      "handle",
      "email",
      "firstName",
      "lastName",
      "country",
      "provisionalScore",
      "finalScore",
      "finalRank",
    ]);
    expect(result).toEqual([
      {
        userId: 88770025,
        handle: "devtest1400",
        email: "jmgasper+devtest140@gmail.com",
        firstName: "Dev",
        lastName: "Test",
        country: "Australia",
        provisionalScore: null,
        finalScore: 96.42,
        finalRank: 1,
      },
      {
        userId: 22655076,
        handle: "liuliquan",
        email: "sathya+1@crowdfirst.org",
        firstName: "Liu",
        lastName: "Liquan",
        country: "China",
        provisionalScore: 89.18,
        finalScore: null,
        finalRank: 2,
      },
    ]);
  });

  it("returns Marathon Match winners with final scores when available", async () => {
    db.query.mockResolvedValue([
      {
        userId: 40158994,
        handle: "TCConnCopilot",
        email: "topcoderconnect+copilot@gmail.com",
        firstName: "TC",
        lastName: "Copilot",
        country: "Afghanistan",
        isMarathonMatch: true,
        provisionalScore: null,
        finalScore: 100,
        finalRank: 1,
      },
    ]);

    const result = await service.getWinners({
      challengeId: "be34aea8-325f-4685-902d-0f356d5e76d0",
    });

    expect(sql.load).toHaveBeenCalledWith("reports/challenges/winners.sql");
    expect(result).toEqual([
      {
        userId: 40158994,
        handle: "TCConnCopilot",
        email: "topcoderconnect+copilot@gmail.com",
        firstName: "TC",
        lastName: "Copilot",
        country: "Afghanistan",
        provisionalScore: null,
        finalScore: 100,
        finalRank: 1,
      },
    ]);
  });

  it("keeps standard challenge exports on the submissionScore shape", async () => {
    db.query.mockResolvedValue([
      {
        userId: 88778748,
        handle: "disnadiji",
        email: "disnadiji+4@gmail.com",
        firstName: "Disna",
        lastName: "Diji",
        country: "Japan",
        isMarathonMatch: false,
        submissionScore: 34.34,
      },
    ]);

    const result = await service.getValidSubmitters({
      challengeId: "3bb4d076-d2e7-4bd5-82ac-7eb4dd2d14a8",
    });

    expect(sql.load).toHaveBeenCalledWith(
      "reports/challenges/valid-submitters.sql",
    );
    expect(result).toEqual([
      {
        userId: 88778748,
        handle: "disnadiji",
        email: "disnadiji+4@gmail.com",
        firstName: "Disna",
        lastName: "Diji",
        country: "Japan",
        submissionScore: 34.34,
      },
    ]);
    expect(result[0]).not.toHaveProperty("provisionalScore");
    expect(result[0]).not.toHaveProperty("finalScore");
    expect(result[0]).not.toHaveProperty("finalRank");
  });
});
