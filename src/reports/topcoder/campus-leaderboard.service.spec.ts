import { ForbiddenException, NotFoundException } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { DbService } from "../../db/db.service";
import { SqlLoaderService } from "../../common/sql-loader.service";
import { TopcoderReportsService } from "./topcoder-reports.service";
import { CampusChallengeFilter } from "./dto/campus-leaderboard.dto";

const GROUP_QUERY = "reports/topcoder/campus-leaderboard-group.sql";
const LEADERBOARD_QUERY = "reports/topcoder/campus-leaderboard.sql";

type Row = Record<string, unknown>;

const participationRow = (overrides: Row = {}): Row => ({
  userId: "1",
  handle: "member1",
  firstName: "Member",
  lastName: "One",
  photoURL: null,
  rating: null,
  ratingColor: null,
  groupJoinedAt: "2026-01-01T00:00:00.000Z",
  memberSince: "2025-01-01T00:00:00.000Z",
  challengeId: "c1",
  challengeName: "Challenge 1",
  challengeStatus: "COMPLETED",
  challengeType: "Challenge",
  challengeTrack: "Development",
  challengeEndDate: "2026-02-01T00:00:00.000Z",
  isCampusChallenge: true,
  isPublicChallenge: false,
  registeredAt: "2026-01-05T00:00:00.000Z",
  registered: true,
  submitted: false,
  passedReview: false,
  submittedDate: null,
  score: null,
  won: false,
  placement: null,
  ...overrides,
});

