#!/bin/sh
set -e

echo "run db migration"
migrate -path /app/migration -database "$DB_SOURCE" -verbose up   # ← use “migrate”, not “/app/migrate”

echo "start the app"
exec "$@"
