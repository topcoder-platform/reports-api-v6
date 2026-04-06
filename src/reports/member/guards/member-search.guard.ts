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
} from "../../../auth/permissions.util";

/** Roles (normalised, lower-cased) that are allowed to access talent-search. */
const ALLOWED_ROLES = new Set(["talent manager"]);

@Injectable()
export class MemberSearchGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const authUser: AuthUserLike | undefined =
      context.switchToHttp().getRequest().authUser;

    if (!authUser) {
      throw new UnauthorizedException("You are not authenticated.");
    }

    const roles = getNormalizedRoles(authUser);

    if (hasAdminRole(roles) || roles.some((r) => ALLOWED_ROLES.has(r))) {
      return true;
    }

    throw new ForbiddenException(
      "You do not have the required permissions to access this resource.",
    );
  }
}
