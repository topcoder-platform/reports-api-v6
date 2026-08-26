import {
  ExecutionContext,
  ForbiddenException,
  UnauthorizedException,
} from "@nestjs/common";
import { UserRoles } from "src/app-constants";
import { ExpertSkillsGuard } from "./expert-skills.guard";

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

describe("ExpertSkillsGuard", () => {
  const guard = new ExpertSkillsGuard();

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

  it("allows role claim with topcoder talent manager prefix", () => {
    expect(
      guard.canActivate(
        createExecutionContext({
          role: "Topcoder Talent Manager",
        }),
      ),
    ).toBe(true);
  });

  it("denies machine clients even with report scopes", () => {
    expect(() =>
      guard.canActivate(
        createExecutionContext({
          isMachine: true,
          scopes: ["reports:all"],
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
