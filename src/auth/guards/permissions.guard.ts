import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  UnauthorizedException,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { SCOPES_KEY } from "../decorators/scopes.decorator";
import { ScopeRoleAccess, UserRoles } from "../../app-constants";

@Injectable()
export class PermissionsGuard implements CanActivate {
  private static readonly adminRoles = new Set(
    Object.values(UserRoles).map((role) => role.toLowerCase()),
  );
  private static readonly scopedRoleAccess = new Map(
    Object.entries(ScopeRoleAccess).map(([scope, roles]) => [
      scope.toLowerCase(),
      new Set(roles.map((role) => role.toLowerCase())),
    ]),
  );

  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredScopes = this.reflector.getAllAndOverride<string[]>(
      SCOPES_KEY,
      [context.getHandler(), context.getClass()],
    );

    if (!requiredScopes) {
      return true;
    }

    const { authUser } = context.switchToHttp().getRequest();

    if (!authUser) {
      throw new UnauthorizedException("You are not authenticated.");
    }

    if (authUser.isMachine) {
      const scopes: string[] = authUser.scopes ?? [];
      if (this.hasRequiredScope(scopes, requiredScopes)) {
        return true;
      }
    } else {
      const roles: string[] = authUser.roles ?? [];
      if (this.isAdmin(roles)) {
        return true;
      }

      if (this.hasRequiredRoleAccess(roles, requiredScopes)) {
        return true;
      }

      const scopes: string[] = authUser.scopes ?? [];
      if (this.hasRequiredScope(scopes, requiredScopes)) {
        return true;
      }
    }

    throw new ForbiddenException(
      "You do not have the required permissions to access this resource.",
    );
  }

  private hasRequiredScope(
    scopes: string[],
    requiredScopes: string[],
  ): boolean {
    if (!scopes?.length) {
      return false;
    }

    const normalizedScopes = scopes.map((scope) => scope?.toLowerCase());
    return requiredScopes.some((scope) =>
      normalizedScopes.includes(scope?.toLowerCase()),
    );
  }

  private isAdmin(roles: string[]): boolean {
    return roles.some((role) =>
      PermissionsGuard.adminRoles.has(role?.toLowerCase()),
    );
  }

  private hasRequiredRoleAccess(
    roles: string[],
    requiredScopes: string[],
  ): boolean {
    if (!roles?.length || !requiredScopes?.length) {
      return false;
    }

    const normalizedRoles = roles.map((role) => role?.toLowerCase());
    return requiredScopes.some((scope) => {
      const allowedRoles = PermissionsGuard.scopedRoleAccess.get(
        scope?.toLowerCase(),
      );
      return (
        !!allowedRoles && normalizedRoles.some((role) => allowedRoles.has(role))
      );
    });
  }
}
