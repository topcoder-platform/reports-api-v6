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
  hasAdminRole,
} from "../../auth/permissions.util";
import { UserRoles } from "src/app-constants";

const ALLOWED_ROLES = new Set([UserRoles.TalentManager.toLowerCase()]);

@Injectable()
export class ExpertSkillsGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const authUser: AuthUserLike | undefined = context
      .switchToHttp()
      .getRequest().authUser;

    if (!authUser) {
      throw new UnauthorizedException("You are not authenticated.");
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
