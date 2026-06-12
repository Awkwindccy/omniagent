#!/bin/bash
set -e

echo "🚀 OmniAgent starting..."

# Ensure storage dirs
mkdir -p /app/server/storage/documents
mkdir -p /app/server/storage/vector-cache
mkdir -p /app/server/storage/models
mkdir -p /app/collector/hotdir
mkdir -p /app/collector/outputs

# Database migrations
cd /app/server
echo "📦 Running database migrations..."
npx prisma migrate deploy 2>&1 || echo "⚠️  Migration warning"

# Start collector in background
echo "📄 Starting document processor..."
cd /app/collector && node index.js &
sleep 2

# Start server (foreground)
echo "✅ OmniAgent ready on port 3001"
cd /app/server && exec node index.js
