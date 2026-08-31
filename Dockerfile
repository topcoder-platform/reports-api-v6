ARG NODE_VERSION=26.5.1
ARG PNPM_VERSION=11.15.1

# ---- Build Base Stage ----
FROM node:${NODE_VERSION}-alpine AS base
WORKDIR /usr/src/app

# ---- Package Manager Stage ----
FROM base AS package-manager
# Pin pnpm so clean builds do not change behaviour when a new major is released.
ARG PNPM_VERSION
RUN npm install --global pnpm@${PNPM_VERSION}

# ---- Dependencies Stage ----
FROM package-manager AS deps
# Copy dependency-defining files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
# Install dependencies
RUN pnpm install --frozen-lockfile --prod

# ---- Build Stage ----
FROM package-manager AS build
COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY . .
# Build the application
RUN pnpm build

# ---- Production Stage ----
FROM alpine:3.24 AS production
ARG NODE_VERSION
ENV NODE_ENV=production
WORKDIR /usr/src/app

# Use Alpine's dynamically linked Node runtime so patched system OpenSSL packages
# can be upgraded independently. The final image intentionally contains no npm or
# pnpm executable and runs as a dedicated unprivileged account.
RUN apk upgrade --no-cache \
    && apk add --no-cache ca-certificates nodejs-current=${NODE_VERSION}-r0 \
    && addgroup -S -g 10001 app \
    && adduser -S -D -u 10001 -G app -h /home/app app

# Copy built application from the build stage
COPY --from=build --chown=app:app /usr/src/app/dist ./dist
COPY --from=build --chown=app:app /usr/src/app/sql ./sql
COPY --from=build --chown=app:app /usr/src/app/data ./data
# Copy production dependencies from the deps stage
COPY --from=deps --chown=app:app /usr/src/app/node_modules ./node_modules

# Expose the application port
EXPOSE 3000

# Do not grant report execution or database access through the container user.
USER app

# The command to run the application
CMD ["node", "dist/main.js"]
