import { Scopes, UserRoles } from "../app-constants";
import {
  REPORTS_DIRECTORY,
  getAccessibleReportsDirectory,
} from "./report-directory.data";

describe("getAccessibleReportsDirectory", () => {
  it("returns the full directory for administrators", () => {
    expect(
      getAccessibleReportsDirectory({
        roles: [UserRoles.Admin],
      }),
    ).toEqual(REPORTS_DIRECTORY);
  });

  it("returns public reports plus all challenge reports for product managers", () => {
    const directory = getAccessibleReportsDirectory({
      roles: ["Product Manager"],
    });

    expect(Object.keys(directory).sort()).toEqual(["challenges", "statistics"]);
    expect(directory.challenges?.reports).toHaveLength(
      REPORTS_DIRECTORY.challenges?.reports.length ?? 0,
    );
    expect(directory.identity).toBeUndefined();
    expect(directory.sfdc).toBeUndefined();
    expect(directory.topcoder).toBeUndefined();
  });

  it("returns challenge reports and role-mapped identity reports for talent managers", () => {
    const directory = getAccessibleReportsDirectory({
      roles: ["Talent Manager"],
    });

    expect(Object.keys(directory).sort()).toEqual([
      "challenges",
      "identity",
      "statistics",
    ]);
    expect(directory.identity?.reports.map((report) => report.path)).toEqual([
      "/identity/users-by-handles",
    ]);
  });

  it("returns bulk member lookup for topcoder project managers", () => {
    const directory = getAccessibleReportsDirectory({
      roles: ["Project Manager"],
    });

    expect(directory.identity?.reports.map((report) => report.path)).toEqual([
      "/identity/users-by-handles",
    ]);
  });

  it("returns only scope-matched reports plus public reports for machine tokens", () => {
    const directory = getAccessibleReportsDirectory({
      isMachine: true,
      scopes: [Scopes.Challenge.SubmissionLinks],
    });

    expect(directory.challenges?.reports.map((report) => report.path)).toEqual([
      "/challenges/submission-links",
    ]);
    expect(directory.identity).toBeUndefined();
    expect(directory.sfdc).toBeUndefined();
    expect(directory.statistics?.reports.length).toBeGreaterThan(0);
    expect(directory.topcoder).toBeUndefined();
  });

  it("returns an empty directory when no JWT user is present", () => {
    expect(getAccessibleReportsDirectory()).toEqual({});
  });
});
