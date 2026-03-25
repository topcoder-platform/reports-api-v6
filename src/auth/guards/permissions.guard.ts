import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  UnauthorizedException,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { SCOPES_KEY } from "../decorators/scopes.decorator";
import { hasAccessToScopes } from "../permissions.util";

@Injectable()
export class PermissionsGuard implements CanActivate {
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

    if (hasAccessToScopes(authUser, requiredScopes)) {
      return true;
    }

    throw new ForbiddenException(
      "You do not have the required permissions to access this resource.",
    );
  }
}
