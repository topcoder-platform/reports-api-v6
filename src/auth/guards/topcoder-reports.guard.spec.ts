import { ExecutionContext, ForbiddenException } from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { Scopes as AppScopes, UserRoles } from "../../app-constants";
import { Scopes as RequiredScopes } from "../decorators/scopes.decorator";
import { TopcoderReportsGuard } from "./topcoder-reports.guard";

/**
 * Test controller used to attach scope metadata to representative topcoder handlers.
 * This mirrors how the real controller exposes class-level and method-level scopes.
 */
@RequiredScopes(AppScopes.AllReports, AppScopes.TopcoderReports)
class TestTopcoderReportsController {
  /**
   * Represents the Engagement Data route for guard metadata tests.
   * Returns no value because the handler body is not exercised in these unit tests.
   */
  @RequiredScopes(
    AppScopes.AllReports,
    AppScopes.TopcoderReports,
    AppScopes.Member.EngagementData,
  )
  getEngagementData(): undefined {
    return undefined;
  }

  /**
   * Represents the Recent Member Data route for guard metadata tests.
   * Returns no value because the handler body is not exercised in these unit tests.
   */
  @RequiredScopes(
    AppScopes.AllReports,
    AppScopes.TopcoderReports,
    AppScopes.Member.RecentMemberData,
  )
  getRecentMemberData(): undefined {
    return undefined;
  }

  /**
   * Represents a standard topcoder report route without extra role mappings.
   * Returns no value because the handler body is not exercised in these unit tests.
   */
  get90DayMemberSpend(): undefined {
    return undefined;
  }

  /**
   * Represents the Completed Profiles route that keeps a dedicated role exception.
   * Returns no value because the handler body is not exercised in these unit tests.
   */
  getCompletedProfiles(): undefined {
    return undefined;
  }
}

type TestHandlerName = keyof TestTopcoderReportsController;

/**
 * Builds the minimal execution context surface that the guard reads in these tests.
 * @param handlerName Handler name whose metadata should be evaluated.
 * @param authUser Auth user payload to expose on the mocked HTTP request.
 * @returns ExecutionContext-like object suitable for TopcoderReportsGuard.canActivate.
 */
function createExecutionContext(
  handlerName: TestHandlerName,
  authUser: { roles?: string[]; scopes?: string[]; isMachine?: boolean },
): ExecutionContext {
  return {
    getClass: () => TestTopcoderReportsController,
    getHandler: () => TestTopcoderReportsController.prototype[handlerName],
    switchToHttp: () => ({
      getRequest: () => ({
        authUser,
      }),
    }),
  } as unknown as ExecutionContext;
}

describe("TopcoderReportsGuard", () => {
  const guard = new TopcoderReportsGuard(new Reflector());

  it("allows talent managers to access engagement data via route scopes", () => {
    expect(
      guard.canActivate(
        createExecutionContext("getEngagementData", {
          roles: [UserRoles.TalentManager],
        }),
      ),
    ).toBe(true);
  });

  it("allows talent managers to access recent member data via route scopes", () => {
    expect(
      guard.canActivate(
        createExecutionContext("getRecentMemberData", {
          roles: [UserRoles.TalentManager],
        }),
      ),
    ).toBe(true);
  });

  it("does not expand talent manager access to standard topcoder reports", () => {
    expect(() =>
      guard.canActivate(
        createExecutionContext("get90DayMemberSpend", {
          roles: [UserRoles.TalentManager],
        }),
      ),
    ).toThrow(ForbiddenException);
  });

  it("preserves the completed profiles talent manager exception", () => {
    expect(
      guard.canActivate(
        createExecutionContext("getCompletedProfiles", {
          roles: [UserRoles.TalentManager],
        }),
      ),
    ).toBe(true);
  });
});
