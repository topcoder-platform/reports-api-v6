import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";

import { Scopes, UserRoles } from "../../app-constants";
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
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const authUser = request.authUser;

    if (!authUser) {
      throw new UnauthorizedException("You are not authenticated.");
    }

    if (
      hasAccessToScopes(authUser, [Scopes.TopcoderReports, Scopes.AllReports])
    ) {
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
