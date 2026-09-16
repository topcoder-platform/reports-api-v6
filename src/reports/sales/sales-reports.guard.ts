import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { Scopes, UserRoles } from "../../app-constants";
import { SCOPES_KEY } from "../../auth/decorators/scopes.decorator";
import {
  AuthUserLike,
  getNormalizedRoles,
  hasAdminRole,
  hasRequiredScope,
} from "../../auth/permissions.util";

/** Separates human Sales access from the machine-only WIN endpoint; neither grants a role/scope bypass. */
@Injectable()
export class SalesReportsGuard implements CanActivate {
  /** @param reflector Reads the WIN endpoint's explicit scope metadata. Does not throw. */
  constructor(private readonly reflector: Reflector) {}

  /**
   * Authorizes an already authenticated caller for the selected endpoint.
   * @param context Nest request containing middleware-verified authUser claims.
   * @returns True for Admin/Talent Manager humans on Sales, or scoped machines on WIN.
   * @throws UnauthorizedException for missing identity; ForbiddenException for other callers.
   */
  canActivate(context: ExecutionContext): boolean {
    const user = context
      .switchToHttp()
      .getRequest<{ authUser?: AuthUserLike }>().authUser;
    if (!user) throw new UnauthorizedException("You are not authenticated.");
    const scopes = this.reflector.getAllAndOverride<string[]>(SCOPES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (scopes) {
      if (
        user.isMachine === true &&
        hasRequiredScope(user.scopes, [Scopes.Sales])
      )
        return true;
    } else if (!user.isMachine) {
      const roles = getNormalizedRoles(user);
      if (
        hasAdminRole(roles) ||
        roles.includes(UserRoles.TalentManager.toLowerCase())
      )
        return true;
    }
    throw new ForbiddenException(
      "You do not have permission to access this sales report.",
    );
  }
}
