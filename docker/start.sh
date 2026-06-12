#!/bin/bash
set -e

echo "🚀 OmniAgent starting..."
echo "   Storage: ${STORAGE_DIR:-/app/server/storage}"

# Ensure storage dirs exist
mkdir -p /app/server/storage/documents
mkdir -p /app/server/storage/vector-cache
mkdir -p /app/server/storage/models
mkdir -p /app/server/storage/tmp

# Run database migrations
cd /app/server
echo "📦 Running database migrations..."
npx prisma migrate deploy 2>&1 || echo "⚠️  Migration warning (may be first run)"

# Start collector in background
echo "📄 Starting document processor..."
cd /app/collector && node index.js &
sleep 1

# Start server (foreground)
echo "✅ Starting OmniAgent on port 3001..."
cd /app/server && exec node index.js
