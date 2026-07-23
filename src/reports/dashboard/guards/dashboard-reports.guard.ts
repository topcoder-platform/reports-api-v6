import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";
import { Scopes, UserRoles } from "../../../app-constants";
import {
  AuthUserLike,
  getNormalizedRoles,
  hasAccessToScopes,
  hasAdminRole,
} from "../../../auth/permissions.util";

const allowedHumanRoles = new Set<string>([
  UserRoles.TalentManager.toLowerCase(),
]);

/**
 * Protects dashboard JSON and CSV endpoints.
 *
 * Human callers must be Administrators or Talent Managers. Machine callers
 * must carry the all-reports scope.
 */
@Injectable()
export class DashboardReportsGuard implements CanActivate {
  /**
   * Evaluates the authenticated caller attached by the reports auth middleware.
   *
   * @param context Nest execution context for the incoming dashboard request.
   * @returns `true` when the caller may access dashboard data.
   * @throws UnauthorizedException when no authenticated caller is present.
   * @throws ForbiddenException when the caller lacks the required role or scope.
   */
  canActivate(context: ExecutionContext): boolean {
    const authUser: AuthUserLike | undefined = context
      .switchToHttp()
      .getRequest().authUser;

    if (!authUser) {
      throw new UnauthorizedException("You are not authenticated.");
    }

    if (authUser.isMachine) {
      if (hasAccessToScopes(authUser, [Scopes.AllReports])) {
        return true;
      }

      throw new ForbiddenException(
        "You do not have the required permissions to access this resource.",
      );
    }

    const roles = getNormalizedRoles(authUser);
    if (
      hasAdminRole(roles) ||
      roles.some((role) => allowedHumanRoles.has(role))
    ) {
      return true;
    }

    throw new ForbiddenException(
      "You do not have the required permissions to access this resource.",
    );
  }
}
