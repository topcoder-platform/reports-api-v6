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

@Injectable()
export class AdminPaymentReportsGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const authUser: AuthUserLike | undefined = context
      .switchToHttp()
      .getRequest().authUser;

    if (!authUser) {
      throw new UnauthorizedException("You are not authenticated.");
    }

    if (authUser.isMachine) {
      throw new ForbiddenException(
        "You do not have the required permissions to access this resource.",
      );
    }

    const roles = getNormalizedRoles(authUser);

    if (hasAdminRole(roles)) {
      return true;
    }

    throw new ForbiddenException(
      "You do not have the required permissions to access this resource.",
    );
  }
}
