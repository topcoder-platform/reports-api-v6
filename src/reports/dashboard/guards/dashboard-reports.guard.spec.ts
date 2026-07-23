import {
  ExecutionContext,
  ForbiddenException,
  UnauthorizedException,
} from "@nestjs/common";
import { Scopes, UserRoles } from "../../../app-constants";
import { DashboardReportsGuard } from "./dashboard-reports.guard";

type AuthUserFixture = {
  isMachine?: boolean;
  roles?: string[] | string;
  role?: string[] | string;
  scopes?: string[] | string;
};

/**
 * Builds a minimal Nest execution context for dashboard guard tests.
 *
 * @param authUser Optional authenticated-user fixture.
 * @returns Execution context exposing the fixture on the HTTP request.
 */
function createExecutionContext(authUser?: AuthUserFixture): ExecutionContext {
  return {
    switchToHttp: () => ({
      getRequest: () => ({ authUser }),
    }),
  } as unknown as ExecutionContext;
}

describe("DashboardReportsGuard", () => {
  const guard = new DashboardReportsGuard();

  it("rejects unauthenticated callers", () => {
    expect(() => guard.canActivate(createExecutionContext())).toThrow(
      UnauthorizedException,
    );
  });

  it.each([
    { roles: ["Administrator"] },
    { role: "Topcoder Administrator" },
    { roles: [UserRoles.TalentManager] },
    { role: "Topcoder Talent Manager" },
  ])("allows an authorized human role: %o", (authUser) => {
    expect(guard.canActivate(createExecutionContext(authUser))).toBe(true);
  });

  it("allows machine clients with the all-reports scope", () => {
    expect(
      guard.canActivate(
        createExecutionContext({
          isMachine: true,
          scopes: [Scopes.AllReports],
        }),
      ),
    ).toBe(true);
  });

  it("accepts a space-delimited machine scope claim", () => {
    expect(
      guard.canActivate(
        createExecutionContext({
          isMachine: true,
          scopes: `openid ${Scopes.AllReports}`,
        }),
      ),
    ).toBe(true);
  });

  it.each([
    { roles: [UserRoles.ProductManager] },
    { scopes: [Scopes.AllReports] },
    { isMachine: true, scopes: [Scopes.Member.MemberSearch] },
  ])("rejects an unauthorized caller: %o", (authUser) => {
    expect(() => guard.canActivate(createExecutionContext(authUser))).toThrow(
      ForbiddenException,
    );
  });
});
