#!/bin/bash
set -e

echo "🚀 OmniAgent starting..."

# Ensure storage dirs
mkdir -p /app/server/storage/documents
mkdir -p /app/server/storage/vector-cache

# Database migrations
cd /app/server
echo "📦 Running database migrations..."
npx prisma migrate deploy 2>&1 || echo "⚠️  Migration warning — may be first run"

# Start server
echo "✅ Starting on port 3001..."
exec node index.js
