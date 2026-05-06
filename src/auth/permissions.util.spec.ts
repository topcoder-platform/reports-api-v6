import { Scopes } from "../app-constants";
import { hasAccessToScopes, hasRequiredRoleAccess } from "./permissions.util";

describe("permissions.util", () => {
  it("allows topcoder-prefixed project manager roles for bulk member lookup", () => {
    expect(
      hasAccessToScopes(
        {
          roles: ["Topcoder Project Manager"],
        },
        [Scopes.Identity.UsersByHandles],
      ),
    ).toBe(true);
  });

  it("allows topcoder-prefixed talent manager roles for bulk member lookup", () => {
    expect(
      hasAccessToScopes(
        {
          roles: ["Topcoder Talent Manager"],
        },
        [Scopes.Identity.UsersByHandles],
      ),
    ).toBe(true);
  });

  it("allows topcoder-prefixed talent manager roles for recent member data", () => {
    expect(
      hasAccessToScopes(
        {
          roles: ["Topcoder Talent Manager"],
        },
        [Scopes.Member.RecentMemberData],
      ),
    ).toBe(true);
  });

  it("allows topcoder-prefixed talent manager roles for engagement data", () => {
    expect(
      hasAccessToScopes(
        {
          roles: ["Topcoder Talent Manager"],
        },
        [Scopes.Member.EngagementData],
      ),
    ).toBe(true);
  });

  it("normalizes comma-separated role claims before checking scoped access", () => {
    expect(
      hasRequiredRoleAccess("Topcoder Talent Manager, Topcoder User", [
        Scopes.Identity.UsersByHandles,
      ]),
    ).toBe(true);
  });

  it("does not promote manager roles to all-reports access", () => {
    expect(
      hasAccessToScopes(
        {
          roles: ["Topcoder Talent Manager"],
        },
        [Scopes.AllReports],
      ),
    ).toBe(false);
  });

  it("allows talent manager role for SFDC payments report scope", () => {
    expect(
      hasAccessToScopes(
        {
          roles: ["Topcoder Talent Manager"],
        },
        [Scopes.SFDC.PaymentsReport],
      ),
    ).toBe(true);
  });

  it("denies product manager role for SFDC payments report scope", () => {
    expect(
      hasAccessToScopes(
        {
          roles: ["Topcoder Product Manager"],
        },
        [Scopes.SFDC.PaymentsReport],
      ),
    ).toBe(false);
  });

  it("allows administrator role for SFDC payments report scope", () => {
    expect(
      hasAccessToScopes(
        {
          roles: ["Administrator"],
        },
        [Scopes.SFDC.PaymentsReport],
      ),
    ).toBe(true);
  });

  it("allows talent manager role for other SFDC report scopes", () => {
    expect(
      hasAccessToScopes(
        { roles: ["Topcoder Talent Manager"] },
        [Scopes.SFDC.BA, Scopes.SFDC.ChallengesReport],
      ),
    ).toBe(true);
  });
});
