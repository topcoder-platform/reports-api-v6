import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";
import { Scopes } from "src/app-constants";
import {
  AuthUserLike,
  getNormalizedRoles,
  hasAccessToScopes,
  hasAdminRole,
} from "../../../auth/permissions.util";

/**
 * Allows only administrator users, or machine clients with all-reports scope,
 * to access the open-to-work Talent report and contact export.
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

    if (hasAdminRole(getNormalizedRoles(authUser))) {
      return true;
    }

    throw new ForbiddenException(
      "You do not have the required permissions to access this resource.",
    );
  }
}
