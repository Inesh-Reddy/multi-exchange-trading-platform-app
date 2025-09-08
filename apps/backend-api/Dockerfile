# ---- Base stage ----
FROM node:20 AS base
WORKDIR /usr/src/app

RUN npm install -g pnpm

COPY pnpm-lock.yaml pnpm-workspace.yaml ./
COPY package.json ./
COPY apps ./apps
COPY packages ./packages

RUN pnpm install --frozen-lockfile

# ---- Build stage ----
FROM base AS build
RUN pnpm --filter backend-api run build

# ---- Runtime stage ----
FROM node:20 AS runtime
WORKDIR /usr/src/app

RUN npm install -g pnpm \
  && apt-get update \
  && apt-get install -y --no-install-recommends postgresql-client-15 \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/src/app ./

EXPOSE 3000

CMD pnpm --filter backend-api run migration:run && pnpm --filter backend-api run dev

# FROM node:20 AS runtime
# WORKDIR /usr/src/app

# # Install pnpm + psql client
# RUN npm install -g pnpm \
#   && apt-get update \
#   && apt-get install -y --no-install-recommends postgresql-client-15 \
#   && rm -rf /var/lib/apt/lists/*

# COPY apps/backend-api/scripts/wait-and-migrate.sh ./apps/backend-api/scripts/wait-and-migrate.sh
# RUN chmod +x ./apps/backend-api/scripts/wait-and-migrate.sh

# COPY --from=build /usr/src/app ./

# EXPOSE 3000
# CMD ["pnpm", "--filter", "backend-api", "run", "dev"]



