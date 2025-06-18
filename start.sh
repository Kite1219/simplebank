#!/bin/sh
set -e

echo "run db migration"
# Load environment variables if they are not already set
if [ -z "$DB_SOURCE" ]; then
  . /app/app.env
fi
migrate -path /app/migration -database "$DB_SOURCE" -verbose up   # ← use “migrate”, not “/app/migrate”

echo "start the app"
exec "$@"
