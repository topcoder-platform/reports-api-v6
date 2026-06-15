import {
  ExecutionContext,
  ForbiddenException,
  UnauthorizedException,
} from "@nestjs/common";
import { Scopes, UserRoles } from "src/app-constants";
import { MemberTalentReportGuard } from "./member-talent-report.guard";

type AuthUserFixture = {
  isMachine?: boolean;
  roles?: string[];
  role?: string | string[];
  scopes?: string[];
};

/**
 * Builds a minimal Nest execution context for guard unit tests.
 * @param authUser Optional authenticated-user fixture.
 * @returns Execution context with the supplied auth user on the request.
 */
function createExecutionContext(authUser?: AuthUserFixture): ExecutionContext {
  return {
    switchToHttp: () => ({
      getRequest: () => ({
        authUser,
      }),
    }),
  } as unknown as ExecutionContext;
}

describe("MemberTalentReportGuard", () => {
  const guard = new MemberTalentReportGuard();

  it("throws when no auth user is present", () => {
    expect(() => guard.canActivate(createExecutionContext())).toThrow(
      UnauthorizedException,
    );
  });

  it("allows administrator role access", () => {
    expect(
      guard.canActivate(
        createExecutionContext({
          roles: ["Administrator"],
        }),
      ),
    ).toBe(true);
  });

  it("allows role claim with topcoder administrator prefix", () => {
    expect(
      guard.canActivate(
        createExecutionContext({
          role: "Topcoder Administrator",
        }),
      ),
    ).toBe(true);
  });

  it("allows machine clients with all reports scope", () => {
    expect(
      guard.canActivate(
        createExecutionContext({
          isMachine: true,
          scopes: [Scopes.AllReports],
        }),
      ),
    ).toBe(true);
  });

  it("denies talent manager users", () => {
    expect(() =>
      guard.canActivate(
        createExecutionContext({
          roles: [UserRoles.TalentManager],
        }),
      ),
    ).toThrow(ForbiddenException);
  });

  it("denies machine clients without all reports scope", () => {
    expect(() =>
      guard.canActivate(
        createExecutionContext({
          isMachine: true,
          scopes: [Scopes.Member.MemberSearch],
        }),
      ),
    ).toThrow(ForbiddenException);
  });
});
