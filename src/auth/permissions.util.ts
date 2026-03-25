import { AdminRoles, ScopeRoleAccess } from "../app-constants";

export type AuthUserLike = {
  isMachine?: boolean;
  roles?: string[] | string;
  role?: string[] | string;
  scopes?: string[] | string;
};

const topcoderRolePrefixPattern = /^topcoder\s+/i;

const adminRoles = new Set(
  Object.values(AdminRoles).map((role) => role.toLowerCase()),
);

const scopedRoleAccess = new Map(
  Object.entries(ScopeRoleAccess).map(([scope, roles]) => [
    scope.toLowerCase(),
    new Set(roles.map((role) => role.toLowerCase())),
  ]),
);

function normalizeClaims(
  values: readonly string[] | string | undefined,
  separator: RegExp,
): string[] {
  const normalizedValues = Array.isArray(values)
    ? values
    : typeof values === "string"
      ? values.split(separator)
      : [];

  return normalizedValues
    .map((value) => value?.trim().toLowerCase())
    .filter((value): value is string => !!value);
}

function normalizeRoles(
  values: readonly string[] | string | undefined,
): string[] {
  return normalizeClaims(values, /,/).map((role) =>
    role.replace(topcoderRolePrefixPattern, ""),
  );
}

function normalizeScopes(
  values: readonly string[] | string | undefined,
): string[] {
  return normalizeClaims(values, /\s+/);
}

/**
 * Returns normalized role claims from either `roles` or `role`.
 */
export function getNormalizedRoles(authUser?: AuthUserLike): string[] {
  return [
    ...normalizeRoles(authUser?.roles),
    ...normalizeRoles(authUser?.role),
  ];
}

/**
 * Returns true when the caller has any of the required scopes.
 * Scope comparisons are case-insensitive.
 */
export function hasRequiredScope(
  scopes: readonly string[] | string | undefined,
  requiredScopes: readonly string[] = [],
): boolean {
  const normalizedScopes = new Set(normalizeScopes(scopes));

  if (!normalizedScopes.size || !requiredScopes.length) {
    return false;
  }

  return requiredScopes.some((scope) =>
    normalizedScopes.has(scope?.toLowerCase()),
  );
}

/**
 * Returns true when the caller has one of the configured administrator roles.
 */
export function hasAdminRole(
  roles: readonly string[] | string | undefined,
): boolean {
  return normalizeRoles(roles).some((role) => adminRoles.has(role));
}

/**
 * Returns true when any required scope is mapped to one of the caller's roles.
 */
export function hasRequiredRoleAccess(
  roles: readonly string[] | string | undefined,
  requiredScopes: readonly string[] = [],
): boolean {
  const normalizedRoles = normalizeRoles(roles);

  if (!normalizedRoles.length || !requiredScopes.length) {
    return false;
  }

  return requiredScopes.some((scope) => {
    const allowedRoles = scopedRoleAccess.get(scope?.toLowerCase());
    return (
      !!allowedRoles && normalizedRoles.some((role) => allowedRoles.has(role))
    );
  });
}

/**
 * Evaluates report access using the same rules as the request guards:
 * machines need scopes, admins get full access, and human users can also
 * inherit access from role-to-scope mappings.
 */
export function hasAccessToScopes(
  authUser: AuthUserLike | undefined,
  requiredScopes: readonly string[] = [],
): boolean {
  if (!requiredScopes.length) {
    return true;
  }

  if (!authUser) {
    return false;
  }

  if (authUser.isMachine) {
    return hasRequiredScope(authUser.scopes, requiredScopes);
  }

  const roles = getNormalizedRoles(authUser);

  if (hasAdminRole(roles)) {
    return true;
  }

  if (hasRequiredRoleAccess(roles, requiredScopes)) {
    return true;
  }

  return hasRequiredScope(authUser.scopes, requiredScopes);
}
