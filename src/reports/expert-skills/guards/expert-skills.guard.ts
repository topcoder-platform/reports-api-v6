import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";
import {
  AuthUserLike,
  getNormalizedRoles,
  hasAccessToScopes,
  hasAdminRole,
} from "../../../auth/permissions.util";
import { Scopes, UserRoles } from "src/app-constants";

const ALLOWED_ROLES = new Set([UserRoles.TalentManager.toLowerCase()]);

const MACHINE_REQUIRED_SCOPES = [
  Scopes.AllReports,
  Scopes.TopcoderReports,
  Scopes.Member.ExpertSkills,
];

@Injectable()
export class ExpertSkillsGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const authUser: AuthUserLike | undefined = context
      .switchToHttp()
      .getRequest().authUser;

    if (!authUser) {
      throw new UnauthorizedException("You are not authenticated.");
    }

    if (authUser.isMachine) {
      if (hasAccessToScopes(authUser, MACHINE_REQUIRED_SCOPES)) {
        return true;
      }

      throw new ForbiddenException(
        "You do not have the required permissions to access this resource.",
      );
    }

    const roles = getNormalizedRoles(authUser);

    if (hasAdminRole(roles) || roles.some((role) => ALLOWED_ROLES.has(role))) {
      return true;
    }

    throw new ForbiddenException(
      "You do not have the required permissions to access this resource.",
    );
  }
}
