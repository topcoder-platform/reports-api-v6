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
});
