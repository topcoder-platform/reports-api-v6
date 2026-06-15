import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";
import { Scopes, UserRoles } from "src/app-constants";
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
 * Allows administrator and Talent Manager users, or machine clients with
 * all-reports scope, to access the open-to-work Talent report and contact export.
 */
@Injectable()
export class MemberTalentReportGuard implements CanActivate {
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
