# ---- Base Stage ----
FROM node:22-alpine AS base
WORKDIR /usr/src/app

# ---- Package Manager Stage ----
FROM base AS package-manager
# Pin pnpm so clean builds do not change behaviour when a new major is released.
RUN npm install --global pnpm@11.15.0

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
FROM base AS production
ENV NODE_ENV=production
# Copy built application from the build stage
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/sql ./sql
COPY --from=build /usr/src/app/data ./data
# Copy production dependencies from the deps stage
COPY --from=deps /usr/src/app/node_modules ./node_modules

# Expose the application port
EXPOSE 3000

# The command to run the application
CMD ["node", "dist/main.js"]
