#!/bin/sh
set -e

echo "⏳ Waiting for database $DB_HOST:$DB_PORT..."

until pg_isready -h ${DB_HOST:-timescaledb} -p ${DB_PORT:-5432} -U ${DB_USER:-postgres}; do
  echo "Database not ready yet..."
  sleep 2
done

# Verify DB accepts queries
until PGPASSWORD=${DB_PASSWORD:-postgres} psql -h ${DB_HOST:-timescaledb} -U ${DB_USER:-postgres} -d ${DB_NAME:-trading} -c "SELECT 1" > /dev/null 2>&1; do
  echo "DB accepting connections but not ready for queries..."
  sleep 2
done

echo "✅ Database is ready! Running migrations..."

pnpm --filter backend-api run migration:run

echo "🚀 Starting backend-api..."
pnpm --filter backend-api run dev
