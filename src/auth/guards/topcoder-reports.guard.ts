import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";

import { Scopes } from "../../app-constants";
import { hasAccessToScopes } from "../permissions.util";

@Injectable()
export class TopcoderReportsGuard implements CanActivate {
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

    throw new ForbiddenException(
      "You do not have the required permissions to access this resource.",
    );
  }
}