describe("TopcoderReportsService.getCampusLeaderboard", () => {
  let service: TopcoderReportsService;
  let groupRows: Row[];
  let leaderboardRows: Row[];

  beforeEach(() => {
    groupRows = [
      {
        groupId: "group-1",
        groupName: "MECW",
        groupOldId: null,
        privateGroup: false,
        callerIsMember: false,
      },
    ];
    leaderboardRows = [];

    const db = {
      query: jest.fn((query: string) => {
        if (query === GROUP_QUERY) {
          return groupRows;
        }

        if (query === LEADERBOARD_QUERY) {
          return leaderboardRows;
        }

        throw new Error(`Unexpected query: ${query}`);
      }),
    };

    service = new TopcoderReportsService(
      db as unknown as DbService,
      {
        load: jest.fn((query: string) => query),
      } as unknown as SqlLoaderService,
      {
        get: jest.fn((_key: string, defaultValue?: string) => defaultValue),
      } as unknown as ConfigService,
    );
  });

  it("throws when the group does not exist", async () => {
    groupRows = [];

    await expect(
      service.getCampusLeaderboard({ groupName: "nope" }),
    ).rejects.toBeInstanceOf(NotFoundException);
  });

  it("rejects non-members without report access for private groups", async () => {
    groupRows = [
      {
        groupId: "group-1",
        groupName: "MECW",
        groupOldId: null,
        privateGroup: true,
        callerIsMember: false,
      },
    ];

    await expect(
      service.getCampusLeaderboard(
        { groupName: "mecw" },
        { userId: 999, hasReportAccess: false },
      ),
    ).rejects.toBeInstanceOf(ForbiddenException);
  });

  it("allows group members and report readers to read private group leaderboards", async () => {
    groupRows = [
      {
        groupId: "group-1",
        groupName: "MECW",
        groupOldId: null,
        privateGroup: true,
        callerIsMember: true,
      },
    ];
    leaderboardRows = [participationRow()];

    await expect(
      service.getCampusLeaderboard({ groupName: "mecw" }, { userId: 1 }),
    ).resolves.toMatchObject({ group: { id: "group-1", name: "MECW" } });
  });

  it("includes members with no activity and counts one submission per challenge", async () => {
    leaderboardRows = [
      // Two submission rows collapse to a single submitted challenge in SQL, so
      // the service receives one row per member per challenge.
      participationRow({
        challengeId: "c1",
        submitted: true,
        passedReview: true,
        won: true,
        placement: 1,
      }),
      participationRow({ challengeId: "c2", submitted: true }),
      participationRow({ challengeId: "c3" }),
      participationRow({
        userId: "2",
        handle: "member2",
        challengeId: null,
        challengeName: null,
        registered: null,
        submitted: null,
        passedReview: null,
        won: null,
        groupJoinedAt: "2026-03-01T00:00:00.000Z",
      }),
    ];

    const result = await service.getCampusLeaderboard({ groupName: "mecw" });

    expect(result.summary).toEqual({
      totalMembers: 2,
      membersRegistered: 1,
      membersSubmitted: 1,
    });
    expect(result.members).toHaveLength(2);
    expect(result.members[0]).toMatchObject({
      rank: 1,
      handle: "member1",
      registrations: 3,
      submissions: 2,
      passingSubmissions: 1,
      wins: 1,
      hasActivity: true,
    });
    expect(result.members[0].challenges).toHaveLength(3);
    expect(result.members[1]).toMatchObject({
      rank: 2,
      handle: "member2",
      registrations: 0,
      submissions: 0,
      passingSubmissions: 0,
      wins: 0,
      hasActivity: false,
      challenges: [],
    });
  });

  it("ranks by wins, then passing submissions, then registrations, then signup time", async () => {
    leaderboardRows = [
      // One win, fewest registrations -> first.
      participationRow({
        userId: "1",
        handle: "winner",
        challengeId: "c1",
        submitted: true,
        passedReview: true,
        won: true,
        placement: 1,
      }),
      // No wins but a passing submission -> second.
      participationRow({
        userId: "2",
        handle: "passer",
        challengeId: "c1",
        submitted: true,
        passedReview: true,
      }),
      participationRow({ userId: "2", handle: "passer", challengeId: "c2" }),
      // No wins, no passing submissions, two registrations -> third.
      participationRow({ userId: "3", handle: "regular", challengeId: "c1" }),
      participationRow({ userId: "3", handle: "regular", challengeId: "c2" }),
      // Same activity as "later" but signed up earlier -> fourth.
      participationRow({
        userId: "4",
        handle: "earlier",
        challengeId: "c1",
        groupJoinedAt: "2026-01-01T00:00:00.000Z",
      }),
      participationRow({
        userId: "5",
        handle: "later",
        challengeId: "c1",
        groupJoinedAt: "2026-06-01T00:00:00.000Z",
      }),
    ];

    const result = await service.getCampusLeaderboard({ groupName: "mecw" });

    expect(
      result.members.map((member) => [member.handle, member.rank]),
    ).toEqual([
      ["winner", 1],
      ["passer", 2],
      ["regular", 3],
      ["earlier", 4],
      ["later", 5],
    ]);
  });

  it("shares a rank between members whose ranking criteria are identical", async () => {
    leaderboardRows = [
      participationRow({
        userId: "1",
        handle: "aaa",
        challengeId: "c1",
        groupJoinedAt: "2026-01-01T00:00:00.000Z",
      }),
      participationRow({
        userId: "2",
        handle: "bbb",
        challengeId: "c1",
        groupJoinedAt: "2026-01-01T00:00:00.000Z",
      }),
    ];

    const result = await service.getCampusLeaderboard({ groupName: "mecw" });

    expect(result.members.map((member) => member.rank)).toEqual([1, 1]);
  });

  it("filters counts and participation history by challenge visibility", async () => {
    leaderboardRows = [
      participationRow({
        challengeId: "campus-1",
        isCampusChallenge: true,
        isPublicChallenge: false,
        submitted: true,
        passedReview: true,
        won: true,
      }),
      participationRow({
        challengeId: "public-1",
        isCampusChallenge: false,
        isPublicChallenge: true,
        submitted: true,
      }),
    ];

    const campusOnly = await service.getCampusLeaderboard({
      groupName: "mecw",
      challengeFilter: CampusChallengeFilter.Campus,
    });
    expect(campusOnly.members[0]).toMatchObject({
      registrations: 1,
      submissions: 1,
      passingSubmissions: 1,
      wins: 1,
    });
    expect(
      campusOnly.members[0].challenges.map((entry) => entry.challengeId),
    ).toEqual(["campus-1"]);

    const publicOnly = await service.getCampusLeaderboard({
      groupName: "mecw",
      challengeFilter: CampusChallengeFilter.Public,
    });
    expect(publicOnly.members[0]).toMatchObject({
      registrations: 1,
      submissions: 1,
      passingSubmissions: 0,
      wins: 0,
    });
    expect(
      publicOnly.members[0].challenges.map((entry) => entry.challengeId),
    ).toEqual(["public-1"]);

    // The summary tiles always describe activity across every challenge.
    expect(publicOnly.summary).toEqual({
      totalMembers: 1,
      membersRegistered: 1,
      membersSubmitted: 1,
    });
  });
});
