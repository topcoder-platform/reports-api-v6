import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";

import { Scopes, UserRoles } from "../../app-constants";
import { SCOPES_KEY } from "../decorators/scopes.decorator";
import {
  AuthUserLike,
  getNormalizedRoles,
  hasAccessToScopes,
} from "../permissions.util";

@Injectable()
export class TopcoderReportsGuard implements CanActivate {
  private static readonly completedProfilesRoles = new Set([
    UserRoles.TalentManager.toLowerCase(),
  ]);

  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const authUser = request.authUser;

    if (!authUser) {
      throw new UnauthorizedException("You are not authenticated.");
    }

    const requiredScopes = this.reflector.getAllAndOverride<string[]>(
      SCOPES_KEY,
      [context.getHandler(), context.getClass()],
    ) ?? [Scopes.TopcoderReports, Scopes.AllReports];

    if (hasAccessToScopes(authUser, requiredScopes)) {
      return true;
    }

    if (this.canAccessCompletedProfiles(context, authUser)) {
      return true;
    }

    throw new ForbiddenException(
      "You do not have the required permissions to access this resource.",
    );
  }

  private canAccessCompletedProfiles(
    context: ExecutionContext,
    authUser: AuthUserLike,
  ): boolean {
    const handlerName = context.getHandler().name;

    if (handlerName !== "getCompletedProfiles") {
      return false;
    }

    return getNormalizedRoles(authUser).some((role) =>
      TopcoderReportsGuard.completedProfilesRoles.has(role),
    );
  }
}
