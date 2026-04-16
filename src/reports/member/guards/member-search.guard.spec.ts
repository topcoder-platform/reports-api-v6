import {
  ExecutionContext,
  ForbiddenException,
  UnauthorizedException,
} from "@nestjs/common";
import { Scopes, UserRoles } from "src/app-constants";
import { MemberSearchGuard } from "./member-search.guard";

type AuthUserFixture = {
  isMachine?: boolean;
  roles?: string[];
  role?: string | string[];
  scopes?: string[];
};

function createExecutionContext(authUser?: AuthUserFixture): ExecutionContext {
  return {
    switchToHttp: () => ({
      getRequest: () => ({
        authUser,
      }),
    }),
  } as unknown as ExecutionContext;
}

describe("MemberSearchGuard", () => {
  const guard = new MemberSearchGuard();

  it("throws when no auth user is present", () => {
    expect(() => guard.canActivate(createExecutionContext())).toThrow(
      UnauthorizedException,
    );
  });

  it("allows talent manager role access", () => {
    expect(
      guard.canActivate(
        createExecutionContext({
          roles: [UserRoles.TalentManager],
        }),
      ),
    ).toBe(true);
  });

  it("allows admin role access", () => {
    expect(
      guard.canActivate(
        createExecutionContext({
          roles: ["Administrator"],
        }),
      ),
    ).toBe(true);
  });

  it("allows machine clients with member search scope", () => {
    expect(
      guard.canActivate(
        createExecutionContext({
          isMachine: true,
          scopes: [Scopes.Member.MemberSearch],
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

  it("allows machine clients with topcoder reports scope", () => {
    expect(
      guard.canActivate(
        createExecutionContext({
          isMachine: true,
          scopes: [Scopes.TopcoderReports],
        }),
      ),
    ).toBe(true);
  });

  it("allows role claim with topcoder prefix", () => {
    expect(
      guard.canActivate(
        createExecutionContext({
          role: "Topcoder Talent Manager",
        }),
      ),
    ).toBe(true);
  });

  it("denies machine clients without required scopes", () => {
    expect(() =>
      guard.canActivate(
        createExecutionContext({
          isMachine: true,
          scopes: [Scopes.Identity.UsersByHandles],
        }),
      ),
    ).toThrow(ForbiddenException);
  });

  it("denies non-admin users without required role", () => {
    expect(() =>
      guard.canActivate(
        createExecutionContext({
          roles: [UserRoles.ProjectManager],
        }),
      ),
    ).toThrow(ForbiddenException);
  });
});
