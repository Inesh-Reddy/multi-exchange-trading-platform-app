# Stage 1: Build
FROM node:20 AS builder

RUN corepack enable
WORKDIR /usr/src/app

COPY . .
RUN pnpm install --frozen-lockfile

WORKDIR /usr/src/app/apps/web
RUN pnpm run build

# Stage 2: Runtime (Dev mode)
FROM node:20-alpine AS runner

RUN corepack enable
WORKDIR /usr/src/app

COPY --from=builder /usr/src/app ./

EXPOSE 3001
CMD ["pnpm", "dev", "--filter", "web"]
