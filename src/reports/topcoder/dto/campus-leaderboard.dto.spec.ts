import { plainToInstance } from "class-transformer";
import { validate } from "class-validator";
import {
  CampusChallengeFilter,
  CampusLeaderboardQueryDto,
} from "./campus-leaderboard.dto";

const toDto = (query: Record<string, unknown>) =>
  plainToInstance(CampusLeaderboardQueryDto, query);

describe("CampusLeaderboardQueryDto", () => {
  it("trims the group name and normalizes the challenge filter", async () => {
    const dto = toDto({ groupName: "  mecw  ", challengeFilter: " Campus " });

    await expect(validate(dto)).resolves.toEqual([]);
    expect(dto.groupName).toBe("mecw");
    expect(dto.challengeFilter).toBe(CampusChallengeFilter.Campus);
  });

  it("allows the challenge filter to be omitted", async () => {
    const dto = toDto({ groupName: "mecw" });

    await expect(validate(dto)).resolves.toEqual([]);
    expect(dto.challengeFilter).toBeUndefined();
  });

  it("requires a group name", async () => {
    const errors = await validate(toDto({ groupName: "   " }));

    expect(errors.map((error) => error.property)).toContain("groupName");
  });

  it("rejects unknown challenge filters", async () => {
    const errors = await validate(
      toDto({ groupName: "mecw", challengeFilter: "private" }),
    );

    expect(errors.map((error) => error.property)).toContain("challengeFilter");
  });
});
