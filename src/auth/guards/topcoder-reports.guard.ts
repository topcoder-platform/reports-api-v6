import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";

import { Scopes, AdminRoles, UserRoles } from "../../app-constants";

@Injectable()
export class TopcoderReportsGuard implements CanActivate {
  private static readonly adminRoles = new Set(
    Object.values(AdminRoles).map((role) => role.toLowerCase()),
  );
  private static readonly completedProfilesRoles = new Set([
    UserRoles.TalentManager.toLowerCase(),
  ]);

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const authUser = request.authUser;

    if (!authUser) {
      throw new UnauthorizedException("You are not authenticated.");
    }

    if (authUser.isMachine) {
      const scopes: string[] = authUser.scopes ?? [];
      if (this.hasRequiredScope(scopes)) {
        return true;
      }

      throw new ForbiddenException(
        "You do not have the required permissions to access this resource.",
      );
    }

    const roles: string[] = authUser.roles ?? [];
    if (
      this.isAdmin(roles) ||
      this.canAccessCompletedProfiles(context, roles)
    ) {
      return true;
    }

    throw new ForbiddenException(
      "You do not have the required permissions to access this resource.",
    );
  }

  private hasRequiredScope(scopes: string[]): boolean {
    const normalizedScopes = scopes.map((scope) => scope?.toLowerCase());
    return (
      normalizedScopes.includes(Scopes.TopcoderReports.toLowerCase()) ||
      normalizedScopes.includes(Scopes.AllReports.toLowerCase())
    );
  }

  private isAdmin(roles: string[]): boolean {
    return roles.some((role) =>
      TopcoderReportsGuard.adminRoles.has(role?.toLowerCase()),
    );
  }

  private canAccessCompletedProfiles(
    context: ExecutionContext,
    roles: string[],
  ): boolean {
    const handlerName = context.getHandler().name;

    if (handlerName !== "getCompletedProfiles") {
      return false;
    }

    return roles.some((role) =>
      TopcoderReportsGuard.completedProfilesRoles.has(role?.toLowerCase()),
    );
  }
}
